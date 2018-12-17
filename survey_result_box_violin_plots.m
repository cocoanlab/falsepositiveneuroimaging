%% Peak distance between original data and replication data

% % run once
% final_data.dat(final_data.dat(:,2)==2,4:6) = tal2mni(final_data.dat(final_data.dat(:,2)==2,4:6));
% final_data.dat(final_data.dat(:,3)==2,7:9) = tal2mni(final_data.dat(final_data.dat(:,3)==2,7:9));
% 
% save(fullfile(datdir, 'final_data_replication.mat'), 'final_data', '-append');
% % =======

%load data
basedir = '/Users/hong/project/replication';
% basedir = '/Users/clinpsywoo/Nas/replication';
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'original_replication_peaks_data.mat'));

study_category.dat(ismember(study_category.study_num, [271 378 387])) = [];
study_category.study_num(ismember(study_category.study_num, [271 378 387])) = [];



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

 distance_all = NaN(150,3);
 
 distance_all(1:numel(distance_noexact),1) = distance_noexact; % Qualitative region-level
 distance_all(1:numel(distance_roi),2) = distance_roi;  % Exact ROI
 distance_all(1:numel(distance_exact),3) = distance_exact; % Coordinate-based ROI


% mean of each methods 
mean(distance_all,'omitnan') % Qualitative region-level, Exact ROI, Coordinate-based ROI      % noexact, roi, exact

std_qualitative_region_level = std(distance_noexact,1,'omitnan')
std_exact_roi = std(distance_exact,1,'omitnan')
std_coordiante_based_roi =  std(distance_roi,1,'omitnan')



%remove NaN

nonan_distance_noexact = rmmissing(distance_noexact) % #29
nonan_distance_roi= rmmissing(distance_roi) % #121

%% box-violin plot

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


% % mean of each methods 
 mean(distance_all,'omitnan')

% savename = fullfile(figdir, 'peak_distance_boxplot.pdf');
% pagesetup(gcf);
% saveas(gcf, savename);
% 
% pagesetup(gcf);
% saveas(gcf, savename);

%% Two sample ttest each group

[h,p,ci,stats]=ttest2(distance_exact,distance_noexact, 'Vartype', 'unequal') % Coordinate-based ROI and Qualitative region-level               %anatomic region-based(2) and exact prior model (6)
[h,p,ci,stats]=ttest2(distance_exact,distance_roi, 'Vartype', 'unequal')   % Coordinate-based ROI and Exact ROI        %exact prior model(6) and ROI comparision (5)
[h,p,ci,stats]=ttest2(distance_noexact,distance_roi, 'Vartype', 'unequal') %  Qualitative region-level and Coordinate-based ROI                %anatomic region-based(2) and ROI comparision (5)

% p: 0.5689
% tstat: 0.5740
% df: 43.7754

%% Two sample ttest combined ROI(5) and anatomic region-based(2) VS. exact prior model(6)

[h,p,ci,stats]=ttest2(distance_exact,[distance_noexact; distance_roi], 'Vartype', 'unequal')

% p: 0.0056
% tstat: -2.8698
% df: 62.7197


