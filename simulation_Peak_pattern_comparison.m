%% load dacc data

load('data_onlydacc_addsmooth1')

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


%% box-violin plots: peak distances of rejection data


figdir = fullfile(basedir, 'figures');

peak_distance_rej_all = sqrt(sum((peak_xyz_rej(:,1:3)-peak_xyz_rej(:,4:6)).^2,2))*2;

boxplot_wani_2016(peak_distance_rej_all, 'color', [.5 .5 .5], 'violin');
set(gca, 'linewidth', 1.2, 'fontsize', 18, 'YTick', 0:10:70);
set(gcf, 'position', [296   699   146   351]);
mean_reject_all=mean(peak_distance_rej_all);

set(gcf, 'paperpositionmode', 'auto', 'position',[296   700  400  600])


%% histogram: peak distances of rejection data
% distribution of peak distances 

close all;

h = histogram(peak_distance_rej_all, 30);
h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1036         552         302]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', [0 300 600 900 1200], 'xtick', 0:10:70, 'ylim', [0 1300], 'xlim', [0 66]);



%% box-violin plots: pattern correlations of rejection data

figdir = fullfile(basedir, 'figures');

boxplot_wani_2016(correlation_rej_pattern, 'color', [.5 .5 .5], 'violin');
set(gca, 'linewidth', 1.2, 'fontsize', 18, 'YTick', -1:.2:1, 'ylim', [-.5 .4]);
set(gcf, 'position', [296   699   146   351]);


%% histogram: pattern correlations of rejection data
% distribution of pattern correlations

close all;

h = histogram(correlation_rej_pattern, 30);
h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1036         552         302]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', [0 300 600 900 1200], 'ylim', [0 900], 'xlim', [-.5 .4]);



%% box-violin plots: peak distances of pain data

figdir = fullfile(basedir, 'figures');

peak_distance_pain_all = sqrt(sum((peak_xyz_pain(:,1:3)-peak_xyz_pain(:,4:6)).^2,2))*2;

boxplot_wani_2016(peak_distance_pain_all, 'color', [.5 .5 .5], 'violin');
set(gca, 'linewidth', 1.2, 'fontsize', 18, 'YTick', 0:5:25);
set(gcf, 'position', [296   699   146   351]);



%% histogram : peak distances of pain data
% distribution of peak distances

close all;

h = histogram(peak_distance_pain_all, 20);
h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1036         552         302]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', 0:500:3000, 'xtick', 0:5:70, 'xlim', [0 23], 'ylim', [0 1800]);

%% box-violin plots: pattern correlations of pain data

figdir = fullfile(basedir, 'figures');

boxplot_wani_2016(correlation_pain_pattern, 'color', [.5 .5 .5], 'violin');
set(gca, 'linewidth', 1.2, 'fontsize', 18, 'YTick', .4:.1:1, 'ylim', [.4 .9]);
set(gcf, 'position', [296   699   146   351]);


%% histogram: pattern correlations of pain data
%correlation_pain_pattern
% distribution of pattern correlations

close all;

h = histogram(correlation_pain_pattern, 30);
h.FaceColor = [.5 .5 .5];
h.EdgeColor = 'w';
h.LineWidth = 1.2;
set(gcf, 'color', 'w', 'Position', [1000        1036         552         302]);
box off;
set(gca, 'TickDir', 'out', 'TickLength', [.02 .02], 'fontsize', 25, 'linewidth', 2, 'ytick', [0 300 600 900 1200], 'ylim', [0 1200], 'xlim', [.4 .9]);


%% scatter plot: peak distances and pattern correlations of pain and rejection data
% the relationship between peak distance and pattern correlation


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