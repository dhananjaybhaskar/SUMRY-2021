close all; clear all;
addpath(genpath(pwd));
rng('shuffle');

quad_coeffs = [3, 4];
quad_scales = [2e-1, 3, 12];
is_saddle = [true, false];
Xopt = [0, 0];
Zopt = 0;

cnt = 1;

for cs = 1:numel(is_saddle)

    a = quad_coeffs(1);
    b = quad_coeffs(2);
    if is_saddle(cs) == true
        b = -b;
    end

    for sc = 1:numel(quad_scales)
    
        a = a * quad_scales(sc);
        b = b * quad_scales(sc);

        Q = @(x) a*(x(1)^2) + b*(x(2)^2);

        % Grid sample for visualization
        [X,Y] = meshgrid(Xopt(1)-1.5:0.005:Xopt(1)+1.5, Xopt(2)-1.5:0.005:Xopt(2)+1.5);
        mesh_pts = [reshape(X, [numel(X), 1]), reshape(Y, [numel(Y), 1])];
        Z = cellfun(Q, num2cell(mesh_pts,2));

        % Sample 500 points around optimum
        sample_pts = Xopt + randsphere(500, 2, 0.2);
        Z_pts = cellfun(Q, num2cell(sample_pts,2));

        % Visualize
        fig = figure('units','inch','position',[0,0,15,2.5]);

        subplot(1,3,1);
        hold on
        scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 5, Z_pts, "red", "filled")
        scatter3(Xopt(1), Xopt(2), Zopt, 15, "white", "filled", "o", "MarkerEdgeColor", "k")
        surf(X, Y, reshape(Z, size(X)), reshape(Z, size(X)));
        shading interp
        camlight
        xlim([-2.5, 2.5])
        ylim([-2.5, 2.5])
        if b < 0
            zlim([-5, 5])
        else
            zlim([0, 5])
        end
        axis off
        grid off
        view(3)

        subplot(1,3,2);
        scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 3, Z_pts, "filled")
        colorbar

        subplot(1,3,3);
        contourf(X, Y, reshape(Z, size(X)));
        hold on;
        scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
        scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
        colorbar

        print(fig, strcat('quadric_', string(cnt)), '-r800', '-dpng');

        cnt = cnt + 1;
    
    end

end

