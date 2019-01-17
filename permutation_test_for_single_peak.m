%% load data

load('data_onlydacc_addsmooth1')
%% plot one peak
close all;

h = glass_brain_network([], 'center', xyz(:,idx_rej_first30)',...
    'colors', [0    0.4470    0.7410], 'radius', 4, 'inflated', ...
    'nocerebellum', 'cortex_alpha', .1, 'sphere');

set(gcf, 'position', [1   395   959   950]);
view(123, 28);


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

%% permutation tests for rejection

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

%     [~,idx]=max(dat_rej_friend_temp.dat);
%     peak_xyz_rej_perm(i,:) = mean(xyz(:,idx)');
    [~,idx] = max(mean(dat_rej_friend_temp.dat,2));
    peak_xyz_rej_perm(i,:) = xyz(:,idx)';
end

%% peak reject permutation histogram

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


%% permutation tests for pain

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

%     [~,idx]=max(dat_hot_warmth_temp.dat);
%     peak_xyz_pain_perm(i,:) = mean(xyz(:,idx)');
%     
    [~,idx]=max(mean(dat_hot_warmth_temp.dat,2));
    peak_xyz_pain_perm(i,:) = xyz(:,idx)';
end

%% peak pain permutation histogram

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

