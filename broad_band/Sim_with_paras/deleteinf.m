function [A,a] = deleteinf(A)
A ( A <0 ) = [];
a = sum(A)/length(A);