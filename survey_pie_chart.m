%% Figure 2A: pie chart

basedir = '/Users/hong/project/replication';
% basedir = '/Users/clinpsywoo/Nas/replication';
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'final_data_replication.mat'));

study_category.dat(ismember(study_category.study_num, [271 378 387])) = [];
study_category.study_num(ismember(study_category.study_num, [271 378 387])) = [];

orderidx = [1 2 4 3 5 6 7];
for i = 1:numel(orderidx)
    p(i) = sum(study_category.dat == orderidx(i))/numel(study_category.dat)*100; 
end

% No specific report
 %p(1) = sum(study_category.dat == 1)/numel(study_category.dat)*100; 

% Qualitative region-level
 %p(2) = sum(study_category.dat == 2 | study_category.dat == 3)/numel(study_category.dat)*100; 

% predefined anatomical ROI 
 %p(3) = sum(study_category.dat == 4 | study_category.dat == 5)/numel(study_category.dat)*100; 

% coordinate-based
 %p(4) = sum(study_category.dat == 6)/numel(study_category.dat)*100; 

% pattern-based
 %p(5) = sum(study_category.dat == 7)/numel(study_category.dat)*100; 

 
colors = [0.6471    0.6471    0.6471
    [0.3569    0.6078    0.8353]-.1
    [0.6627    0.8196    0.5569]-.1
    0.3569    0.6078    0.8353
    0.6627    0.8196    0.5569
    1.0000    0.7529         0
    0.9294    0.4902    0.1922];


wani_pie(p, 'notext', 'hole', 'cols', colors, 'hole_size', 3000);

set(gcf, 'Position', [1   917   545   428]);

figdir = fullfile(basedir, 'figures');

% savename = fullfile(figdir, 'study_category_pie_111317_v2.eps');
% saveas(gcf, savename);
% 
%  print(gcf,'-depsc','-painters',savename);
%  epsclean(savename);

