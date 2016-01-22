function out = classVarNames(tb)
% CLASSVARNAMES Return class name of each column of a table

vnames = getProperty(tb,'VariableNames');
n      = numel(vnames);
c      = cell(1,n);
for ii = 1:n
    c{ii} = class(tb.data{ii});
end
if nargout == 0
    disp(cell2table(c,'VariableNames',vnames))
else
    out = c;
end
end