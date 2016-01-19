function X = xstr2num(C,fmt)
% XSTR2NUM Converts the digit-part from an 'xNumber' to numeric
%
%   XSTR2NUM(C) C can be an 'xNumber' or a cell array of 'xNumber'.
%               An 'xNumber' is string in the 'x\d*' format, e.g. 'x767532'
%
%   XSTR2NUM(..., FMT) FMT is a numeric conversion specifier as accepted
%                      by textscan(), e.g. '%d32'.
%
%   NOTE: when you unstack a vertical table by a numeric ID, the resulting
%         VariableNames will be 'xNumbers'. This function, converts these
%         VariableNames back to their initial numeric counterpart.
%
% Example:
%
%   % Create unstacked table
%   Id    = [12;1;4355]
%   Date  = [20081103; 20081103; 20081104];
%   Value = (1:3)';
%
%   t = table(Id, Date, Value)
%
%          Id       Date      Value
%         ____    ________    _____
%           12    20081103    1
%            1    20081103    2
%         4355    20081104    3
%
%   t = unstack(t,'Id','Value')
%
%          Date      x1     x12    x4355
%        ________    ___    ___    _____
%        20081103      2      1    NaN
%        20081104    NaN    NaN      3
%
%   % Convert xNumber variable names to initial numeric ids
%   id = xstr2num(t.Properties.VariableNames(2:end));
%
% See also: unstack, textscan

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 21 Apr 2015 - Created

if isrowchar(C)
    C = {C};
end

if nargin < 2, fmt = '%f'; end

X     = char(C(:));
[m,n] = size(X);
X     = [X'; repmat(' ',1,m)];

% Check that it's a x\d* format
isFirstLetter    = all(in(X(1,:),['A','Z']) | in(X(1,:),['a','z']));
isSecondNum      = all(in(X(2,:),['0','9']));
isRestNumOrSpace = all(all(in(X(3:end,:),['0','9']) | X(3:end,:) == ' '));
if ~isFirstLetter || ~isSecondNum || ~isRestNumOrSpace
    error('xstr2num:invalidXstring','One of the string is an invalid ''xNumber''')
end

% Retain only type and add length of the match
fmt = regexp(fmt, '[dufn][1368]?[246]?','match','once');
fmt = sprintf('%%%d%s',n+1,fmt);
% Convert
X   = textscan(X(2:end,:),fmt);
X   = X{1};
end