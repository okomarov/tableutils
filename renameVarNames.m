function t = renameVarNames(t, newvars, oldvars)

% RENAMEVARNAMES Renames variable names of a table
%
%   RENAMEVARNAMES(T, NEWVARS) Rename all variable names of a table T to 
%                              the names in NEWVARS, in the order they 
%                              appear. NEWVARS should be a cell arrays of 
%                              strings containing one name for each 
%                              variable in T.
%
%   RENAMEVARNAMES(T, NEWVARS, OLDVARS) Rename to NEWVARS the variables 
%                                       contained in OLDVARS. OLDVARS can 
%                                       a string, a cell array of strings,
%                                       a vector of indices or a logical
%                                       vector.
%                                           
%   
%   NEWT = ... Returns a table with the variable names renamed
%
%
% Example:
%   
%   t  = table(['M';'F';'M'], [45;32;34], {'NY';'CA';'MA'}, logical([1;0;0]))
%   t1 = renameVarNames(t, {'Gender' 'Age' 'State' 'Vote'})
%   t2 = renameVarNames(t, {'Age' 'State'}, [false,true,true,false])
%   t3 = renameVarNames(t, {'Age' 'State'}, 2:3)
%   t4 = renameVarNames(t, {'Age' 'State'}, {'Var2','Var3'})
%
% See also: TABLE, <a href="matlab:doc tableproperties"> TABLE PROPERTIES</a>

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 13 Mar 2015 - Created

% Wrap in a cell
if isstring(newvars), newvars = {newvars}; end

if nargin < 3 || isempty(oldvars)
    % Rename all
    t.Properties.VariableNames = newvars; 
else
    % Check name count
    if islogical(oldvars)
        nold = nnz(oldvars);
    elseif ischar(oldvars)
        if oldvars == ':'
            nold = width(t);
        else
            nold = 1;
        end
    else
        nold = numel(oldvars);
    end
    if nold ~= numel(newvars)
        error('renameVarNames:numElementsMismatch','NEWVARS should have a name for each OLDVARS.')
    end
    
    % Delegate error checking
    t(1,oldvars);
   
    % Rename selected
    if iscellstr(oldvars)
        allvars = t.Properties.VariableNames;
        [~,pos] = ismember(oldvars,allvars);
        t.Properties.VariableNames(pos) = newvars;
    else
        t.Properties.VariableNames(oldvars) = newvars;
    end
end
end