function classVarNames(tb)
% CLASSVARNAMES Return class name of each column of a table

vnames = getProperty(tb,'VariableNames');
n      = numel(vnames);
c      = cell(1,n);
for ii = 1:n
    c{ii} = class(tb.data{ii});
end
disp(cell2table(c,'VariableNames',vnames))
end