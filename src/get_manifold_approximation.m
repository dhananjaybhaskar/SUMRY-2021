function [location, eigvecs] =  get_manifold_approximation(data, query, ndim)

% Replicate of Yariv's Implementation : First 'ndim' columns are eigvecs
%% initialization
R = data';        % (n x N) -> data is (N x n) format with N obs.
n = size(R, 1);   % n : ambient dimension
N = size(R, 2);   % N : number of observations
d = round(ndim);

[V,~] = eig(cov(data));
U = V(:,linspace(n,n-d+1,d)); % initial subspace
q_old = reshape(query, n, 1); % ensure as a column vector
r     = reshape(query, n, 1);

%% iteration
maxiter = 50;
abstol  = 1e-7;
for it=1:maxiter
    Rtilde = R - repmat(q_old,1,N);    % (n x N)
    Xtilde = [ones(N,1), (Rtilde'*U)]; % (N x d+1)
    alpha  = (Xtilde'*Xtilde)\(Xtilde'*Rtilde');
    qtilde = q_old + alpha(1,:)';
    [U,~]  = qr(alpha(2:end,:)');
    U      = U(:,1:d);
    q_new  = q_old + U*U'*(r-qtilde);

    q_inc = norm(q_old-q_new,2);
    q_old = q_new;
    if (q_inc < abstol)
        break;
    end
end

%% QR Decomposition
BB = eye(n);
BB(:,1:d) = U;
[eigvecs,~] = qr(BB);

%% report
location = q_old;


end