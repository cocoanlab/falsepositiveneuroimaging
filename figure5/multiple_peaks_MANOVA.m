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
%% Plot multiple peaks

close all;

h = glass_brain_network([], 'center', xyz(:,idx_rej_first30_indiv)',...
    'colors', [0    0.4470    0.7410], 'radius', 2.5, 'inflated', ...
    'nocerebellum', 'cortex_alpha', .1, 'sphere');

set(gcf, 'position', [1   395   959   950]);
view(123, 28);

%% MANOVA for rejection
group = [ones(30,1);ones(29,1).*2];
X = [xyz(:,idx_rej_first30_indiv)';xyz(:,idx_rej_last29_indiv)'];
[d, p, stats] = manova1(X, group);

% lambda: 0.8119
%  chisq: 11.5681
%  chisqdf: 3
%      p = 0.009

close all;

h = glass_brain_network([], 'center', [xyz(:,idx_rej_last29_indiv)'; xyz(:,idx_rej_first30_indiv)'],...
    'colors', [[0.8500    0.3250    0.0980];[0    0.4470    0.7410]], 'radius', 1.5, 'inflated', ...
    'nocerebellum', 'cortex_alpha', .1,'group', [ones(29,1); 2*ones(30,1)], 'sphere');

set(gcf, 'position', [1   395   959   950]);

results1 = confidence_volume(xyz(:,idx_rej_last29_indiv)');
results2 = confidence_volume(xyz(:,idx_rej_first30_indiv)');

clear h;
hold on;
h{1} = surf(results1.xP,results1.yP,results1.zP);
h{2} = surf(results2.xP,results2.yP,results2.zP);

for i = 1:2
    if i == 1
        h{i}.FaceColor = [0.8500    0.3250    0.0980];
    else
        h{i}.FaceColor = [0    0.4470    0.7410];
    end
    
    h{i}.EdgeAlpha = 0;
    h{i}.FaceAlpha = .5;
    h{i}.FaceLighting = 'gouraud';
    h{i}.AmbientStrength = .4;
    h{i}.DiffuseStrength = 1;
    h{i}.SpecularStrength = .1;
end

set(gcf, 'position', [1    91   897   864]);

view(123, 28);
%% MANOVA for pain
group = [ones(30,1);ones(29,1).*2];
X = [xyz(:,idx_pain_first30_indiv)';xyz(:,idx_pain_last29_indiv)'];
[d, p, stats] = manova1(X, group);

% lambda: 0.9503
%        chisq: 2.8316
%      chisqdf: 3
%      p = 0.4183

close all;

h = glass_brain_network([], 'center', [xyz(:,idx_pain_last29_indiv)'; xyz(:,idx_pain_first30_indiv)'],...
    'colors', [[0.8500    0.3250    0.0980];[0    0.4470    0.7410]], 'radius', 1.5, 'inflated', ...
    'nocerebellum', 'cortex_alpha', .1,'group', [ones(29,1); 2*ones(30,1)], 'sphere');

set(gcf, 'position', [1   395   959   950]);

results1 = confidence_volume(xyz(:,idx_pain_last29_indiv)');
results2 = confidence_volume(xyz(:,idx_pain_first30_indiv)');

clear h;
hold on;
h{1} = surf(results1.xP,results1.yP,results1.zP);
h{2} = surf(results2.xP,results2.yP,results2.zP);

for i = 1:2
    if i == 1
        h{i}.FaceColor = [0.8500    0.3250    0.0980];
    else
        h{i}.FaceColor = [0    0.4470    0.7410];
    end
    
    h{i}.EdgeAlpha = 0;
    h{i}.FaceAlpha = .5;
    h{i}.FaceLighting = 'gouraud';
    h{i}.AmbientStrength = .4;
    h{i}.DiffuseStrength = 1;
    h{i}.SpecularStrength = .1;
end

set(gcf, 'position', [1    91   897   864]);

view(123, 28);
