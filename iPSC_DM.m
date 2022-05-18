close all; clear all;
addpath(genpath(pwd));

rng(19522);

load("ipscData.mat")

% params for diffusion
configParams.t = 250;
configParams.sigma = 0.5;
configParams.kNN = 5;
configParams.num_pts = size(data, 1);
configParams.maxInd = 3;

k = randperm(configParams.num_pts);
X = data(k(1:200000),:);

[K, nnData] = calcAffinityMat(X', configParams);
[diffusion_map, Lambda, Psi, Ms, Phi, K_rw] = calcDiffusionMap(K, configParams);

xs = Lambda(1).*diffusion_map(1,:);
ys = Lambda(2).*diffusion_map(2,:);

save("iPSC_embedding.mat", "xs", "ys")

fig = figure();
scatter(xs, ys, 3, "filled")
print(fig, 'iPSC_DM_embedding', '-r800', '-dpng');