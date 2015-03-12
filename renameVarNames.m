function t = renameVarNames(t, newvars, oldvars)

% Wrap in a cell
if isstring(newvars), newvars = {newvars}; end

if nargin < 3 || isempty(oldvars)
    % Rename all
    t.Properties.VariableNames = newvars; 
else
    if numel(oldvars) ~= numel(newvars)
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

function bool = isstring(s)
bool = ischar(s) && isrow(s);
end