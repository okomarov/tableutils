function b = varfun(fun,a,varargin)

% VARFUN Apply a function to each variable of a table
% 
%   Since TABLE/VARFUN automatically pre-pends the variable names
%   with the function name, this wrapper additionally accepts the 
%   name/value pair: 'RenameVariables', true(default)/false.
%   
% Example:
%   
%   myVar = rand(10,1);
%   tb    = table(myVar);
%   tb    = varfun(@uint32, tb, 'RenameVariables', false)
%
% See also: TABLE

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 24 Mar 2015 - Created

% Parse name/value pairs
pnames = {'GroupingVariables' 'InputVariables' 'OutputFormat' 'RenameVariables'};
dflts =  {                []               ':'        'table'             true };
[groupVars,dataVars,outputFormat,renameVars,supplied] ...
    = matlab.internal.table.parseArgs(pnames, dflts, varargin{:});

% Extarct RenameVariables from varargin
if supplied.RenameVariables
    pos = find(strcmpi('RenameVariables', varargin));
    varargin(pos:pos+1) = [];
end

% Call builtin method
b = varfun(fun, a, varargin{:});

% Terminate if output not a table
if supplied.OutputFormat && ~strcmpi(outputFormat, 'table')
    return
end
% Terminate if we prepend Func_* by default
if ~supplied.RenameVariables || renameVars
    return
end

% Variable names to keep
if supplied.InputVariables
    inputVars = ':';
    if isnumeric(dataVars) || islogical(dataVars)
        outputNames = a.Properties.VariableNames(dataVars);
    else
        outputNames = dataVars;
    end
end
if supplied.GroupingVariables
    if isnumeric(groupVars) || islogical(groupVars)
        groupVars   = [a.Properties.VariableNames(groupVars), 'GroupCount'];
    else
        groupVars   = [groupVars, {'GroupCount'}];
    end
    inputVars   = ~ismember(b.Properties.VariableNames, groupVars);
    outputNames = outputNames(~ismember(outputNames, groupVars));
end

% Rename variables
b = renameVarNames(b, outputNames, inputVars);

end