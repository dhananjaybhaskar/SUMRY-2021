close all; clear all;
addpath(genpath(pwd));
rng('shuffle');

n_trials = 6;
quad_lim = 1e3;

fig_cnt = 1;

for i = 1:n_trials

    % Generate random quadric: xAx' + bx' + R 
    %Q = RandOrthMat(2);
    %Lambda = diag(-quad_lim + quad_lim * rand(2,1));
    %A = Q * Lambda * Q'; 
    A = -quad_lim + quad_lim.*rand(2);
    
    b = -quad_lim + quad_lim.*rand(1,2);
    R = rand(1);

    % Find local optimum, evaluate hessian at optimum 
    syms x1 x2
    J = jacobian([x1,x2]*(A*[x1,x2]') + b*[x1,x2]' + R, [x1,x2]);
    S = solve(J, [x1,x2], "Real", true);
    Xopt = double([S.x1, S.x2]);
    Zopt = Xopt*(A*Xopt') + b*Xopt' + R;
    [hess, err] = hessian(@(x) [x(1),x(2)]*(A*[x(1),x(2)]') + b*[x(1),x(2)]' + R, Xopt);

    % Grid sample for visualization
    [X,Y] = meshgrid(Xopt(1)-1:0.01:Xopt(1)+1, Xopt(2)-1:0.01:Xopt(2)+1);
    mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
    Z = cellfun(@(x) [x(1),x(2)]*(A*[x(1),x(2)]') + b*[x(1),x(2)]' + R, num2cell(mesh_pts,2));

    % Sample 1000 points around optimum
    sample_pts = Xopt + randsphere(1000, 2, 0.25);
    Z_pts = cellfun(@(x) [x(1),x(2)]*(A*[x(1),x(2)]') + b*[x(1),x(2)]' + R, num2cell(sample_pts,2));

    % Visualize
    fig = figure(fig_cnt);
    surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
    shading interp
    camlight
    axis off
    grid off
    %hold off
    set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')
    print(fig, strcat('quadric_', string(i)), '-r800', '-dpng');
    fig_cnt = fig_cnt + 1;

    fig = figure(fig_cnt);
    scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 18, Z_pts, "filled")
    hold on
    scatter3(Xopt(1), Xopt(2), Zopt, 20, "red", "filled")
    shading interp
    camlight
    axis off
    grid off
    hold off
    set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')
    print(fig, strcat('quadric_pts_', string(i)), '-r800', '-dpng');
    fig_cnt = fig_cnt + 1;

end