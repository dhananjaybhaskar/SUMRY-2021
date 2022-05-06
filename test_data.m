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

[hess, err] = hessian(@camel6, Xopt);

save('camel6.mat', 'hess', 'err', 'Xopt', 'fopt', 'sample_pts', 'Z_pts')

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
shading interp
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
colorbar
title('Six-hump Camel Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
colorbar

print(fig, 'camel6', '-r800', '-dpng');

%% michal

close all; clear all;

[X,Y] = meshgrid(0:0.1:pi, 0:0.1:pi);
mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
Z = cellfun(@michal, num2cell(mesh_pts,2));

Xopt = [2.20, 1.57];
fopt = -1.8013;

sample_pts = Xopt + randsphere(500, 2, 0.25);
Z_pts = cellfun(@michal, num2cell(sample_pts,2));

[hess, err] = hessian(@michal, Xopt);

save('michal.mat', 'hess', 'err', 'Xopt', 'fopt', 'sample_pts', 'Z_pts')

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
shading interp
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
colorbar
title('Michalewicz Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
colorbar

print(fig, 'michal', '-r800', '-dpng');

%% rosen

close all; clear all;

[X,Y] = meshgrid(-5:0.1:10, -5:0.1:10);
mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
Z = cellfun(@rosen, num2cell(mesh_pts,2));

Xopt = [1, 1];
fopt = 0;

sample_pts = Xopt + randsphere(500, 2, 0.25);
Z_pts = cellfun(@rosen, num2cell(sample_pts,2));

[hess, err] = hessian(@rosen, Xopt);

save('rosen.mat', 'hess', 'err', 'Xopt', 'fopt', 'sample_pts', 'Z_pts')

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
shading interp
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
colorbar
title('Rosenbrock Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
xlim([-1, 10])
ylim([-1, 10])
colorbar

print(fig, 'rosen', '-r800', '-dpng');

%% stybtang

close all; clear all;

[X,Y] = meshgrid(-5:0.1:5, -5:0.1:5);
mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
Z = cellfun(@stybtang, num2cell(mesh_pts,2));

Xopt = [-2.903534, -2.903534];
fopt = -39.16599*2;

sample_pts = Xopt + randsphere(500, 2, 0.25);
Z_pts = cellfun(@stybtang, num2cell(sample_pts,2));

[hess, err] = hessian(@stybtang, Xopt);

save('stybtang.mat', 'hess', 'err', 'Xopt', 'fopt', 'sample_pts', 'Z_pts')

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
shading interp
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
colorbar
title('Styblinski-Tang Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
colorbar

print(fig, 'stybtang', '-r800', '-dpng');

%% zakharov

close all; clear all;

[X,Y] = meshgrid(-5:0.1:10, -5:0.1:10);
mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
Z = cellfun(@zakharov, num2cell(mesh_pts,2));

Xopt = [0, 0];
fopt = 0;

sample_pts = Xopt + randsphere(500, 2, 0.25);
Z_pts = cellfun(@zakharov, num2cell(sample_pts,2));

[hess, err] = hessian(@zakharov, Xopt);

save('zakharov.mat', 'hess', 'err', 'Xopt', 'fopt', 'sample_pts', 'Z_pts')

fig = figure('units','inch','position',[0,0,15,2.5]);

subplot(1,3,1);
surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
shading interp
colorbar

subplot(1,3,2);
scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
colorbar
title('Zakharov Function')

subplot(1,3,3);
contourf(X, Y, reshape(Z, size(X)));
hold on;
scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
colorbar

print(fig, 'zakharov', '-r800', '-dpng');