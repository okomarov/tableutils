function X = xstr2num(C,fmt)
X     = char(C(:));
[m,n] = size(X);
X     = [X'; repmat(' ',1,m)];

% Check that it's a x[\d]* format
isFirstLetter    = all(in(X(1,:),['A','Z']) | in(X(1,:),['a','z']));
isSecondNum      = all(in(X(2,:),['0','9']));
isRestNumOrSpace = all(all(in(X(3:end,:),['0','9']) | X(3:end,:) == ' '));
if ~isFirstLetter || ~isSecondNum || ~isRestNumOrSpace
    error('xstr2num:invalidXstring','One of the string is an invalid xNumber')
end

% Retain only type and add length of the match
fmt = regexp(fmt, '[dufn][1368]?[246]?','match','once');
fmt = sprintf('%%%d%s',n+1,fmt);
% Convert
X   = textscan(X(2:end,:),fmt);
X   = X{1};
end