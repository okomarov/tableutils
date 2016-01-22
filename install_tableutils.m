function install_tableutils(mode)
% INSTALL_TABLEUTILS Adds path and new methods to table()
%
% NOTE: Old methods are backed up into @table\private\
%       and appending 'Old' to the method name
%
% To uninstall, use install_tableutils('uninstall')

if nargin < 1 || isempty(mode), mode = 'install'; end
switch mode
    case 'install'
        install_();
    case 'uninstall'
        uninstall_();
    otherwise
        error('MODE "%s" unrecognized.',mode)
end
% To force a refresh on methods(table)
clear table
end

function install_()
% Add tableutils path and save, excluding previously added but not saved paths
currentPath      = path();
path(pathdef())
tableUtilsFolder = fileparts(mfilename('fullpath'));
addpath(tableUtilsFolder)
savepath
path(currentPath)
addpath(tableUtilsFolder)

if exist(fullfile(tableUtilsFolder,'settings.json'),'file')
    warning('table methods already installed. Uninstall and re-install if necessary.')
    return
end

tableFolder = fileparts(which('table'));
try
    % Backup old methods into +old folder
    privfolder = fullfile(tableFolder,'private');
    movefun    = @(funname) movefile([fullfile(tableFolder,funname) '.m'],...
                                      [fullfile(privfolder,funname)  'Old.m']);
    list       = oldMethods();
    cellfun(@(x) movefun(x), list)

    % Add methods
    mycopyfile = @(funname) copyfile([fullfile(tableUtilsFolder,'methods',funname), '.m'],...
                                     [fullfile(tableFolder,funname), '.m']);

    list       = unique([newMethods() oldMethods()]);
    cellfun(@(x) mycopyfile(x), list)

    % Keep track of installation state
    fid = fopen(fullfile(tableUtilsFolder,'settings.json'),'w');
    fprintf(fid, '{"installation":"full"}');
    fclose(fid);

catch ME
    % Use fallback methods
    s = ['could not copy methods to "%s".\n\n',...
         'Will use fallback methods:\n',...
         '\t* buffered table disp() unavailable;\n',...
         '\t* fast unstack() unavailable;\n ',...
         '\t* new methods are available but cannot be listed with methods(table).'];
    warning(s,tableFolder)

    answer = input('Continue [Y]/n: ','s');
    if ~(isempty(answer) || strcmpi(answer,'y'))
        rethrow(ME)
    end

    % Add methods
    fallbackFolder = fullfile(tableUtilsFolder,'methods','fallback');

    mycopyfile = @(funname) copyfile([fullfile(fallbackFolder,funname),'.m'],...
                                     [fullfile(tableUtilsFolder,funname),'.m']);
    list       = oldMethods();
    cellfun(@(x) mycopyfile(x), list)

    % Keep track of installation state
    fid = fopen(fullfile(tableUtilsFolder,'settings.json'),'w');
    fprintf(fid, '{"installation":"fallback"}');
    fclose(fid);
end
fprintf('Installation complete.\n')
end

function uninstall_()
% Remove path
tableUtilsFolder = fileparts(mfilename('fullpath'));
rmpath(tableUtilsFolder);

if ~exist(fullfile(tableUtilsFolder,'settings.json'),'file')
    warning('table methods are not installed.')
    return
end

try
    % Remove new methods
    tableFolder = fileparts(which('table'));
    mydelete    = @(funname) delete([fullfile(tableFolder, funname),'.m']);
    list        = newMethods();
    cellfun(@(x) mydelete(x), list)

    % Move back native functions
    privfolder = fullfile(tableFolder,'private');
    movefun    = @(funname) movefile([fullfile(privfolder,funname)  'Old.m'],...
                                     [fullfile(tableFolder,funname) '.m']);
    list       = oldMethods();
    cellfun(@(x) movefun(x), list)

    delete(fullfile(tableUtilsFolder,'settings.json'))
catch ME
    warning('Could not complete uninstallation. Try manual uninstallation.')
    rethrow(ME)
end
fprintf('Uninstalled.\n')
end

function list = oldMethods()
list = {'table','disp','unstack','varfun'};
end

function list = newMethods()
% Only those that have a fallback
list = {'varfun','classVarNames','convertColumn','renameVarNames','ismatrixlike','transpose'};
end
