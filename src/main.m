clear all
clc
load('dataSet/Training/1grader_1.xml'); %X1grader_1
V = dicomread('dataSet/Training/1.dcm');

opts = trainingOptions('sgdm');
n_sample = 1000;
gt = categorical([ones(n_sample,1);zeros(n_sample,1)]);

%% first scale segmentation network
patch_size = 21;
patches = sampleVolume(V, X1grader_1, patch_size, n_sample);

layers1 = [imageInputLayer([21 21],'DataAugmentation','randfliplr');
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          fullyConnectedLayer(128);
          fullyConnectedLayer(2);
          softmaxLayer()
          classificationLayer()];
      
net1 = trainNetwork(patches,gt,layers1,opts);

%% second scale segmentation network
patch_size = 41;
patches = sampleVolume(V, X1grader_1, patch_size, n_sample);

layers2 = [imageInputLayer([41 41],'DataAugmentation','randfliplr');
          maxPooling2dLayer(2,'Stride',2);
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          fullyConnectedLayer(128);
          fullyConnectedLayer(2);
          softmaxLayer()
          classificationLayer()];
      
net2 = trainNetwork(patches,gt,layers2,opts);

%% third scale segmentation network
patch_size = 81;
patches = sampleVolume(V, X1grader_1, patch_size, n_sample);

layers3 = [imageInputLayer([81 81],'DataAugmentation','randfliplr');
          maxPooling2dLayer(4,'Stride',4);
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,16,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,32,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,64,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          convolution2dLayer(3,128,'Padding',1,'BiasLearnRateFactor',0.1);
          reluLayer();
          fullyConnectedLayer(128);
          fullyConnectedLayer(2);
          softmaxLayer()
          classificationLayer()];
      
net3 = trainNetwork(patches,gt,layers3,opts);
%% Classification using networks created ---------------------------------------------------------

patch_size = 21;
patches_test = sampleVolume(V, X1grader_1, patch_size, 100000);  % select all the possible pixels in the volume

seg1 = classify(net1,patches_test);
seg2 = classify(net1,patches_test);
seg3 = classify(net1,patches_test);

%% ----------------------------------------------------------------------------------------------

% Multiscale fusion is left

%% ------------------------------------------------------------------------------------------



% c = (X1grader_1((X1grader_1(:,3) == 85),:));

% figure();
% imagesc(V(:,:,85));
% figure();
% imagesc(V(:,:,85));
% hold on;
% plot(c(:,2),c(:,1),'b.');