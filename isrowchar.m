function bool = isrowchar(A)
% ISROWCHAR Determine whether input is a string (1 by N char)
% 
%   BOOL = ISROWCHAR(A) Where A is any input and BOOL is logical.
%
% Example:
%
%   isstring('Hi, how are you?')
%
% See also: STRINGS, ISCHAR, ISCELLSTR

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014a Win7 64bit
% 26 Jun 2014 - Created
% 07 Dec 2015 - rename to avoid conflicts with inbuilts in R2015b

bool = ischar(A) && (isrow(A) || isempty(A));
end