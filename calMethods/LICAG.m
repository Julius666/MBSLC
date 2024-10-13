function [SE] = LICAG(X, dim, n_anchors, n_neighbors)
n_views = length(X);
n_points = size(X{1}, 2);

if dim == 0
    dim = n_anchors;
end

if n_neighbors == 0 || n_neighbors > n_anchors - 1
    n_neighbors = n_anchors - 1;
end

XX = [];
for i = 1:n_views
    XX = [XX X{i}'];
end
rand('twister',5489);
[ind,~] = DBE(XX,n_anchors);
anchors=XX(ind,:);
W = sparse(n_points + n_views * n_anchors, n_points + n_views * n_anchors);
beg = 1;
for k=1:n_views
        Xk = X{k};
        n_features = size(Xk, 1);
        anchor_k = anchors(:, beg:beg + n_features - 1);
        Z = anchor_graph_construction(Xk, anchor_k', n_neighbors);
        W(n_points+(k-1)*n_anchors+1 : n_points+k*n_anchors, 1 : n_points) = Z;
        W(1 : n_points, n_points+(k-1)*n_anchors+1 : n_points+k*n_anchors) = Z';
end
normalized = 1;
L = laplacian(W, normalized);
[SE, ~] = eigs(L, dim, 'sa');  % 'smallestreal'
SE = SE(1:n_points,:)';
end


function [L]=laplacian(W, normalized)
n = size(W,1);
d = sum(W,2);
if normalized
    if issparse(W)
        Dn = diag(d.^(-0.5));
        % CAREFUL: a zero row/column in W is followed by an inf in d,
        % but their multiplication gives zero again (because of using
        % sparse).
        L = speye(n) - Dn * W * Dn;
    else
        ind = d>0;
        L = - W;
        % Ln = D^(-1/2) L D^(-1/2)
        L(ind, :) = bsxfun(@times, L(ind, :), 1./sqrt(d(ind)));
        L(:, ind) = bsxfun(@times, L(:, ind), 1./sqrt(d(ind))');
        % put back diagonal to identity
        % Note: for disconnected nodes we should still have 1 on diagonal
        % (limit of L for W -> 0)
        L(1:n+1:end) = 1;
    end
else
    L = diag(d)-W;
end
end
