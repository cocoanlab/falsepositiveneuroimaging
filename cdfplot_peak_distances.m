%load final_data
basedir = '/Users/hong/project/replication';
% basedir = '/Users/clinpsywoo/Nas/replication';
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'original_replication_peaks_data.mat'));

%calculate distance between peak coordinates
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

%% cdfplot
close all;
figure;
y1=cdfplot(distance_exact(~isnan(distance_exact))); %blue
hold on
y2=cdfplot(distance_roi(~isnan(distance_roi))); %red
hold on
y3=cdfplot(distance_noexact(~isnan(distance_noexact))); %yellow
% legend('distance exact','distance roi','distance noexact')
% distance exact: Coordinate-based ROI
% distance roi: predefined anatomical ROI 
% distance noexact: Qualitative region-level



%% edit the cdfplot
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


% proportion of peak distances that less than amygdala's size
1-sum(distance_exact(~isnan(distance_exact))>16.3)./numel(distance_exact(~isnan(distance_exact)))
1-sum(distance_roi(~isnan(distance_roi))>16.3)./numel(distance_roi(~isnan(distance_roi)))
1-sum(distance_noexact(~isnan(distance_noexact))>16.3)./numel(distance_noexact(~isnan(distance_noexact)))
 

%     0.7647
%     0.5868
%     0.5172

% proportion of peak distances that larger than amygdala's size
%Coordinate-based ROI: 0.2353 
%predefined anatomical ROI: 0.4132 
%Qualitative region-level: 0.4828 
