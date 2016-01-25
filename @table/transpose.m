function t = transpose(t)

varClasses = classVarNames(t);
if ~ismatrixlike(t) || ~isequal(varClasses{:})
    error('Only transpose() is defined on a matrix-like table with variables of the same class.')
end

% Create rownames
rowNames = t.Properties.RowNames;
try
    indices = 1:t.nrows;
catch
    indices = 1:numel(t{:,1});
end

if isempty(rowNames)
    rowNames = matlab.internal.table.dfltRowNames(indices);
else
    iempty = cellfun('isempty',rowNames);
    rowNames(iempty) = matlab.internal.table.dfltRowNames(indices(iempty));
end
try
    data = [t.data{:}].';
catch
    data = t{:,:}.';
end
t = array2table(data,'VariableNames',rowNames, 'RowNames',t.Properties.VariableNames);
end