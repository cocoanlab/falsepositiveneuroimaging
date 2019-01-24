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
%% Permutation test for rejector pattern similarity

first30_pattern = mean(dat_rej_friend.dat(:,1:30),2);
last29_pattern = mean(dat_rej_friend.dat(:,31:end),2);

dat_rej_friend_temp = dat_hot_dacc;
dat_all = [dat_rejector_dacc.dat(:,31:end) dat_friend_dacc.dat(:,31:end)];
xyz = voxel2mm(dat_rej_friend_temp.volInfo.xyzlist(~dat_rej_friend_temp.removed_voxels,:)', dat_rej_friend_temp.volInfo.mat);

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
%% histogram: permuted rejector pattern similarity 
close all;
h = histogram(pattern_simil_perm, 30);

line([corr(last29_pattern, first30_pattern), corr(last29_pattern, first30_pattern)],  [0 1300], 'linewidth', 3, 'color', [0.7608 0.3020 0])

h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1123         418         215]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', 0:200:1500, 'xtick', -.4:.2:.4, 'ylim', [0 900], 'xlim', [-.4 .4]);

%% Permutation test for pain pattern similarity

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
%% histogram: permuted pain pattern similarity 
close all;
h = histogram(pattern_simil_perm, 30);

line([corr(last29_pattern, first30_pattern), corr(last29_pattern, first30_pattern)],  [0 1300], 'linewidth', 3, 'color', [0.7608 0.3020 0])

h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1123         418         215]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', 0:200:1500, 'xtick', -.8:.4:.8, 'ylim', [0 700], 'xlim', [-.8 .8]);
