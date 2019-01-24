%% Simulation with pattern

% each iteration, record distance and correlation

snr_all = [.1 .3 .5 .7 .9 1.1];

pattern = [0.4 1.7 0.5 0.7 0.2
           0.3 0.3 1.1 1.4 0.7
           0.4 0.8 1.8 1.3 0.1
           1.2 2.0 0.3 1.0 0.3 
           0.8 0.5 1.3 0.6 1.6];
       
dat = zeros(100,100);
sig = ones(20,20);
       
for i = 1:5
    for j = 1:5
        dat((i-1)*20+1:i*20, (j-1)*20+1:j*20) = sig.*pattern(i,j);
    end
end

for snr_i = 1:numel(snr_all)
    
    for iter = 1:10000
        
        snr = snr_all(snr_i);

        
        noise = normrnd(0,max(max(pattern))/snr,100,100);
        
        dat_noise = dat + noise;
        
        sdat = imgaussfilt(dat_noise,2); % smooth dat_noise 
        
        idx1 = [];
        [~, idx1(1,1)] = max(max(sdat(3:98, 3:98)));
        [~, idx_temp] = max(sdat(3:98, 3:98));
        idx1(2,1) = idx_temp(idx1);
      
        
        noise = normrnd(0,max(max(pattern))/snr,100,100);
        
        dat_noise = dat + noise;
        
        sdat2 = imgaussfilt(dat_noise,2);
        
        idx2 = [];
        [~, idx2(1,1)] = max(max(sdat2(3:98, 3:98)));
        [~, idx_temp] = max(sdat2(3:98, 3:98));
        idx2(2,1) = idx_temp(idx2);
        
        measure{snr_i}.dist(iter,1) = sqrt(sum((idx1-idx2).^2));
        measure{snr_i}.corr(iter,1) = corr(sdat(:), sdat2(:));
        
    end
end
    

%% visualize

load colormap_colorbrewer_wani.mat;

snr_all = [.1 .3 .5 .7 .9 1.1];

pattern = [0.4 1.5 0.5 0.7 0.2
           0.3 0.3 1.1 1.4 0.7
           0.4 0.8 1.5 1.3 0.1
           1.2 2.0 0.3 1.0 0.3 
           0.8 0.5 1.3 0.6 1.6];
       
dat = zeros(100,100);
sig = ones(20,20);
       
for i = 1:5
    for j = 1:5
        dat((i-1)*20+1:i*20, (j-1)*20+1:j*20) = sig.*pattern(i,j);
    end
end

close all;

subplot(2,7,1);
imagesc(dat);
colormap(col11_from_colorbrewer);
axis off;

subplot(2,7,8);
noise = normrnd(0,1,100,100);
snoise = imgaussfilt(noise,2);
imagesc(noise);
colormap(col11_from_colorbrewer);
axis off;

k = 1;
for snr_i = 1:numel(snr_all)
    
    snr = snr_all(snr_i);
    
    noise = normrnd(0,max(max(pattern))/snr,100,100);
    
    dat_noise = dat + noise;
    
    sdat = imgaussfilt(dat_noise,2);
    
    idx1 = [];
    [~, idx1(1,1)] = max(max(sdat(3:98, 3:98)));
    [~, idx_temp] = max(sdat(3:98, 3:98));
    idx1(2,1) = idx_temp(idx1);
    
    k = k + 1;
    subplot(2,7,k);
    imagesc(sdat, [-3*std(sdat(:)) 5*std(sdat(:))]);
    colormap(col11_from_colorbrewer)

    hold on;
    scatter(idx1(1)+2, idx1(2)+2, 200, 'p', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w')

    axis off;
    
    noise = normrnd(0,max(max(pattern))/snr,100,100);
    
    dat_noise = dat + noise;
    
    sdat2 = imgaussfilt(dat_noise,2);
    
    idx2 = [];
    [~, idx2(1,1)] = max(max(sdat2(3:98, 3:98)));
    [~, idx_temp] = max(sdat2(3:98, 3:98));
    idx2(2,1) = idx_temp(idx2);
    
    subplot(2,7,k+7);
    imagesc(sdat2, [-3*std(sdat2(:)) 5*std(sdat2(:))]);
    colormap(col11_from_colorbrewer);

    hold on;
    scatter(idx2(1)+2, idx2(2)+2, 200, 'p', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w')

    axis off;
end

set(gcf, 'color', 'w', 'position', [ 1        1129         903         216]);





%% Boxplot- pattern corrlation

% Distributions of pattern correlation across different levels of SNR.
%snr_all = [.1 .3 .5 .7 .9 1.1]


for i = 1:numel(measure)
    r(:,i) = measure{i}.corr;
end

boxplot_wani_2016(r, 'boxlinewidth', 1);
set(gcf, 'Position', [ 122   705   431   293]);
set(gca, 'fontsize', 20)

%% Boxplot- peak distances

% Distributions of peak distance across different levels of SNR.
%snr_all = [.1 .3 .5 .7 .9 1.1]


for i = 1:numel(measure)

    dist(:,i) = measure{i}.dist;
end

boxplot_wani_2016(dist, 'boxlinewidth', 1);
set(gcf, 'Position', [ 122   705   431   293]);
set(gca, 'fontsize', 20, 'ytick', 0:30:200)


%% cohen's d

d = diff(mean(dist));

for i = 1:5
    a = dist(:,i:i+1);
    std_pooled(i) = std(a(:));
end

mean(d./std_pooled)


r_diff = diff(mean(r));

for i = 1:5
    a = r(:,i:i+1);
    std_pooled_r(i) = std(a(:));
end

mean(r_diff./std_pooled_r)

