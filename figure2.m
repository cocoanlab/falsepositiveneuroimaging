%% Figure 2A: pie chart

basedir = pwd; % start from the directory where you downloaded this repository
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'original_replication_peaks_data.mat'));

study_category.dat(ismember(study_category.study_num, [271 378 387])) = [];
study_category.study_num(ismember(study_category.study_num, [271 378 387])) = [];

orderidx = [1 2 4 3 5 6 7];
for i = 1:numel(orderidx)
    p(i) = sum(study_category.dat == orderidx(i))/numel(study_category.dat)*100; 
end
 
colors = [0.6471    0.6471    0.6471
    [0.3569    0.6078    0.8353]-.1
    [0.6627    0.8196    0.5569]-.1
    0.3569    0.6078    0.8353
    0.6627    0.8196    0.5569
    1.0000    0.7529         0
    0.9294    0.4902    0.1922];

wani_pie(p, 'notext', 'hole', 'cols', colors);

set(gcf, 'Position', [1   917   545   428]);


%% Figure 2B: Box violin plots

jj = 0;
no_exact_model = study_category.study_num(study_category.dat==3);
for i = 1:numel(no_exact_model)
    coord_num = find(final_data.dat(:,1) == no_exact_model(i));
    for j = 1:numel(coord_num)
        jj = jj + 1;
        distance_noexact(jj,1) = sqrt((final_data.dat(coord_num(j),4)-final_data.dat(coord_num(j),7)).^2+(final_data.dat(coord_num(j),5)-final_data.dat(coord_num(j),8)).^2+(final_data.dat(coord_num(j),6)-final_data.dat(coord_num(j),9)).^2);
        coord_num_noexact(jj,1) = coord_num(j);
    end
end

jj = 0;
roi_model = study_category.study_num(study_category.dat==5);
for i = 1:numel(roi_model)
    coord_num = find(final_data.dat(:,1) == roi_model(i));
    for j = 1:numel(coord_num)
        jj = jj + 1;
        distance_roi(jj,1) = sqrt((final_data.dat(coord_num(j),4)-final_data.dat(coord_num(j),7)).^2+(final_data.dat(coord_num(j),5)-final_data.dat(coord_num(j),8)).^2+(final_data.dat(coord_num(j),6)-final_data.dat(coord_num(j),9)).^2);
        coord_num_roi(jj,1) = coord_num(j);
    end
end

jj = 0;
exact_model = study_category.study_num(study_category.dat==6);
for i = 1:numel(exact_model)
    coord_num = find(final_data.dat(:,1) == exact_model(i));
    for j = 1:numel(coord_num)
        jj = jj + 1;
        distance_exact(jj,1) = sqrt((final_data.dat(coord_num(j),4)-final_data.dat(coord_num(j),7)).^2+(final_data.dat(coord_num(j),5)-final_data.dat(coord_num(j),8)).^2+(final_data.dat(coord_num(j),6)-final_data.dat(coord_num(j),9)).^2);
        coord_num_exact(jj,1) = coord_num(j);
    end
end

% box-violin plot

colors = [0.6471    0.6471    0.6471
    [0.3569    0.6078    0.8353]-.1
    [0.6627    0.8196    0.5569]-.1
    0.3569    0.6078    0.8353
    0.6627    0.8196    0.5569
    1.0000    0.7529         0
    0.9294    0.4902    0.1922];

boxplot_wani_2016(distance_all, 'color', colors([2 5 6],:), 'violin', 'dots', 'dot_alpha', .4, 'data_dotcolor', [.5 .5 .5], 'bw', 10);
set(gca, 'linewidth', 1.2, 'fontsize', 18, 'YTick', -20:20:150);
set(gcf, 'position', [1        1033         354         312]);
hold on;

%% Figure 2C: Cumulative Distribution Function plot

close all;
y1 = cdfplot(distance_exact(~isnan(distance_exact))); hold on;
y2 = cdfplot(distance_roi(~isnan(distance_roi))); hold on;
y3 = cdfplot(distance_noexact(~isnan(distance_noexact))); 

colors = [0.6471    0.6471    0.6471
    [0.3569    0.6078    0.8353]-.1
    0.3569    0.6078    0.8353
    [0.6627    0.8196    0.5569]-.1
    0.6627    0.8196    0.5569
    1.0000    0.7529         0
    0.9294    0.4902    0.1922];

figure; 
plot(y1.XData, y1.YData, 'color', colors(6,:), 'linewidth', 3.5) %yellow: Coordinate-based ROI
hold on;
plot(y2.XData, y2.YData, 'color', colors(5,:), 'linewidth', 3.5) %green: predefined anatomical ROI 
hold on;
plot(y3.XData, y3.YData, 'color', colors(3,:), 'linewidth', 3.5) %blue: Qualitative region-level

line([16.3 16.3], [0 1], 'linewidth', 2, 'linestyle', '--', 'color', [.5 .5 .5]);

set(gcf, 'color', 'w', 'position', [1   943   504   402]);
set(gca, 'linewidth', 2, 'box', 'off', 'tickdir', 'out', 'ticklength', [.015 .015], 'fontsize', 25, 'xlim', [-.5 115], 'xtick', 0:20:100);

