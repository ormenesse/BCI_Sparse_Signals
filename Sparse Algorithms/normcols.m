function [ B ] = normcols( A )
%NORMCOLS Summary of this function goes here
%   Detailed explanation goes here
B = A./(ones(size(A,1),1)*sqrt(sum(A.^2,1)));
end

