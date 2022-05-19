close all; clear all;
addpath(genpath(pwd));

rng(19522);

load("ipscData.mat")

% params for diffusion
configParams.t = 250;
configParams.sigma = 0.5;
configParams.kNN = 5;
configParams.num_pts = size(data, 1);
configParams.maxInd = 501;

% subset data
num_pts = 50000;                        % max: 200000
k = randperm(configParams.num_pts);
X = data(k(1:num_pts),:);                 

% diffusion map
[K, nnData] = calcAffinityMat(X', configParams);
[diffusion_map, Lambda, Psi, Ms, Phi, K_rw] = calcDiffusionMap(K, configParams);

% low dim embedding
xs = Lambda(1).*diffusion_map(1,:);
ys = Lambda(2).*diffusion_map(2,:);

save("iPSC_embedding_50000.mat", "xs", "ys")

fig = figure();
scatter(xs, ys, 3, "filled")
print(fig, 'iPSC_DM_embedding_50000', '-r800', '-dpng');