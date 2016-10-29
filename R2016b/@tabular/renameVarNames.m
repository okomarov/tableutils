function t = renameVarNames(t, newvars, oldvars)
% RENAMEVARNAMES Renames variable names of a table
%
%   RENAMEVARNAMES(T, NEWVARS) Rename all variable names of a table T to
%                              the names in NEWVARS, in the order they
%                              appear. NEWVARS should be a cell arrays of
%                              strings containing one name for each
%                              variable in T.
%
%   RENAMEVARNAMES(T, NEWVARS, OLDVARS) Rename to NEWVARS the variables
%                                       contained in OLDVARS. OLDVARS can
%                                       a string, a cell array of strings,
%                                       a vector of indices or a logical
%                                       vector.
%
%
%   NEWT = ... Returns a table with the variable names renamed
%
%
% Example:
%
%   t  = table(['M';'F';'M'], [45;32;34], {'NY';'CA';'MA'}, logical([1;0;0]))
%   t1 = renameVarNames(t, {'Gender' 'Age' 'State' 'Vote'})
%   t2 = renameVarNames(t, {'Age' 'State'}, [false,true,true,false])
%   t3 = renameVarNames(t, {'Age' 'State'}, 2:3)
%   t4 = renameVarNames(t, {'Age' 'State'}, {'Var2','Var3'})
%
% See also: TABLE, <a href="matlab:doc tableproperties"> TABLE PROPERTIES</a>

% Author: Oleg Komarov (o.komarov11@imperial.ac.uk)
% Tested on R2014b Win7 64bit
% 13 Mar 2015 - Created
% 19 Jan 2016 - Use private method since we are installing into Matlab folders

% Rename all
if nargin < 3 || isempty(oldvars) || iscolon(oldvars)
    oldvars = t.Properties.VariableNames;
end
indices = t.varDim.subs2inds(oldvars);
t.varDim = t.varDim.setLabels(newvars,indices);
end
