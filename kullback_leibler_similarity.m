%% Peak distances

%load data
load('original_replication_peaks_data.mat');

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
distance_all(1:numel(distance_noexact),1) = distance_noexact;
distance_all(1:numel(distance_roi),2) = distance_roi;
distance_all(1:numel(distance_exact),3) = distance_exact;


%% Kullback-Leibler similarity

for i = 4:10
    x = 0:i:110;
    c = histc(distance_all, x);
    
    KL12 = kldiv(x',c(:,1)./sum(c(:,1))+eps,c(:,2)./sum(c(:,2))+eps, 'sym');
    KL23 = kldiv(x',c(:,2)./sum(c(:,2))+eps,c(:,3)./sum(c(:,3))+eps, 'sym');
    KL13 = kldiv(x',c(:,1)./sum(c(:,1))+eps,c(:,3)./sum(c(:,3))+eps, 'sym');
    
    kl(i-3,:) = [KL12 KL23 KL13];
end
% plot(c./sum(c))
%% Visualize the Kullback-Leibler similarity

cols = [0.3569    0.6078    0.8353
    0.6627    0.8196    0.5569
    1.0000    0.7529         0];

h = plot(kl);

for i = 1:3
    h(i).Color = cols(i,:);
    h(i).LineWidth = 1.8;
    h(i).Marker = '.';
    h(i).MarkerSize = 20;
end

set(gcf, 'color', 'w');
box off;
set(gca, 'tickdir', 'out', 'xtick', 1:9, 'ytick', 0:2:20, ...
    'xticklabel', 4:10, 'xlim', [.5 7.5], ...
    'ylim', [0 11], 'fontsize', 16, 'linewidth', 1.2)

line([0 10], [1 1], 'linestyle', '--', 'linewidth', 1.2, 'color', [.4 .4 .4]);
