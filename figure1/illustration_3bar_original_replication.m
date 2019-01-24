%% Pain vs. Rejector 3 bar illustration 

%load data 
% basedir = '/Users/clinpsywoo/Nas/replication';
basedir = '/Users/hong/project/replication';
datdir = fullfile(basedir, 'data');

mask1{1} = fullfile(datdir, 'hot_warm_first30_mean.nii'); %only hot first N=30
mask1{2} = fullfile(datdir, 'rej_friend_first30_mean.nii'); %only rejection N=30
mask1{3} = fullfile(datdir, 'hot_warm_last29_mean.nii'); % only hot last N=29
mask1{4} = fullfile(datdir, 'rej_friend_last29_mean.nii'); %only rejection N=29

for i = 1:numel(mask1)
    cl{i} = region(mask1{i}); 
end

%% bar 3d
% example: https://github.com/wanirepo/wagerlabtools_supplement/blob/master/examples/wani_example_pattern_bar3d.m

% % Original data: Pain vs. warmth (n = 30)
info = roi_contour_map([cl{1}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 1, 'coord', -2);

% % Original data: Rejection vs. friend (n = 30)
%  info = roi_contour_map([cl{2}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 1, 'coord', -2);

% % Replication data: Pain vs. warmth (n = 29)
% info = roi_contour_map([cl{3}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 1, 'coord', -2);

% % Replication data: Rejection vs. friend (n = 29)
% info = roi_contour_map([ cl{4}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 1, 'coord', -2);

Z = info{1}.vZ;

close all;
Z = Z-min(min(Z))+.005;
Z = fliplr(Z);
maxZ = max(max(Z));
b = bar3(Z,1);

for k = 1:length(b)
    zdata = get(b(k), 'zdata');
    set(b(k), 'CData', zdata);
    set(b(k), 'FaceColor', 'interp');
    set(b(k), 'LineWidth', 0.5, 'edgecolor', [.2 .2 .2]);
end
% set(gca, 'zlim', [.005 maxZ]);
col = [0 0 0
    0.0461    0.3833    0.5912
    0.2461    0.5833    0.7912
    0.4000    0.7608    0.6471
    0.6706    0.8667    0.6431
    0.9020    0.9608    0.5961
    1.0000    1.0000    0.7490
    0.9961    0.8784    0.5451
    0.9922    0.6824    0.3804
    0.9569    0.4275    0.2627
    0.8353    0.2431    0.3098
    0.6196    0.0039    0.2588];

colormap(col);
% view(10, 65);
view(8, 75);
axis off;

set(gcf, 'color', 'w', 'position', [289     5   847   701]);