addpath(genpath(pwd));

%% camel 6

close all; clear all;

[X,Y] = meshgrid(-3:0.1:3, -2:0.1:2);
mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
Z = cellfun(@camel6, num2cell(mesh_pts,2));

Xopt = [0.0898, -0.7126];
fopt = -1.0316;

sample_pts = Xopt + randsphere(500, 2, 0.25);
Z_pts = cellfun(@camel6, num2cell(sample_pts,2));

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts)
colorbar
title('Six-hump Camel Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 5, "red", "filled", "MarkerFaceAlpha", 0.8)
scatter(Xopt(1), Xopt(2), 8, "white", "filled")

print(fig, 'camel6', '-r800', '-dpng');

%%