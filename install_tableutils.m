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

tableFolder = fileparts(which('table'));
try
    % Backup old methods into +old folder
    privfolder = fullfile(tableFolder,'private');
    movefun    = @(funname) movefile([fullfile(tableFolder,funname) '.m'],...
                                      [fullfile(privfolder,funname)  'Old.m']);
    movefun('disp')
    movefun('unstack')
    movefun('varfun')

    % Add methods
    mycopyfile = @(funname) copyfile(fullfile(tableUtilsFolder,'methods',funname),...
                                     fullfile(tableFolder,funname));

    mycopyfile('disp.m')
    mycopyfile('unstack.m')
    mycopyfile('varfun.m')
    mycopyfile('classVarNames.m')
    mycopyfile('convertColumn.m')
    mycopyfile('renameVarNames.m')

catch
    % Use fallback methods
    s = ['Could not copy methods to "%s".\n\n',...
         'Will use fallback methods:\n',...
         '\t* buffered table disp() unavailable;\n',...
         '\t* fast unstack() unavailable;\n ',...
         '\t* new methods are available but cannot be listed with methods(table).'];
    warning(s,tableFolder)

    answer = input('Continue [Y]/n: ','s');
    if ~(isempty(answer) || strcmpi(answer,'y'))
        error('Installation aborted.')
    end

    % Add methods
    fallbackFolder = fullfile(tableUtilsFolder,'methods','fallback');

    mycopyfile = @(funname) copyfile(fullfile(fallbackFolder,funname),...
                                     fullfile(tableUtilsFolder,funname));
    mycopyfile('varfun.m')
    mycopyfile('classVarNames.m')
    mycopyfile('convertColumn.m')
    mycopyfile('renameVarNames.m')
end
fprintf('Installation complete.\n')
end

function uninstall_()
% Remove path
tableUtilsFolder = fileparts(mfilename('fullpath'));
rmpath(tableUtilsFolder);

% Move back native functions
tableFolder = fileparts(which('table'));
privfolder  = fullfile(tableFolder,'private');
movefun     = @(funname) movefile([fullfile(privfolder,funname)  'Old.m'],...
                                  [fullfile(tableFolder,funname) '.m']);
movefun('disp')
movefun('unstack')
movefun('varfun')

% Remove new methods
mydelete = @(funname) delete(fullfile(tableFolder, funname));
mydelete('classVarNames.m')
mydelete('convertColumn.m')
mydelete('renameVarNames.m')
end
