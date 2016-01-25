function t = convertColumn(t, newclass, vars)
% CONVERTCOLUMN Convert type of variable names in a table
%
%   CONVERTCOLUMN(T, NEWCLASS) Cast all variables (columns) of a table T to
%                              NEWCLASS, e.g. 'uint8'.
%
%   CONVERTCOLUMN(T, NEWCLASS, VARS) Cast to NEWCLASS the variables
%                                    contained in VARS. VARS can be a
%                                    string, a cell array of string, a
%                                    vector of indices or a logical vector.
%
%
%   NEWT = ... Returns a table with the converted variables
%
%
% Example:
%
%   t  = table(['M';'F';'M'], [45;32;34], {'NY';'CA';'MA'}, logical([1;0;0]),...
%              'VariableNames', {'Gender' 'Age' 'State' 'Vote'});
%   t1 = convertColumn(t, 'uint8','Age')
%   t2 = convertColumn(t, 'double', 4)
%
% See also: TABLE, CAST

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 13 Mar 2015 - Created

if ~isrowchar(newclass)
    error('convertColumn:invalidString','NEWCLASS should be a string.')
end

if nargin < 3 || isempty(vars)
    % Convert all
    vars = ':';
end

try
    indices = getVarIndices(t,vars);
catch
    % Delegate error checking
    tmp     = t(1,vars);
    indices = tmp.Properties.VariableNames;
end

% Convert
for ii = 1:numel(indices)
    v = indices(ii);
    try
        t.data{v} = cast(t.data{v}, newclass);
    catch
        t.(char(v)) = cast(t.(char(v)), newclass);
    end
end
end
