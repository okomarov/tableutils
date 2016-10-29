function install_tableutils(mode)
% INSTALL_TABLEUTILS Adds path and new methods to table()
%
% To uninstall, use install_tableutils('uninstall')

v = regexp(version,'R\d{4}\w','match');

if nargin < 1 || isempty(mode), mode = 'install'; end
switch mode
    case 'install'
        install_(v{1});
    case {'uninstall','fulluninstall'}
        uninstall_(mode);
    otherwise
        error('MODE "%s" unrecognized.',mode)
end
% To force a refresh on methods(table)
clear table
rehash toolboxcache
end

function install_(v)
switch v
    case 'R2016a'
        targetClass = '@table';

    case 'R2016b'
        targetClass = '@tabular';
    
    otherwise
        targetClass = '@table';
        warning('Your Matlab version might not be supported.\n')
end

% Create destination folder
destination = fullfile(matlabroot,'toolbox','local','myfiles','tableutils');
if ~isdir(destination)
    mkdir(destination);
end

% Copy native methods
classFolder = fullfile(matlabroot,'toolbox','matlab','datatypes',targetClass);
copyfile(classFolder, fullfile(destination,targetClass))

% Override and add new methods
tableUtilsFolder = fileparts(mfilename('fullpath'));
copyfile(fullfile(tableUtilsFolder, v),destination)
copyfile(fullfile(tableUtilsFolder, '*.m'),destination)

% Add and save path, excluding previously added but not saved paths
currentPath = path();
path(pathdef())
addpath(destination)
savepath
path(currentPath)
addpath(destination)

upath = strrep(userpath,';','');
fprintf('Changing directory to "%s".\n', upath)
cd(upath)

fprintf('Installation complete.\n')
end

function uninstall_(mode)
% Remove path
destination = fullfile(matlabroot,'toolbox','local','myfiles','tableutils');
rmpath(destination)

if strcmpi(mode, 'fulluninstall')
    rmdir(destination,'s')
end
fprintf('Disinstallation complete.\n')
end
