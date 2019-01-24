%% visualize peak coordinates distribution on brain
% meta_basedir =  '/Users/clinpsywoo/Nas/replication/data/Meta_Emotion_3_30_13';
% load(fullfile(meta_basedir, 'METAANALYSIS_2013_03_29_selected.mat'));

basedir = '/Users/hong/project/replication/data/Meta_Emotion_3_30_13';
load(fullfile(basedir, 'METAANALYSIS_2013_03_29_selected.mat'));

% filter_key:
%     'mni'
%     'fMRI'
%     'emotions (no neutral)'

% total 856 coordiates from 68 studies
 
%% draw
close all;
% h = glass_brain_network([], 'center', new_xyz(randi(size(new_xyz,1), 500,1),:), 'colors', [0.8500    0.3250    0.0980], 'radius', 2, 'cortex_alpha', .05);
h = glass_brain_network([], 'center', xyz, 'colors', [0.8500    0.3250    0.0980], 'radius', 2, 'cortex_alpha', .05);

% sagittal_view
view(90,0)

%% horizontal view
view(90,90)
%% sagittal view 2
view(-90,0)