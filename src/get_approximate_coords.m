function [local_coords, dim_nt, vars] = get_approximate_coords(data, dim_req)

% this is the main replacement for 'get_orthonormal_coords'.
% always assume that the FIRST OBSERVATION is the query point.

[n,d] = size(data);
query = data(1,:);
[approx_loc, approx_sub] = get_manifold_approximation(data, query, dim_req);

approx_loc   = reshape(approx_loc,1,d);
local_coords = (data-repmat(approx_loc,n,1))*approx_sub;

var_vector = zeros(d,1);
for i=1:d
    var_vector(i) = var(local_coords(:,i));
end
vars = 100*var_vector/sum(var_vector); % same as the percentage

if (~isempty(vars))
    dim_nt = find(vars/vars(1) > CurvParams.trivial_dim_var, 1, 'last');
else
    dim_nt = 0;
end
end