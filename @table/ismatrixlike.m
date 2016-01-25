function bool = ismatrixlike(t)
% ISMATRIXLIKE True if one value per table cell
% 
% NOTE: it tests the condition size(table) == size(table{:,:}) without
% actually extracting and concatenating the data.
bool = true;
sz   = size(t);
for ii = 1:sz(2)
    try
        [r,c] = size(t.data{ii});
    catch
        [r,c] = size(t{1,ii});
    end
    if c > 1
        bool = false;
        return
    end
end
end
