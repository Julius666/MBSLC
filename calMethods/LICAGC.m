function [p,prediction] = LICAGC(data_dir, dataset, rate, dim, n_clusters)
default_parameters = [
    "data_dir",     "'datasets'";
    "dataset",      "";
    "rate",         0.1;
    "dim"           10;
    "n_clusters",	0;
    "max_iter",     100;
    "verbose",      0;
];
tic
for i=4:size(default_parameters, 1)
    if nargin < i
        s = strcat(default_parameters(i, 1), "=", default_parameters(i, 2), ";");
        eval(s);
    end
end

load(fullfile(data_dir, dataset), "X", "surv");
for i = 1:length(X)
    X{i}=X{i}';
    if strcmp(dataset,'KRCCC')||strcmp(dataset,'Bladder')||strcmp(dataset,'LGG')
        N = Standard_Normalization(X{i});
        N = standardizeCols(N);
    else
        N = normalization(X{i},"range",1);
    end
    X{i} = N';
end
n_anchors = floor(rate * length(surv));
n_neighbors = n_anchors - 1;

Z = LICAG(X, dim, n_anchors, n_neighbors);
if verbose
    for i=1:size(default_parameters, 1)
        eval(default_parameters(i,1));
    end
end   
try    
    [prediction] = spectralcluster(Z', n_clusters);
    toc
    group = num2str(prediction);
    group = num2cell(group);
    [p,~]=MatSurv(surv(:,1),surv(:,2),group);
catch
    p=1;
    prediction=0;
end