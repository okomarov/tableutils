function install_tableutils(mode)
% INSTALL_TABLEUTILS Adds path and new methods to table()
%
% To uninstall, use install_tableutils('uninstall')

if nargin < 1 || isempty(mode), mode = 'install'; end
switch mode
    case 'install'
        install_();
    case {'uninstall','fulluninstall'}
        uninstall_(mode);
    otherwise
        error('MODE "%s" unrecognized.',mode)
end
% To force a refresh on methods(table)
clear table
rehash toolboxcache
end

function install_()

% Create detination fodler
destination = fullfile(matlabroot,'toolbox','local','myfiles','tableutils');
if ~isdir(destination)
    mkdir(destination);
end

% Copy native methods
tableFolder = fullfile(matlabroot,'toolbox','matlab','datatypes','@table');
copyfile(tableFolder, fullfile(destination,'@table'))

% Override and add new methods
tableUtilsFolder = fileparts(mfilename('fullpath'));
copyfile(tableUtilsFolder,destination)

% Add and save path, excluding previously added but not saved paths
currentPath = path();
path(pathdef())
addpath(destination)
savepath
path(currentPath)
addpath(destination)

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