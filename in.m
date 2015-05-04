function idx = in(A, bounds, inclusion)
% idx = in(A, bounds, inclusion)

bounds = sort(bounds);
if nargin < 3 || isempty(inclusion)
    inclusion = '[]';
end

switch inclusion
    case '[]'
        idx = bounds(1) <= A & A <= bounds(2);
    case '()'
        idx = bounds(1) <  A & A <  bounds(2);
    case '[)'
        idx = bounds(1) <= A & A <  bounds(2);
    case '(]'
        idx = bounds(1) <  A & A <= bounds(2);
    otherwise
        error
end

end