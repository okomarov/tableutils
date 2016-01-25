function out = classVarNames(tb)
% CLASSVARNAMES Return class name of each column of a table
vnames = tb.Properties.VariableNames;
n      = numel(vnames);
c      = cell(1,n);
for ii = 1:n
    try
        c{ii} = class(tb.data{ii});
    catch
        c{ii} = class(tb{1,ii});
    end
end
if nargout == 0
    disp(cell2table(c,'VariableNames',vnames))
else
    out = c;
end
end