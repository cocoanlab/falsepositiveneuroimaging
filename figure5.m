%% load data

basedir = pwd; % start from the directory where you downloaded this repository
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'data_onlydacc_addsmooth1.mat'));


%% simulation

% rejection sample 
dat_rej_friend = dat_hot_dacc;
dat_rej_friend.dat = dat_rejector_dacc.dat - dat_friend_dacc.dat;

[~, idx_rej_first30] = max(mean(dat_rej_friend.dat(:,1:30),2));
[~, idx_rej_first30_indiv] = max(dat_rej_friend.dat(:,1:30));
[~, idx_rej_last29] = max(mean(dat_rej_friend.dat(:,31:59),2));
[~, idx_rej_last29_indiv] = max(dat_rej_friend.dat(:,31:59));


% pain sample 
dat_pain_warm = dat_hot_dacc;
dat_pain_warm.dat = dat_hot_dacc.dat - dat_warm_dacc.dat;

[~, idx_pain_first30] = max(mean(dat_pain_warm.dat(:,1:30),2));
[~, idx_pain_first30_indiv] = max(dat_pain_warm.dat(:,1:30));
[~, idx_pain_last29] = max(mean(dat_pain_warm.dat(:,31:59),2));
[~, idx_pain_last29_indiv] = max(dat_pain_warm.dat(:,31:59));

%% A. Permutation tests for peak distance

%% A-1. permutation tests for rejection

dat_rej_friend_temp = dat_hot_dacc;
dat_all = [dat_rejector_dacc.dat(:,31:end) dat_friend_dacc.dat(:,31:end)];
xyz = voxel2mm(dat_rej_friend_temp.volInfo.xyzlist(~dat_rej_friend_temp.removed_voxels,:)', dat_rej_friend_temp.volInfo.mat);
peak_xyz_rej_perm = [];

disp('========================');
fprintf('iteration:      ')

idx1 = [1:29;30:58]';

for i = 1:10000
    fprintf('\b\b\b\b\b%05d', i);
    
    idx2 = [];
    for j = 1:29
        idx2(j,:) = idx1(j,randperm(2));
    end
        
    temp_dat = dat_all(:,idx2);
    dat_rej_friend_temp.dat = temp_dat(:,1:29) - temp_dat(:,30:end);

    [~,idx] = max(mean(dat_rej_friend_temp.dat,2));
    peak_xyz_rej_perm(i,:) = xyz(:,idx)';
    
end

d = sqrt(sum((xyz(:,idx_rej_first30)'- xyz(:,idx_rej_last29)').^2,2));
dd = sqrt(sum((peak_xyz_rej_perm - xyz(:,idx_rej_first30)').^2,2));
close all;
h = histogram(dd, 30);

line([mean(d) mean(d)],  [0 1300], 'linewidth', 3, 'color', [0.7608 0.3020 0])

h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1123         418         215]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', 0:300:1500, 'xtick', 0:20:70, 'ylim', [0 1200], 'xlim', [0 68]);

p = sum(dd<d)./10000;


%% A-2. permutation tests for pain

dat_hot_warmth_temp = dat_hot_dacc;
dat_all = [dat_hot_dacc.dat(:,31:end) dat_warm_dacc.dat(:,31:end)];
xyz = voxel2mm(dat_hot_warmth_temp.volInfo.xyzlist(~dat_hot_warmth_temp.removed_voxels,:)', dat_hot_warmth_temp.volInfo.mat);
peak_xyz_pain_perm = [];

disp('========================');
fprintf('iteration:      ')


idx1 = [1:29;30:58]';

for i = 1:10000
    fprintf('\b\b\b\b\b%05d', i);
    
    idx2 = [];
    for j = 1:29
        idx2(j,:) = idx1(j,randperm(2));
    end
    
    temp_dat = dat_all(:,idx2(:));
    dat_hot_warmth_temp.dat = temp_dat(:,1:29) - temp_dat(:,30:end);

    [~,idx]=max(mean(dat_hot_warmth_temp.dat,2));
    peak_xyz_pain_perm(i,:) = xyz(:,idx)';
end

d = sqrt(sum((xyz(:,idx_pain_first30)'- xyz(:,idx_pain_last29)').^2,2));
dd = sqrt(sum((peak_xyz_pain_perm - xyz(:,idx_pain_first30)').^2,2));
close all;
h = histogram(dd, 30);

line([mean(d) mean(d)],  [0 1300], 'linewidth', 3, 'color', [0.7608 0.3020 0])

h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1123         418         215]);
box off;

set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', 0:300:1500, 'xtick', 0:20:70, 'ylim', [0 1200], 'xlim', [0 60]);

p = sum(dd<d)./10000;

%% B-1. draw confidence region

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

%% B-2. Bayesian MANOVA

% see bayesian_manova.R

%% C. Pattern similarity

%% C-1. Permutation test for rejector pattern similarity

first30_pattern = mean(dat_rej_friend.dat(:,1:30),2);
last29_pattern = mean(dat_rej_friend.dat(:,31:end),2);

dat_rej_friend_temp = dat_hot_dacc;
dat_all = [dat_rejector_dacc.dat(:,31:end) dat_friend_dacc.dat(:,31:end)];

disp('========================');
fprintf('iteration:      ')

idx1 = [1:29;30:58]';

for i = 1:10000
    fprintf('\b\b\b\b\b%05d', i);
    
    idx2 = [];
    for j = 1:29
        idx2(j,:) = idx1(j,randperm(2));
    end

    temp_dat = dat_all(:,idx2(:));
    dat_rej_friend_temp.dat = temp_dat(:,1:29) - temp_dat(:,30:end);

    pattern_simil_perm(i,1) = corr(mean(dat_rej_friend_temp.dat,2), first30_pattern);
end

p = sum(pattern_simil_perm > corr(last29_pattern, first30_pattern))./10000;

%% C-2. Permutation test for pain pattern similarity

first30_pattern = mean(dat_pain_warm.dat(:,1:30),2);
last29_pattern = mean(dat_pain_warm.dat(:,31:end),2);

dat_pain_warm_temp = dat_hot_dacc;
dat_all = [dat_hot_dacc.dat(:,31:end) dat_warm_dacc.dat(:,31:end)];
xyz = voxel2mm(dat_pain_warm_temp.volInfo.xyzlist(~dat_pain_warm_temp.removed_voxels,:)', dat_pain_warm_temp.volInfo.mat);

pattern_simil_perm = [];

disp('========================');
fprintf('iteration:      ')

idx1 = [1:29;30:58]';

for i = 1:10000
    fprintf('\b\b\b\b\b%05d', i);
    
    idx2 = [];
    for j = 1:29
        idx2(j,:) = idx1(j,randperm(2));
    end
    
    temp_dat = dat_all(:,idx2(:));
    dat_pain_warm_temp.dat = temp_dat(:,1:29) - temp_dat(:,30:end);

    pattern_simil_perm(i,1) = corr(mean(dat_pain_warm_temp.dat,2), first30_pattern);
end

p = sum(pattern_simil_perm > corr(last29_pattern, first30_pattern))./10000;


%% D. Pattern expression classification test for rejector

dat_classify = dat_rejector_dacc;
dat_classify.dat = [dat_hot_dacc.dat(:,1:30) dat_warm_dacc.dat(:,1:30)];
dat_classify.Y = [ones(30,1);-ones(30,1)];

[~, stats, ~] = predict(dat_classify, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

pattern_model = fullfile(datdir, 'svm_rej_fri_first30.nii');
stats.weight_obj.fullpath = pattern_model;
write(stats.weight_obj);

dat_rej_temp = dat_rejector_dacc;
dat_rej_temp.dat = dat_rej_temp.dat(:,31:end);
dat_friend_temp = dat_friend_dacc;
dat_friend_temp.dat = dat_friend_temp.dat(:,31:end);
dat_rej_temp.removed_images = dat_rej_temp.removed_images(1:29);
dat_friend_temp.removed_images = dat_friend_temp.removed_images(1:29);

pexp = apply_mask(dat_rej_temp, pattern_model, 'pattern_expression', 'ignore_missing');
pexp(:,2) = apply_mask(dat_friend_temp, pattern_model, 'pattern_expression', 'ignore_missing');

roc_plot(pexp(:), [true(29,1);false(29,1)], 'twochoice');


%% Pattern expression classification test for pain

dat_classify = dat_rejector_dacc;
dat_classify.dat = [dat_hot_dacc.dat(:,1:30) dat_warm_dacc.dat(:,1:30)];
dat_classify.Y = [ones(30,1);-ones(30,1)];

[~, stats, ~] = predict(dat_classify, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

pattern_model = fullfile(datdir, 'svm_pain_warm_first30.nii');
stats.weight_obj.fullpath = pattern_model;
write(stats.weight_obj);

dat_pain_temp = dat_hot_dacc;
dat_pain_temp.dat = dat_pain_temp.dat(:,31:end);
dat_warm_temp = dat_warm_dacc;
dat_warm_temp.dat = dat_warm_temp.dat(:,31:end);
dat_pain_temp.removed_images = dat_pain_temp.removed_images(1:29);
dat_warm_temp.removed_images = dat_warm_temp.removed_images(1:29);

pexp = apply_mask(dat_pain_temp, pattern_model, 'pattern_expression', 'ignore_missing');
pexp(:,2) = apply_mask(dat_warm_temp, pattern_model, 'pattern_expression', 'ignore_missing');

roc_plot(pexp(:), [true(29,1);false(29,1)], 'twochoice');
