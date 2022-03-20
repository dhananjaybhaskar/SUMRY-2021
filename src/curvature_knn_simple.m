function [S, hessmats] = curvature_knn_simple(data, dim_mfld, nbdsize)

% compute point-wise scalar curvatures on a dataset at the specified length
% scale.

%% initialize
assert(nargin >= 3, "Not enough input arguments.")

dim_amb = size(data, 2); % ambient dimension
N_min = get_min_points_for_regression(dim_mfld, dim_amb);
if (N_min >= nbdsize)
    fprintf("automatically change...\n");
    nbdsize = N_min;
else
    nbdsize = round(nbdsize);
end
point_ids = 1:size(data,1); % ignore 'validate_parameters_L'.

fprintf('Generating curvature expression...\n');
[scalF, Jf] = curvature_expression(dim_mfld, dim_amb-dim_mfld);

fprintf('Computing curvature...\n');

N           = length(point_ids);
S           = NaN(N,1);
dS          = NaN(N,1);
gof         = NaN(N,1);
N_neighbors = NaN(N,1);
hessmats    = cell(N,1);
vars        = cell(N,1);
CovB        = cell(N,1);
which_calib = ones(N,1);

for j=1:N
    neighbor_id    = knnsearch(data, data(j,:), "K", nbdsize); % replace with knnsearch
    N_neighbors(j) = length(neighbor_id);
    %     if (N_neighbors(j) >= CurvParams.fit_redundancy_factor*N_min)
    %         try
    %             [CovB{j}, gof(j), S(j), dS(j), hessmats{j}, vars{j}] = neighborhood_compute(data(neighbor_id,:), dim_mfld, scalF, Jf);
    %             fprintf('Computed point %10d/%d: S=%10.5f dS=%10.5f gof=%10.9f N=%10d\n', ...
    %                 j, N, S(j), dS(j), gof(j), N_neighbors(j));
    %         catch e
    %             fprintf('Computed point %10d/%d: FAILED - %s: %s\n', j, N, e.identifier, e.message);
    %         end
    %     end
    try
        [CovB{j}, gof(j), S(j), dS(j), hessmats{j}, vars{j}] = neighborhood_compute(data(neighbor_id,:), dim_mfld, scalF, Jf);
        fprintf('Computed point %10d/%d: S=%10.5f dS=%10.5f gof=%10.9f N=%10d\n', ...
            j, N, S(j), dS(j), gof(j), N_neighbors(j));
    catch e
        fprintf('Computed point %10d/%d: FAILED - %s: %s\n', j, N, e.identifier, e.message);
    end
end

fprintf('...mean+/SD number of neighbours = (%g,%g)\n', nanmean(N_neighbors), nanstd(N_neighbors));
fprintf('...successfully computed curvature for %d/%d points\n', sum(~isnan(S)), N);

% S        : Scalar Curvatures
% dS       : standard errors
% gof      : goodness-of-fits
% hessmats : Hessian matrices for the 2FF (upper triangular in column-major order)
% vars     :
% CovB     : covariance matrices for 2FF (upper triangular in column-major order)

end


% npts = 1000;
% data = zeros(npts,3);
% for i=1:npts
%     tgt = randn(1,3);
%     data(i,:) = tgt/norm(tgt,2);
% end
% clear;
% load iris_dataset.mat;
% 
% data   = irisInputs';
% dim_mfld = 2;
% nbdsize=20;
% 
% hess_eigmin = zeros(npts,1);
% hess_eigmax = zeros(npts,1);
% 
% for i=1:npts
%     tgt_hess = hessmats{i};
%     nx = length(tgt_hess);
%     nn = round((-1 + sqrt(8*nx + 1))/2);
% 
%     mat_hess = zeros(nn,nn);
% 
%     mat_hess(triu(ones(nn))==1) = tgt_hess;
%     mat_hess  = mat_hess + mat_hess';
%     mat_hess  = mat_hess - diag(diag(mat_hess)/2);
% 
%     [~,tmpD] = eig(mat_hess);
%     hess_eigmax(i) = max(diag(tmpD));
%     hess_eigmin(i) = min(diag(tmpD));
% end
% 



% 
% sz = 25;
% scatter(embed2(:,1), embed2(:,2),sz,S,'filled')