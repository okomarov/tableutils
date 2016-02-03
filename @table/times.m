function c = times(a,b)

if a.nrows == b.nrows && a.nvars == b.nvars
    vnames_a = a.Properties.VariableNames;
    vnames_b = b.Properties.VariableNames;
    
    % Cannot have duplicate names, sufficient to check one way
    [ivnames, cpos] = ismember(vnames_a,vnames_b);
    if all(ivnames)
        rnames_a = a.Properties.RowNames;
        rnames_b = b.Properties.RowNames;
    
        % Cannot have duplicate names, sufficient to check one way
        hasRowNames = xor(~isempty(rnames_a),~isempty(rnames_b));
        if hasRowNames
            [irnames, rpos] = ismember(rnames_a,rnames_b);
            if ~all(irnames)
                error('Table dimensions must agree and have the same variable/row names.')
            end
        end
    end
end

% Performance-wise I might skip this check and do a try catch on the .*,
% the only problem different column-wise implicit numeric conversions
if ~ismatrixlike(a) || ~ismatrixlike(b)
    error('Input tables must be matrix-like.')
end

c = cell(1,a.nvars);
for ii = 1:numel(cpos)
    if hasRowNames
        c{ii} = a.data{ii}.*b.data{cpos(ii)}(rpos);
    else
        c{ii} = a.data{ii}.*b.data{cpos(ii)};
    end
end
c = table(c{:},'VariableNames',vnames_a,'RowNames',rnames_a);
end