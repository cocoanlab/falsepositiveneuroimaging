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


% pain sample 
dat_pain_warm = dat_hot_dacc;
dat_pain_warm.dat = dat_hot_dacc.dat - dat_warm_dacc.dat;

[~, idx_pain_first30] = max(mean(dat_pain_warm.dat(:,1:30),2));

[~, idx_pain_first30_indiv] = max(dat_pain_warm.dat(:,1:30));

[~, idx_pain_last29] = max(mean(dat_pain_warm.dat(:,31:59),2));

[~, idx_pain_last29_indiv] = max(dat_pain_warm.dat(:,31:59));

xyz = voxel2mm(dat_rej_friend.volInfo.xyzlist(~dat_rej_friend.removed_voxels,:)', dat_rej_friend.volInfo.mat);
%% Pattern expression classification test for rejector

dat_classify = dat_rejector_dacc;
dat_classify.dat = [dat_hot_dacc.dat(:,1:30) dat_warm_dacc.dat(:,1:30)];
dat_classify.Y = [ones(30,1);-ones(30,1)];

[cverr, stats, optout] = predict(dat_classify, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

% pattern_model = '/Users/clinpsywoo/Nas/replication/data/svm_rej_fri_first30.nii';
pattern_model = '/Users/hong/project/replication/data/svm_rej_fri_first30.nii';

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
%% draw classification test for rejector

create_figure('plot');
set(gcf, 'Position', [1   511   253   194]);

data = pexp;

cols = [0.8353    0.2431    0.3098
    0.9922    0.6824    0.3804];

close all;
boxplot_wani_2016(data, 'color', cols, 'linewidth', 2, 'boxlinewidth', 1, ...
    'reflinecolor', [.8 .8 .8], 'mediancolor', 'k');%,...

set(gcf, 'position', [ 1   399   363   306]);
set(gca, 'fontsize', 20, 'xlim', [0.5 2.5], 'linewidth', 1.5, 'ticklength', [.03 .03], 'xticklabel', '', 'ytick', -4:2:4);

xdot{1} = ones(29,1)*1+.29;
xdot{2} = ones(29,1)*2-.29;

correct_idx = data(:,1) > data(:,2);
incorrect_idx = data(:,1) < data(:,2);

h1 = line([xdot{1}(correct_idx) xdot{2}(correct_idx)]', data(correct_idx,1:2)', 'color', [255 207 188]./255, 'linewidth', 1.5);
h1 = line([xdot{1}(incorrect_idx) xdot{2}(incorrect_idx)]', data(incorrect_idx,1:2)', 'color', [195 222 253]./255, 'linewidth', 1.5);

scatter(xdot{1}, data(:,1), 20, cols(1,:), 'filled'); 
scatter(xdot{2}, data(:,2), 20, cols(2,:), 'filled'); 

set(gcf, 'position', [ 1   440   268   265]);


%% Pattern expression classification test for pain

dat_classify = dat_rejector_dacc;
dat_classify.dat = [dat_hot_dacc.dat(:,1:30) dat_warm_dacc.dat(:,1:30)];
dat_classify.Y = [ones(30,1);-ones(30,1)];

[cverr, stats, optout] = predict(dat_classify, 'algorithm_name', 'cv_svm', 'nfolds', 1, 'error_type', 'mcr');

% pattern_model = '/Users/clinpsywoo/Nas/replication/data/svm_pain_warm_first30.nii';
pattern_model = '/Users/hong/project/replication/data/svm_pain_warm_first30.nii';
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

%% draw classification test for pain

create_figure('plot');
set(gcf, 'Position', [1   511   253   194]);

data = pexp;

cols = [0.8353    0.2431    0.3098
    0.9922    0.6824    0.3804];

close all;
boxplot_wani_2016(data, 'color', cols, 'linewidth', 2, 'boxlinewidth', 1, ...
    'reflinecolor', [.8 .8 .8], 'mediancolor', 'k');%,...

set(gcf, 'position', [ 1   399   363   306]);
set(gca, 'fontsize', 20, 'xlim', [0.5 2.5], 'linewidth', 1.5, 'ticklength', [.03 .03], 'xticklabel', '', 'ytick', -8:2:8);

xdot{1} = ones(29,1)*1+.29;
xdot{2} = ones(29,1)*2-.29;

correct_idx = data(:,1) > data(:,2);
incorrect_idx = data(:,1) < data(:,2);

h1 = line([xdot{1}(correct_idx) xdot{2}(correct_idx)]', data(correct_idx,1:2)', 'color', [255 207 188]./255, 'linewidth', 1.5);
h1 = line([xdot{1}(incorrect_idx) xdot{2}(incorrect_idx)]', data(incorrect_idx,1:2)', 'color', [195 222 253]./255, 'linewidth', 1.5);

scatter(xdot{1}, data(:,1), 20, cols(1,:), 'filled'); 
scatter(xdot{2}, data(:,2), 20, cols(2,:), 'filled'); 

set(gcf, 'position', [ 1   440   268   265]);

