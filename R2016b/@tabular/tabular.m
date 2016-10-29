classdef (AllowedSubclasses = {?timetable ?table}) tabular < matlab.mixin.internal.indexing.DotParen
    % Internal abstract superclass for table and timetable.
    % This class is for internal use only and will change in a future release. Do not use this class.
    %
    %   Copyright 2016 The MathWorks, Inc.
    
    properties(Constant, Access='protected') % *** may go back to private if every instance is in tabular
        arrayPropsDflts = struct('Description', {''}, ...
            'UserData'   , []);
    end
    
    properties(Abstract, Constant, Access='protected')
        % Constant properties are not persisted when serialized
        propertyNames
        defaultDimNames
    end
    
    properties(Abstract, Access='protected')
        metaDim
        rowDim
        varDim
        data
        arrayProps
    end
    
    properties(Dependent, SetAccess='protected')
        %PROPERTIES Table or timetable metadata properties.
        %   T.Properties, where T is a table or a timetable, is a scalar struct containing the
        %   following metadata:
        %
        %       Description           - A character vector describing the table
        %       UserData              - A variable containing any additional information associated
        %                               with the table.  You can assign any value to this property.
        %       DimensionNames        - A two-element cell array of character vectors containing names
        %                               of the dimensions of the table
        %       VariableNames         - A cell array containing names of the variables in the table
        %       VariableDescriptions  - A cell array of character vectors containing descriptions of
        %                               the variables in the table
        %       VariableUnits         - A cell array of character vectors containing units for the
        %                               variables in table
        %       RowNames (tables)     - A cell array of nonempty, distinct character vectors containing
        %                               names of the rows in the table
        %       RowTimes (timetables) - A datetime or durations vector containing times associated
        %                               with each row in the timetable
        %
        %   See also TABLE, TIMETABLE.
        Properties
    end
    methods % dependent property get methods
        function val = get.Properties(a)
        val = getProperties(a);
        end
    end
    
    methods(Hidden)
        function props = getProperties(t)
        % This function is for internal use only and will change in a future release.
        % Do not use this function. Use t.Properties instead.
        import matlab.internal.datatypes.mergeScalarStructs
        props = mergeScalarStructs(t.arrayProps, ...
            t.metaDim.getProperties(), ...
            t.varDim.getProperties(), ...
            t.rowDim.getProperties());
        props = orderfields(props,t.propertyNames);
        end
        
        % Allows tab completion after dot to suggest variables
        function p = properties(t)
        % This will be called for properties of an instance, but the built-in will
        % be still be called for the class name.  It will return just Properties,
        % which is correct.
        pp = [t.varDim.labels(:); 'Properties'; t.metaDim.labels(:)];
        if nargout == 0
            fprintf('%s\n',getString(message('MATLAB:ClassUstring:PROPERTIES_FUNCTION_LABEL',class(t))));
            fprintf('    %s\n',pp{:});
        else
            p = pp;
        end
        end
        function f = fieldnames(t), f = properties(t); end
    function f = fields(t),     f = properties(t); end

function f = ctranspose(t), f = transpose(t); end

function vars = getVars(t,asStruct)
% This function is for internal use only and will change in a future release.
% Do not use this function. Use table2struct(t,'AsScalar',true) instead.
if nargin < 2 || asStruct
    vars = cell2struct(t.data,t.varDim.labels,2);
else
    vars = t.data;
end
end

% Methods we don't want to clutter things up with
e = end(t,k,n)
B = repelem(A,M,N,varargin)
disp(t,bold,indent,fullChar)
[varargout] = subsref(t,s)
t = subsasgn(t,s,b)

b = dotParenReference(t,vn,s1,s2,varargin)
sz = numArgumentsFromSubscript(t,s,context)

%% Variable Editor methods
% These functions are for internal use only and will change in a
% future release.  Do not use these functions.
varargout  = variableEditorGridSize(t)
[names,indices,classes,iscellstr,charArrayWidths] = variableEditorColumnNames(t)
rowNames   = variableEditorRowNames(t)
[code,msg] = variableEditorRowDeleteCode(t,workspaceVariableName,rowIntervals)
[code,msg] = variableEditorColumnDeleteCode(t,workspaceVariableName,columnIntervals)
t          = variableEditorPaste(t,rows,columns,data)
t          = variableEditorInsert(t,orientation,row,col,data)
[code,msg] = variableEditorSetDataCode(t,workspaceVariableName,row,col,rhs)
[code,msg] = variableEditorUngroupCode(t,varName,col)
[code,msg] = variableEditorGroupCode(t,varName,startCol,endCol)
metaData   = variableEditorMetadata(t)
[code,msg] = variableEditorMetadataCode(t,varName,index,propertyName,propertyString)
[code,msg] = variableEditorRowNameCode(t,varName,index,rowName)
[code,msg] = variableEditorSortCode(t,varName,tableVariableNames,direction)
[code,msg] = variableEditorMoveColumn(t,varName,startCol,endCol)

%% Error stubs
% Methods to override functions and throw helpful errors
function d = double(d), throwInvalidNumericConversion(d); end
function d = single(d), throwInvalidNumericConversion(d); end
function t = length(varargin),     throwUndefinedLengthError(varargin{1}); end %#ok<STOUT>
function t = sort(varargin),       throwUndefinedSortError(varargin{1}); end %#ok<STOUT>
function t = permute(varargin),    throwUndefinedError(varargin{1}); end %#ok<STOUT>
function t = reshape(varargin),    throwUndefinedError(varargin{1}); end %#ok<STOUT>

function t = plot(t), error(message('MATLAB:table:NoPlotMethod',class(t),class(t))); end
    end % hidden methods block
    
    methods(Abstract, Hidden, Static)
        t = fromScalarStruct(s)
        t = empty(varargin)
    end % abstract hidden static methods block
    
    methods(Access = 'protected')
        % Helper methods used in join/innerjoin/outerjoin
        [a,b,supplied,keys,leftKeys,rightKeys,leftVars,rightVars,mergeKeys] ...
            = prejoin(a,b,keys,supplied,type,leftKeys,rightKeys,leftVars,rightVars,mergeKeys)
        c = postjoin(c,a,b,type,leftVarDim)
        
        [varargout] = subsrefParens(t,s)
        [varargout] = subsrefBraces(t,s)
        [varargout] = subsrefDot(t,s)
        t = subsasgnParens(t,s,b,creating,deleting)
        t = subsasgnBraces(t,s,b)
        t = subsasgnDot(t,s,b,deleting)
        
        b = extractData(t,vars,like,a)
        t = replaceData(t,x,vars)
        
        writeTextFile(t,file,args)
        writeXLSFile(t,xlsfile,ext,args)
        
        [group,glabels,glocs] = table2gidx(a,avars,reduce)
        varIndex = subs2indsErrorHandler(varName,ME,stubMsgID,varargin)
        
        function t = setProperties(t,s)
        %SET Set some or all table properties from a scalar struct.
        if ~isstruct(s) || ~isscalar(s)
            error(message('MATLAB:table:InvalidPropertiesAssignment'));
        end
        fnames = fieldnames(s);
        for i = 1:length(fnames)
            fn = fnames{i};
            t = setProperty(t,fn,s.(fn));
        end
        end
        
        function errID = throwSubclassSpecificError(~,msgid,varargin)
        % THROWSUBCLASSSPECIFICERROR is called by overloads in the subclasses and returns an
        % MException that is specific to the subclass which can then be returned to the
        % caller or thrown.
        try
            msg = message(['MATLAB:' msgid],varargin{:});
        catch ME
            if strcmp(ME.identifier,'MATLAB:builtins:MessageNotFound')
                % This function should never be called with a non-existant ID
                assert(false);
            else
                rethrow(ME);
            end
        end
        errID = MException(msg.Identifier,msg.getString());
        end
    end % protected methods block
    
    methods(Abstract, Access = 'protected')
        b = cloneAsEmpty(a)
    end % abstract protected methods block
    
    methods(Static, Access = 'protected')
        [ainds,binds] = table2midx(a,avars,b,bvars)
        [leftVars,rightVars,leftVarNames,rightVarNames,leftKeyVals,rightKeyVals,leftKeys,rightKeys,mergedKeys] ...
            = joinUtil(a,b,type,leftTableName,rightTableName,keys, ...
            leftKeys,rightKeys,mergeKeys,leftVars,rightVars,ignoreDups,supplied)
        [c,il,ir] = joinInnerOuter(a,b,leftOuter,rightOuter,leftKeyvals,rightKeyvals, ...
            leftVars,rightVars,leftVarnames,rightVarnames)
        
        function [numVars, numRows] = countVarInputs(args)
        %COUNTVARINPUTS Count the number of data vars from a tabular input arg list
        import matlab.internal.datatypes.isCharString
        argCnt = 0;
        numVars = 0;
        numRows = 0;
        while argCnt < length(args)
            argCnt = argCnt + 1;
            arg = args{argCnt};
            if isCharString(arg) % matches any character vector, not just a parameter name
                % Put that one back and start processing param name/value pairs
                argCnt = argCnt - 1; %#ok<NASGU>
                break
            elseif isa(arg,'function_handle')
                error(message('MATLAB:table:FunAsVariable'));
            else % an array that will become a variable in t
                numVars = numVars + 1;
            end
            numRows_j = size(arg,1);
            if argCnt == 1
                numRows = numRows_j;
            elseif ~isequal(numRows_j,numRows)
                error(message('MATLAB:table:UnequalVarLengths'));
            end
        end % while argCnt < numArgs, processing individual vars
        end
    end % static protected methods block
end % classdef

%-----------------------------------------------------------------------------
function throwUndefinedLengthError(obj,varargin)
st = dbstack;
name = regexp(st(2).name,'\.','split');
m = message('MATLAB:table:UndefinedLengthFunction',name{2},class(obj));
throwAsCaller(MException(m.Identifier,'%s',getString(m)));
end % function

%-----------------------------------------------------------------------------
function throwUndefinedSortError(obj,varargin)
st = dbstack;
name = regexp(st(2).name,'\.','split');
m = message('MATLAB:table:UndefinedSortFunction',name{2},class(obj));
throwAsCaller(MException(m.Identifier,'%s',getString(m)));
end % function

%-----------------------------------------------------------------------------
function throwUndefinedError(obj,varargin)
st = dbstack;
name = regexp(st(2).name,'\.','split');
m = message('MATLAB:table:UndefinedFunction',name{2},class(obj));
throwAsCaller(MException(m.Identifier,'%s',getString(m)));
end % function

%-----------------------------------------------------------------------------
function throwInvalidNumericConversion(obj,varargin)
st = dbstack;
name = regexp(st(2).name,'\.','split');
m = message('MATLAB:table:InvalidNumericConversion',name{2},class(obj));
throwAsCaller(MException(m.Identifier,'%s',getString(m)));
end % function

