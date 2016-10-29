function bool = ismatrixlike(t)
% ISMATRIXLIKE True if one value per table cell
%
% NOTE: it tests the condition size(table) == size(table{:,:}) without
% actually extracting and concatenating the data.

bool = true;

varClasses = classVarNames(t);
if ~isequal(varClasses{:})
    bool = false;
    return
end

nvars = numel(varClasses);
for ii = 1:nvars
    [r,c] = size(t.data{ii});
    if c > 1
        bool = false;
        return
    end
end
end
