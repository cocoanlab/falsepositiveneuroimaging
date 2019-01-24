%% load data

load('data_onlydacc_addsmooth1')
%% simulation

% rejection sample 
dat_rej_friend = dat_hot_dacc;
dat_rej_friend.dat = dat_rejector_dacc.dat - dat_friend_dacc.dat;

[~, idx_rej_first30] = max(mean(dat_rej_friend.dat(:,1:30),2));

[~, idx_rej_first30_indiv] = max(dat_rej_friend.dat(:,1:30));

[~, idx_rej_last29] = max(mean(dat_rej_friend.dat(:,31:59),2));

[~, idx_rej_last29_indiv] = max(dat_rej_friend.dat(:,31:59));

% [~,idx]=max(dat_rej_friend.dat);

% pain sample 
dat_pain_warm = dat_hot_dacc;
dat_pain_warm.dat = dat_hot_dacc.dat - dat_warm_dacc.dat;

[~, idx_pain_first30] = max(mean(dat_pain_warm.dat(:,1:30),2));

[~, idx_pain_first30_indiv] = max(dat_pain_warm.dat(:,1:30));

[~, idx_pain_last29] = max(mean(dat_pain_warm.dat(:,31:59),2));

[~, idx_pain_last29_indiv] = max(dat_pain_warm.dat(:,31:59));

xyz = voxel2mm(dat_rej_friend.volInfo.xyzlist(~dat_rej_friend.removed_voxels,:)', dat_rej_friend.volInfo.mat);
%% plot the peaks and confidence region
close all;
h = glass_brain_network([], 'center', xyz(:,idx_rej_last29_indiv)',...
    'colors', [0.8500    0.3250    0.0980], 'radius', 2.5, 'inflated', ...
    'nocerebellum', 'cortex_alpha', .1, 'sphere');

set(gcf, 'position', [1   395   959   950]);

results = confidence_volume(xyz(:,idx_rej_last29_indiv)');

clear h;
hold on;

h{1} = surf(results.xP,results.yP,results.zP);

for i = 1 
    if i == 1
        h{i}.FaceColor = [0.7451    0.6039    0.2000];
    else
        h{i}.FaceColor = [0    0.4470    0.7410];
    end
    
    h{i}.EdgeAlpha = 0;
    h{i}.FaceAlpha = .7;
    h{i}.FaceLighting = 'gouraud';
    h{i}.AmbientStrength = .4;
    h{i}.DiffuseStrength = 1;
    h{i}.SpecularStrength = .1;
end

set(gcf, 'position', [1    91   897   864]);

view(123, 28);