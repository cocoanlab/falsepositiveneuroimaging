%% load dacc data
basedir = pwd; % start from the directory where you downloaded this repository
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'data_onlydacc_addsmooth1.mat'));

%% simulation

% 10000 iteration to make the distributions of peak distance and
% pattern correlation within the dACC 

fprintf('\niteration:      ');
j = 0;

for i = 1:10000
    fprintf('\b\b\b\b\b%05d', i);
    random_subj_idx = randperm(59);
    
    % pain sample 1
    dat_hot_warm = dat_hot_dacc;
    dat_hot_warm.dat = dat_hot_dacc.dat(:,random_subj_idx(1:29)) - dat_warm_dacc.dat(:,random_subj_idx(1:29));
    mdat_hot1 = mean(dat_hot_warm);
    [~, idx] = max(mdat_hot1.dat);
    xyz = mdat_hot1.volInfo.xyzlist(~mdat_hot1.removed_voxels,:);
    peak_xyz_pain(i,1:3) = xyz(idx,:);
    
    % pain sample 2
    dat_hot_warm = dat_hot_dacc;
    dat_hot_warm.dat = dat_hot_dacc.dat(:,random_subj_idx(30:end)) - dat_warm_dacc.dat(:,random_subj_idx(30:end));
    mdat_hot2 = mean(dat_hot_warm);
    [~, idx] = max(mdat_hot2.dat);
    xyz = mdat_hot2.volInfo.xyzlist(~mdat_hot2.removed_voxels,:);
    peak_xyz_pain(i,4:6) = xyz(idx,:);
    
    correlation_pain_pattern(i,1) = corr(mdat_hot1.dat, mdat_hot2.dat);
    
    % rejection sample 1
    dat_rej_friend = dat_hot_dacc;
    dat_rej_friend.dat = dat_rejector_dacc.dat(:,random_subj_idx(1:29)) - dat_friend_dacc.dat(:,random_subj_idx(1:29));
    mdat_rej1 = mean(dat_rej_friend);
    [~, idx] = max(mdat_rej1.dat);
    xyz = mdat_rej1.volInfo.xyzlist(~mdat_rej1.removed_voxels,:);
    peak_xyz_rej(i,1:3) = xyz(idx,:);
    
    % rejection sample 2
    dat_rej_friend = dat_hot_dacc;
    dat_rej_friend.dat = dat_rejector_dacc.dat(:,random_subj_idx(30:end)) - dat_friend_dacc.dat(:,random_subj_idx(30:end));
    mdat_rej2 = mean(dat_rej_friend);
    [~, idx] = max(mdat_rej2.dat);
    xyz = mdat_rej2.volInfo.xyzlist(~mdat_rej2.removed_voxels,:);
    peak_xyz_rej(i,4:6) = xyz(idx,:);
    
    correlation_rej_pattern(i,1) = corr(mdat_rej1.dat, mdat_rej2.dat);
    
end


%% histograms

close all;
subplot(2,2,1);
histogram(peak_distance_rej_all, 30);
title('rejection: distribution of peak distance');
subplot(2,2,2);
histogram(correlation_rej_pattern, 30);
title('rejection: distribution of pattern correlation');
subplot(2,2,3);
histogram(peak_distance_pain_all, 20);
title('pain: distribution of peak distance');
subplot(2,2,4);
histogram(correlation_pain_pattern, 30);
title('pain: distribution of pattern correlation');


%% scatter plots

peak_distance_pain_all = sqrt(sum((peak_xyz_pain(:,1:3)-peak_xyz_pain(:,4:6)).^2,2))*2;
peak_distance_rej_all = sqrt(sum((peak_xyz_rej(:,1:3)-peak_xyz_rej(:,4:6)).^2,2))*2;

scatter(peak_distance_rej_all, correlation_rej_pattern, 30, [188,128,189]./255, 'filled', 'markerfacealpha', .7);
hold on; scatter(peak_distance_pain_all, correlation_pain_pattern, 30, [251,128,114]./255, 'filled', 'markerfacealpha', .7);
h = refline;

h(1).Color = [251,128,114]./255-.2;
h(1).LineWidth = 2;

h(2).Color = [188,128,189]./255-.2;
h(2).LineWidth = 2;

set(gcf, 'position', [1000        1020         396         318], 'color', 'w');
set(gca, 'linewidth', 1.5, 'tickdir', 'out', 'ticklength', [.02 .02], 'fontsize', 17, 'xlim', [-1 70]);