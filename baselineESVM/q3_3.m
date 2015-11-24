load('../data/bus_esvm.mat');
load('../data/bus_data.mat');
params = esvm_get_default_params();

levels_per_octave = [3,5,10];
APs = zeros(3,1);
boundingBoxes = cell(3,1);

numCores = 4;
% pool = parpool('local', numCores);

for i = 1 : numel(levels_per_octave)
    lpo = levels_per_octave(i);
    params.detect_levels_per_octave = lpo;
    boundingBoxes{i} = batchDetectImageESVM(gtImages, models, params);
    
    [~,~,APs(i)] = evalAP(gtBoxes, boundingBoxes{i});
end

% delete(pool);

plot(levels_per_octave, APs);
