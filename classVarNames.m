function classVarNames(tb)
% CLASSVARNAMES Return class name of each column of a table

tmp = table();
vnames = tb.Properties.VariableNames(:)';
for f = vnames
    tmp.(char(f)) = class(tb.(char(f)));
end
disp(tmp)
end