function t = transpose(t)

varClasses = classVarNames(t);
if ~ismatrixlike(t) || ~isequal(varClasses{:})
    error('Only transpose() is defined on a matrix-like table with variables of the same class.')
end

% Create rownames
rowNames = t.Properties.RowNames;
if isempty(rowNames)
    rowNames = matlab.internal.table.dfltRowNames(1:size(t,1));
else
    iempty = cellfun('isempty',rowNames);
    indices = 1:size(t,1);
    rowNames(iempty) = matlab.internal.table.dfltRowNames(indices(iempty));
end
try
    data = t{:,:}.';
catch
    data = [t.data{:}].';
end
t = array2table(data,'VariableNames',rowNames, 'RowNames',t.Properties.VariableNames);
end