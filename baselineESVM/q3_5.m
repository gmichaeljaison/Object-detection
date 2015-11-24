addpath(genpath('../utils'));
addpath(genpath('../lib/esvm'));
load('../data/bus_esvm.mat');
load('../data/bus_data.mat');

%%
N = numel(models);
alpha = 50;

filterResponses = [];
imclips = zeros(100,100,3,N);

for i = 1 : numel(models)
    model = models{i};
    
    I = imread(['../data/voc2007/', model.I]);
    
    box = model.gt_box;
    im_clipped = I(box(2):box(4), box(1):box(3), :);
    imclips(:,:,:,i) = imresize(im_clipped, [100,100]);
    
    filtR = extractHOGFeatures(imclips(:,:,:,i));
    filterResponses = [filterResponses; filtR];
end

%%

Ks = 10 : 15 : 100;
params = esvm_get_default_params();
APs = zeros(numel(Ks), 1);
dictionary = cell(numel(Ks), 1);
compactSVMs = cell(numel(Ks), 1);

for i = 1 : numel(Ks)
    [~, dictionary{i}] = kmeans(filterResponses, Ks(i), 'EmptyAction','drop');
    
    dist = pdist2(dictionary{i}, filterResponses);
    [~, minIndices] = min(dist, [], 2);

    compactSVMs{i} = models(minIndices);
    
    boundingBoxes = batchDetectImageESVM(gtImages, compactSVMs{i}, params);
    
    [~,~,APs(i)] = evalAP(gtBoxes, boundingBoxes);
end

plot(Ks,APs);

%%
% Average images in the cluster
[~,i] = max(APs);

dist = pdist2(filterResponses, dictionary{i});
[~, minIndices] = min(dist, [], 2);

K = Ks(i);
avg_imgs = uint8(zeros(100,100,3,K));

for k = 1 : K
    imgs_k = find(minIndices == k);
    avg_im = zeros(size(imclips(:,:,:,1)));
    for j = 1 : numel(imgs_k)
        avg_im = avg_im + imclips(:,:,:,imgs_k(j));
    end
    avg_imgs(:,:,:,k) = uint8(avg_im / numel(imgs_k));
end

montage(avg_imgs);
