function idx = in(A, bounds, inclusion)
% idx = in(A, bounds, inclusion)

bounds = sort(bounds,2);
if nargin < 3 || isempty(inclusion)
    inclusion = '[]';
end

lb = bounds(:,1);
ub = bounds(:,2);
switch inclusion
    case '[]'
        idx = lb <= A & A <= ub;
    case '()'
        idx = lb <  A & A <  ub;
    case '[)'
        idx = lb <= A & A <  ub;
    case '(]'
        idx = lb <  A & A <= ub;
    otherwise
        error
end

end