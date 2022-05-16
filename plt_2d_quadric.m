close all; clear all;
addpath(genpath(pwd));
rng('shuffle');

quad_coeffs = [0.75, 1];
quad_scales = [10, 16, 32];
is_saddle = [true, false];
Xopt = [0, 0];
Zopt = 0;

rng(19522);
cnt = 1;

for cs = 1:numel(is_saddle)

    for sc = 1:numel(quad_scales)

        a = quad_coeffs(1);
        b = quad_coeffs(2);
        if is_saddle(cs) == true
            b = -b;
        end
    
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

        % Sampled points and optimum 
        sample_X = [Xopt(1); sample_pts(:,1)];
        sample_Y = [Xopt(2); sample_pts(:,2)];
        sample_Z = [Zopt; Z_pts];

        % Numerical curvature
        [Xs, Ys] = meshgrid(sample_X, sample_Y);
        f = @(x,y) a.*(x.^2) + b.*(y.^2);
        Zs = f(Xs,Ys);
        [fx,fy] = gradient(Zs);
        [fxx,fxy] = gradient(fx);
        [~,fyy] = gradient(fy);
        K = (fxx.*fyy - fxy.^2)./((1 + fx.^2 + fy.^2).^2);
        H = ((1+fx.^2).*fyy + (1+fy.^2).*fxx - 2.*fx.*fy.*fxy)./...
            ((1 + fx.^2 + fy.^2).^(3/2));

        % diffusion map
        configParams.normalization = 'lb';
        configParams.self_tune = true;
        configParams.plotResults = false;
        configParams.t = 5;
        configParams.kNN = 20;
        configParams.maxInd = 200;
        [DM_K, DM_nnData] = calcAffinityMat([[sample_X sample_Y] sample_Z]', configParams);
        [diff_map, DM_Lambda, DM_Psi, DM_Ms, DM_Phi, DM_K_rw] = calcDiffusionMap(DM_K, configParams);
        diffusion_coords = diff_map';

        % pairwise distances
        DM_pdist = squareform(pdist(diffusion_coords));
        Euclidean_pdist = squareform(pdist([sample_X sample_Y sample_Z]));

        % anisotropic kernel
        sigma = 0.05;
        W1 = exp(-Euclidean_pdist.^2/(2*(sigma^2)));
        D = diag(1./sum(W1,2));
        W = D * W1 * D;

        % TODO: use adaptive anisotropic kernel

        % diffusion operator
        D = diag(1./sum(W,2));
        P = D * W;
        powered_diff_op = P^(configParams.t);

        % diffusion curvature
        metric_thresh = 0.05;
        n_samples = size(P, 1);
        diff_curvature = zeros(n_samples, 1);
        for j = 1:n_samples
            idx = find(DM_pdist(j,:) < metric_thresh);
            ball_numel = numel(idx);
            sum_diff_probs = sum(P(j,idx));
            diff_curvature(j) = sum_diff_probs/ball_numel;
        end

        % Visualize

        %{
        fig = figure('units','inch','position',[0,0,15,2.5]);

        subplot(1,3,1);
        hold on
        scatter3(sample_pts(:,1), sample_pts(:,2), Z_pts, 5, Z_pts, "red", "filled")
        scatter3(Xopt(1), Xopt(2), Zopt, 15, "white", "filled", "o", "MarkerEdgeColor", "k")
        surf(X, Y, reshape(Z, size(X)), reshape(Z, size(X)));
        shading interp
        xlim([-2.5, 2.5])
        ylim([-2.5, 2.5])
        if b < 0
            zlim([-2, 2])
        else
            zlim([0, 2])
        end
        axis off
        grid off
        colormap(flipud(parula))
        view(3)

        subplot(1,3,2);
        scatter3(sample_X, sample_Y, sample_Z, 3, sample_Z, "filled")
        if b < 0
            zlim([-1, 1])
        else
            zlim([0, 1])
        end
        colormap(flipud(parula))
        colorbar

        subplot(1,3,3);
        contourf(X, Y, reshape(Z, size(X)));
        hold on;
        scatter(sample_pts(:,1), sample_pts(:,2), 1, "red", "filled", "MarkerFaceAlpha", 0.6)
        scatter(Xopt(1), Xopt(2), 3, "white", "filled", "diamond")
        colormap(flipud(parula))
        colorbar

        print(fig, strcat('quadric_', string(cnt)), '-r800', '-dpng');
        %}

        fig = figure('units','inch','position',[0,0,15,2.5]);

        ax(1) = subplot(1,3,1);
        scatter3(sample_X, sample_Y, sample_Z, 3, diff_curvature, "filled")
        if b < 0
            zlim([-1, 1])
        else
            zlim([0, 1])
        end
        colormap(ax(1),jet)
        colorbar

        ax(2) = subplot(1,3,2);
        scatter3(sample_X, sample_Y, sample_Z, 3, diag(K), "filled")
        if b < 0
            zlim([-1, 1])
        else
            zlim([0, 1])
        end
        colormap(ax(2),jet)
        colorbar

        ax(3) = subplot(1,3,3);
        scatter3(sample_X, sample_Y, sample_Z, 3, diag(H), "filled")
        if b < 0
            zlim([-1, 1])
        else
            zlim([0, 1])
        end
        colormap(ax(3),jet)
        colorbar

        print(fig, strcat('quad_curvature_', string(cnt)), '-r800', '-dpng');

        cnt = cnt + 1;
    
    end

end