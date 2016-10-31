function bool = ismatrixlike(t)
% ISMATRIXLIKE True if one value per table cell
%
% NOTE: it tests the condition size(table) == size(table{:,:}) without
% actually extracting and concatenating the data.

bool = true;

varClasses = classVarNames(t);
nvars = numel(varClasses);
if nvars > 1 && ~isequal(varClasses{:})
    bool = false;
    return
end

for ii = 1:nvars
    [r,c] = size(t.data{ii});
    if c > 1
        bool = false;
        return
    end
end
end
