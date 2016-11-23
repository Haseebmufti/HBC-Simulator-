function y = db2lin(ydb) %#codegen
%DB2MAG  dB to magnitude conversion. presented to this word for the first
%time
%
%   Y = DB2Lin(YDB) computes Y such that YDB = 10*log10(Y).

%   Copyright 1986-2007 The MathWorks, Inc.
%   $Revision $ 
y = 10.^(ydb/10);