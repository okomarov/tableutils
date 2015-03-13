function t = convertColumn(t, newclass, vars)


% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 13 Mar 2015 - Created

if ~isstring(newclass)
    error('convertColumn:invalidString','NEWCLASS should be a string.')
end

if nargin < 3 || isempty(vars)
    % Convert all
    vars = ':';
end

% Delegate error checking
tmp  = t(1,vars);
vars = tmp.Properties.VariableNames;

% Convert
for ii = 1:numel(vars)
    v = vars{ii};
    try
        t.(v) = cast(t.(v), newclass);
    catch ME
        message = strrep(ME.message,'Conversion',sprintf('Conversion of ''%s''',v));
        error('convertColumn:invalidCoversion', message);
    end
end
end