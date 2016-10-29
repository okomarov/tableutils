function disp(t,bold,INDENT,isFullChar)
%DISP Display a table.
%   DISP(T) prints the table T, including variable names and row names (if
%   present), without printing the table name.  In all other ways it's the
%   same as leaving the semicolon off an expression.
%
%   For numeric or categorical variables that are 2-dimensional and have 3 or
%   fewer columns, DISP prints the actual data using either short g, long g,
%   or bank format, depending on the current command line setting.  Otherwise,
%   DISP prints the size and type of each table element.
%
%   For character variables that are 2-dimensional and 10 or fewer characters
%   wide, DISP prints quoted strings.  Otherwise, DISP prints the size and
%   type of each table element.
%
%   For cell variables that are 2-dimensional and have 3 or fewer columns,
%   DISP prints the contents of each cell (or its size and type if too large).
%   Otherwise, DISP prints the size of each tabble element.
%
%   For other types of variables, DISP prints the size and type of each
%   table element.
%
%   See also TABLE, DISPLAY, FORMAT.

%   Copyright 2012-2013 The MathWorks, Inc.

if nargin < 2, bold = true; end
if nargin < 3, INDENT = 4;end
if nargin < 4, isFullChar = false; end
BETWEEN    = 4;
WITHIN     = 2;
CHUNK_SIZE = 100;

% Follow the cmd window's format settings as possible
isLoose = strcmp(get(0,'FormatSpacing'),'loose');
if isLoose
    LOOSELINE = '\n';
else
    LOOSELINE = '';
end
[FMT_DOUBLE,FMT_SINGLE] = getFloatFormats();

strongBegin = '';
strongEnd   = '';
if matlab.internal.display.isHot() && bold
    strongBegin = getString(message('MATLAB:table:localizedStrings:StrongBegin'));
    strongEnd   = getString(message('MATLAB:table:localizedStrings:StrongEnd'));
end
VARNAME_FMT = [strongBegin '%s' strongEnd];

if (t.rowDim.length > 0) && (t.varDim.length > 0)
    indentSpaces   = repmat(' ', t.rowDim.length, INDENT);   % indent at left margin
    SPACES_BETWEEN = repmat(' ', t.rowDim.length, BETWEEN); % space betweeen variables
    SPACES_WITHIN  = repmat(' ', t.rowDim.length, WITHIN);   % space between columns within a variable
    if ~t.rowDim.hasLabels
        tblChars = indentSpaces;
    else
        rownameChars  = char(t.rowDim.labels);
        WIDTH_ROWNAME = size(rownameChars,2);
        if t.metaDim.dispRowHeader
            name = t.metaDim.labels{1};
            if size(rownameChars,2) < length(name)
                rownameChars(:,end+1:length(name)) = ' ';
                WIDTH_ROWNAME = size(rownameChars,2);
            end
        end
        % Preserve all the spaces using horzcat, not strcat.
        strongBeginRep = repmat(strongBegin,t.rowDim.length,1);
        strongEndRep = repmat(strongEnd,t.rowDim.length,1);
        tblChars = [indentSpaces strongBeginRep rownameChars strongEndRep betweenSpaces];
    end

    rowpos = unique([1:CHUNK_SIZE:t.rowDim.length, t.rowDim.length+1]);
    for r = 1:numel(rowpos)-1
        pos = rowpos(r):rowpos(r+1)-1;
        [tblCharChunk, VARNAME_PAD] = getTableChar(t,tblChars,pos);
        if r == 1
            % Padding inferred on first 100 observations
            dispVarNames();
        end
        disp(tblCharChunk);
    end

else
    str = getString(message('MATLAB:table:uistrings:EmptyTableDisplay',t.rowDim.length,t.varDim.length,class(t)));
    fprintf('   %s\n',str);
end
fprintf(LOOSELINE);


%-----------------------------------------------------------------------
    function [tblCharsChunk, VARNAME_PAD] = getTableChar(t,tblChars,pos)
    tblCharsChunk = tblChars(pos,:);
    VARNAME_PAD = zeros(1,t.varDim.length);
    for ivar = 1:t.varDim.length
        name = t.varDim.labels{ivar};
        var  = t.data{ivar}(pos,:);
        sz   = size(var);

        if ischar(var)
            if ismatrix(var) && (isFullChar || (size(var,2) <= 10))
                % Display individual strings for a char variable that is 2D and no
                % more than 10 chars.
                varChars = var;
            else
                % Otherwise, display a description of the chars.
                szStr = ['[1' sprintf('x%d',sz(2:end)) ' char]'];
                varChars = repmat(szStr,sz(1),1);
            end

        else
            % Display the individual data if the var is 2D and no more than 3 columns.
            if ~isempty(var) && ismatrix(var) && (size(var,2) <= 3)
                if isnumeric(var) && isempty(enumeration(var))
                    if isa(var,'double')
                        varChars = num2str(var,FMT_DOUBLE);
                    elseif isa(var,'single')
                        varChars = num2str(var,FMT_SINGLE);
                    else % integer types
                        varChars = num2str(var);
                    end
                elseif islogical(var)
                    % Display the logical values using meaningful names.
                    strs = ['false'; 'true '];
                    w1 = size(strs,2); w2 = WITHIN;
                    varChars = repmat(' ',size(var,1),(size(var,2)-1)*(w1+w2));
                    for j = 1:size(var,2)
                        varChars(:,(j-1)*(w1+w2)+(1:w1)) = strs(var(:,j)+1,:);
                    end
                elseif isa(var,'categorical') || isa(var,'datetime') || isa(var,'duration') || isa(var,'calendarDuration')
                    % Build the output one column at a time, since the char method reshapes
                    % to a single column.
                    varChars = char(zeros(t.rowDim.length,0));
                    for j = 1:size(var,2)
                        if j > 1, varChars = [varChars SPACES_WITHIN]; end %#ok<AGROW>
                        varChars = [varChars char(var(:,j))]; %#ok<AGROW>
                    end
                elseif isstring(var) && isscalar(var)
                    % Scalar strings need special handling because the
                    % scalar strings are displayed as uncontained by
                    % the disp method. This means that any type of
                    % formatting within the string (ex. new line) will
                    % be carried over to display, which we do not want.
                    % To get around this, wrap scalar strings within a
                    % cell, and replace the single quotes with double quotes.

                    % Also need a special case: missing scalar
                    % strings. Wrapping a missing scalar string into a
                    % cellstr changes how it is displayed which is not
                    % what we want for table display. We do not need
                    % to worry about contained vs uncontained for the
                    % missing case, simply use disp for scalar empty
                    % string.
                    if ismissing(var)
                        varStr = strtrim(evalc('disp(var)'));
                    else
                        varCell = cellstr(var); %#ok<NASGU> used in evalc
                        varStr = strtrim(evalc('disp(varCell)'));

                        % Remove braces displayed by cell display for
                        % scalar empty case. For strings, 1x0 is not an issue
                        if isscalar(var) && (var == '')
                            varStr = removeBraces(varStr);
                        end

                        varStr(1) = '"';
                        varStr(end) = '"';
                    end

                    varChars = char(varStr);
                elseif iscell(var) || isstring(var)
                    % Let the built-in cell display method show the contents
                    % of each cell however it sees fit.  For example, it will
                    % display only a size/type if the contents are large.  It
                    % puts quotes around char contents, which char wouldn't.
                    varStr = evalc('disp(var)');

                    % Work around a special case that the command line needs
                    % but we don't: curly braces around a scalar cell
                    % containing a 0x0
                    if isscalar(var) && max(size(var{1}))==0
                        varStr = removeBraces(varStr);
                    end

                    % varStr is a single row with \n delimiting the chars for
                    % each row of var.  But \n can also be from displaying the
                    % contents of a cell.  There will be an extra trailing \n
                    % if isLoose; that can be left on.
                    loc = [0 find(varStr==10)];
                    [n,m] = size(var); % already checked is 2D
                    if length(loc) == n+1+isLoose % can use them as row delimiters
                        % The cell disp method puts leading whitespace
                        whiteSpace = find(varStr ~= ' ',1,'first') - 1;
                        % Split the \n-delimited string into a char matrix.
                        len = diff(loc) - whiteSpace;
                        varChars = repmat(' ',size(var,1),max(len)-1);
                        for i = 1:n
                            celChars = strtrim(varStr(loc(i)+1:loc(i+1)-1));
                            if ~isempty(celChars) % avoid 0x0 coming from strtrim
                                varChars(i,1:length(celChars)) = celChars;
                            end
                        end
                    else % the display for some cells had a \n in them
                        % Use the built-in to display each cell individually.
                        % This gives a slightly different output than the
                        % above, because cells are not all justified to the
                        % same length.
                        varChars = char(zeros(t.rowDim.length,0));
                        offset = 0;
                        for j = 1:m
                            if j > 1
                                varChars = [varChars SPACES_WITHIN]; %#ok<AGROW>
                                offset = size(varChars,2);
                            end
                            for i = 1:n
                                % Display contents of each cell, remove {} around 0x0
                                var_ij = var(i,j);
                                celChars = evalc('disp(var_ij)');
                                if max(size(var_ij{1})) == 0
                                    celChars = removeBraces(celChars);
                                end
                                celChars = strtrim(celChars(1:end-1));
                                if ~isempty(celChars) % avoid 0x0 coming from strtrim
                                    varChars(i,offset+(1:length(celChars))) = celChars;
                                end
                            end
                        end
                    end
                elseif ~isempty(enumeration(var)) % isenumeration(var)
                    varChars = evalc('builtin(''disp'',var)'); %call disp to get the enum display
                    if isLoose % remove trailing \n
                        varChars(end) = [];
                    end
                    numLines = size(var,1);
                    varChars = reshape(varChars,numel(varChars)/numLines,numLines)';
                    %Remove the name padding and trailing \n from enum DISP
                    varChars(:,[1:4 end]) = [];
                else
                    % Display a description of each table element.
                    varChars = getInfoDisplay(var);
                end

                % Either the variable is not 2D, or it's empty, or it's too wide
                % to show. Display a description of each table element.
            else
                varChars = getInfoDisplay(var);
            end
        end
        if size(varChars,2) < length(name)
            varChars(:,end+1:length(name)) = ' ';
        end
        VARNAME_PAD(ivar) = size(varChars,2)-length(name);

        if ivar == 1 % starting over at left margin
            tblCharsChunk = [tblCharsChunk varChars]; %#ok<AGROW>
        else
            SPACES_BETWEEN = repmat(' ', sz(1), BETWEEN);
            tblCharsChunk  = [tblCharsChunk SPACES_BETWEEN varChars]; %#ok<AGROW>
        end
    end
    end


%-----------------------------------------------------------------------
    function dispVarNames()
    if t.metaDim.dispRowHeader
        leadingSpaces = repmat(' ',1,INDENT);
    elseif t.rowDim.hasLabels
        leadingSpaces = repmat(' ',1,INDENT+WIDTH_ROWNAME+BETWEEN);
    else
        leadingSpaces = repmat(' ',1,INDENT);
    end
    fprintf('%s',leadingSpaces);
    if t.metaDim.dispRowHeader
        name = t.metaDim.labels{1};
        rownamesPad = WIDTH_ROWNAME - length(name);
        leftSpaces = repmat(' ',1,ceil(rownamesPad / 2));
        rightSpaces = repmat(' ',1,rownamesPad-length(leftSpaces)+BETWEEN);
        fprintf(VARNAME_FMT,[leftSpaces name rightSpaces]);
    end
    ii = 1;
    rightSpaces = repmat(' ',1,ceil(VARNAME_PAD(ii) / 2));
    leftSpaces = repmat(' ',1,VARNAME_PAD(ii)-length(rightSpaces));
    fprintf(VARNAME_FMT,[leftSpaces t.varDim.labels{ii} rightSpaces]);
    for ii = 2:t.varDim.length
        rightSpaces = repmat(' ',1,ceil(VARNAME_PAD(ii) / 2));
        leftSpaces = repmat(' ',1,VARNAME_PAD(ii)-length(rightSpaces)+BETWEEN);
        fprintf(VARNAME_FMT,[leftSpaces t.varDim.labels{ii} rightSpaces]);
    end
    fprintf('\n');
    fprintf('%s',leadingSpaces);
    if t.metaDim.dispRowHeader
        ul = repmat('_',1,WIDTH_ROWNAME);
        spaces = repmat(' ',1,BETWEEN);
        fprintf('%s',[sprintf(VARNAME_FMT,ul) spaces]);
    end
    ii = 1;
    ul = repmat('_',1,length(t.varDim.labels{ii})+VARNAME_PAD(ii));
    spaces = repmat(' ',1,BETWEEN);
    fprintf(VARNAME_FMT,ul);
    for ii = 2:t.varDim.length
        ul = repmat('_',1,length(t.varDim.labels{ii})+VARNAME_PAD(ii));
        fprintf('%s',[spaces sprintf(VARNAME_FMT,ul)]);
    end
    fprintf(['\n' LOOSELINE]);
    end

end % main function


%-----------------------------------------------------------------------
function [dblFmt,snglFmt] = getFloatFormats()
% Display for double/single will follow 'format long/short g/e' or 'format bank'
% from the command window. 'format long/short' (no 'g/e') is not supported
% because it often needs to print a leading scale factor.
switch get(0,'Format')
    case {'short' 'shortG' 'shortEng'}
        dblFmt  = '%.5g    ';
        snglFmt = '%.5g    ';
    case {'long' 'longG' 'longEng'}
        dblFmt  = '%.15g    ';
        snglFmt = '%.7g    ';
    case 'shortE'
        dblFmt  = '%.4e    ';
        snglFmt = '%.4e    ';
    case 'longE'
        dblFmt  = '%.14e    ';
        snglFmt = '%.6e    ';
    case 'bank'
        dblFmt  = '%.2f    ';
        snglFmt = '%.2f    ';
    otherwise % rat, hex, + fall back to shortg
        dblFmt  = '%.5g    ';
        snglFmt = '%.5g    ';
end
end


%-----------------------------------------------------------------------
function str = removeBraces(str)
str = regexprep(str,'\{(.*)\}','$1');
end


%-----------------------------------------------------------------------
function varChars = getInfoDisplay(var)
sz = size(var);
if ismatrix(var)
    szStr = ['[1' sprintf('x%d',sz(2:end))];
else
    szStr = ['[1' sprintf('x%d',sz(2)) sprintf('x%d',sz(3:end))];
end
varChars = repmat([szStr ' ' class(var) ']'],sz(1),1);
end
