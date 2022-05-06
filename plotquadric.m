rng('shuffle');

n_trials = 10;
quadric_eval_lim = 100;

for i = 1:n_trials

    Q = RandOrthMat(2);
    Lambda = diag(-quadric_eval_lim + quadric_eval_lim * rand(2,1));
    A = Q * Lambda * Q'; 
    
    b = 10*rand(1,2);
    R = rand(1);

    % sample points
    [X,Y] = meshgrid(-10:0.5:10,-10:0.5:10);
    mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
    Z = cellfun(@(x) [x(1),x(2)]*(A*[x(1),x(2)]') + b*[x(1),x(2)]' + R, num2cell(mesh_pts,2));

    syms x1 x2
    J = jacobian([x1,x2]*(A*[x1,x2]') + b*[x1,x2]' + R, [x1,x2]);
    S = solve(J,[x1,x2],"Real",true);
    Xopt = double([S.x1, S.x2]);
    [hess, err] = hessian(@(x) [x(1),x(2)]*(A*[x(1),x(2)]') + b*[x(1),x(2)]' + R, Xopt);

    % plot
    fig = figure(i);
    surf(X, Y, reshape(Z, size(X)),reshape(Z, size(X)))
    %hold on
    %scatter3(reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1]), Z, 10, "red", "filled")
    shading interp
    camlight
    grid off
    hold off

    set(gca, 'XColor', 'none', 'YColor', 'none', 'ZColor', 'none')
    print(fig, strcat('quadric_', string(i)), '-r800', '-dpng');

end