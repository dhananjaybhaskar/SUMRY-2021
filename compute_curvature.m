%
% Author: Kisung You <kisung.you@yale.edu>
%

clear all; close all; clc;
addpath(genpath(pwd));

%% tunable parameters

par_nbdsize  = 10;
par_estdim   = 2;

%% toy example : sphere in R^3

data = randn(1000,3);
for i=1:1000
    tgt = data(i,:);
    data(i,:) = tgt/sqrt(sum(tgt.^2));
end

%% estimate the curvature

[curvature,hessians] = curvature_knn_simple(data, par_estdim, par_nbdsize);

%% visualize
close all; 
subplot(1,2,1); histogram(curvature); title("distribution of curvatures");
subplot(1,2,2); scatter3(data(:,1), data(:,2), data(:,3), 20, curvature, 'filled'); colormap(jet);
