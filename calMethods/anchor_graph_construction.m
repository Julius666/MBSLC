function Z = anchor_graph_construction(data, anchors, m)
n = size(data,2);
n_anchors = size(anchors, 2);
E = pdist2(anchors', data').^2;

[SortedE, Ind] = sort(E);
Eim1 = repmat(SortedE(m+1,:),[n_anchors, 1]); 

%make a Indicator Mask to record j<=m or j>m
IndMask = zeros(n_anchors, n); 
for i = 1:n
    IndMask(Ind(1:m, i), i) = 1;
end

E_numerator = E.*IndMask;
Eim1_numerator = Eim1.*IndMask;

denominator = m*Eim1 - sum(E_numerator,1) + eps;
Z = (Eim1_numerator - E_numerator)./denominator;

end