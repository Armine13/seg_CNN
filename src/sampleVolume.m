function [patches] = sampleVolume(V, grader, p_sz, n)
% n = 400;
% grader = X1grader_1;
% p_sz = 21;

%List of slices with cysts
% pos_slice_idx = unique(grader(:,3));

%sample n pixels from list with replacement
pos_idx = randsample(length(grader), n, true);

%% Extract patches around each positive sample
pos_patches = zeros(p_sz,p_sz,1, n);
s = (p_sz - 1) / 2;

for i = 1:length(pos_idx),
    ii = pos_idx(i);
    r = grader(ii, 1);
    c = grader(ii, 2);
    
    
    if r- s > 0 && r+s <= size(V, 1) && c-s > 0 && c+s <= size(V, 2),
        patch = V(r-s:r+s, c-s:c+s, 1, grader(ii, 3));
        pos_patches(:,:,:,i) = patch;
    end
end

neg_idx = zeros(n, 3);
for i = 1:n,
    while(1),
        %randomly select slice
        k = randi(size(V, 4), 1);
        
        %randomly select pixel
        r = randi([s+1, size(V,1)-s-1], 1);
        c = randi([s+1, size(V,2)-s-1], 1);
        
        [b1, ~] = ismember([r, c, k], neg_idx, 'rows');
        [b2, ~] = ismember([r, c, k], grader, 'rows');
        if b1 == 0 && b2 == 0,
            neg_idx(i, :) = [r, c, k];
            break;
        end
    end
end

%% Extract patches around each negative sample
neg_patches = zeros(p_sz,p_sz,1, n);

for i = 1:size(neg_idx, 1),
    r = neg_idx(i, 1);
    c = neg_idx(i, 2);
    k = neg_idx(i, 3);
    
    if r- s > 0 && r+s <= size(V, 1) && c-s > 0 && c+s <= size(V, 2),
        patch = V(r-s:r+s, c-s:c+s, 1, k);
        neg_patches(:,:,:,i) = patch;
    end
end

patches(:,:,1,1:n) = pos_patches;
patches(:,:,1,n+1:2*n) = neg_patches;
