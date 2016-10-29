function t = transpose(t)


if ~ismatrixlike(t)
    error('Only transpose() is defined on a matrix-like table with variables of the same class.')
end

% Create rownames
rowNames = t.Properties.RowNames;
indices = 1:t.rowDim.length;

if isempty(rowNames)
    rowNames = matlab.internal.table.dfltRowNames(indices);
else
    iempty = cellfun('isempty',rowNames);
    rowNames(iempty) = matlab.internal.table.dfltRowNames(indices(iempty));
end

data = [t.data{:}].';

t = array2table(data,'VariableNames',rowNames, 'RowNames',t.Properties.VariableNames);
end
