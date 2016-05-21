load('../dataSet/Training/1grader_1.xml'); %X1grader_1
V = dicomread('../dataSet/Training/1.dcm');

patch_size = 21;
n_sample = 400;

[pos_patches, neg_patches] = sampleVolume(V, X1grader_1, patch_size, n_sample);

% c = (X1grader_1((X1grader_1(:,3) == 85),:));

% figure();
% imagesc(V(:,:,85));
% figure();
% imagesc(V(:,:,85));
% hold on;
% plot(c(:,2),c(:,1),'b.');