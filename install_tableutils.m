function install_tableutils()
% INSTALL_TABLEUTILS Adds path and new methods to table()
%
% NOTE: Old methods are backed up into @table\private\
%       and appending 'Old' to the method name

% Add tableutils path and save, excluding previously added but not saved paths 
currentPath = path();
path(pathdef())
tableUtilsFolder = fileparts(mfilename('fullpath'));
addpath(tableUtilsFolder)
savepath
path(currentPath)
addpath(tableUtilsFolder)

try
    % Backup old methods into +old folder
    tableFolder = fileparts(which('table'));
    privfolder  = fullfile(tableFolder,'private');
    movefun     = @(funname) movefile([fullfile(tableFolder,funname) '.m'],...
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

    fprintf('Installation complete.\n')
catch
    fprintf('Installation partially complete.\n')
    error('Cannot install new methods.\nNo write permissions in "%s".',privfolder)
end
end
