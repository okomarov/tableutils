function b = varfun(fun,a,varargin)

% VARFUN Apply a function to each variable of a table
% 
%   Since TABLE/VARFUN automatically pre-pends the variable names
%   with the function name, this wrapper additionally accepts the 
%   option 'VariableNames'.
%   
% Example:
%   
%   myVar = rand(10,1);
%   tb    = table(myVar);
%   tb    = varfun(@uint32, tb, 'VariableNames','UintVar')
%
% See also: TABLE

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 24 Mar 2015 - Created

% Extract variable names option
pos = find(strcmpi('VariableNames', varargin));
if pos ~= 0
    outputNames = varargin{pos+1};
    varargin(pos:pos+1) = [];
end

% Call builtin method
b = builtin('varfun', fun, a, varargin);

% If output not a table
pos = find(strcmpi('OutputFormat', varargin));
if pos ~= 0 && ~strcmpi(varargin{pos+1}, 'table')
    return
end

% Extract eventual input variables
pos = find(strcmpi('InputVariables', varargin));
if pos ~= 0
    inputVars = varargin{pos+1};
    if isstring(inputVars) || iscellstr(inputVars)
        [~, inputVars] = ismember(inputVars, a.Properties.VariableNames);
    end
end

% Rename variables
b = renameVarNames(b, outputNames, inputVars);

end