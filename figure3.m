%% Simulation

% In this simulation we examined how reliable peak distance and pattern correlation
% by comparing two simulated data with the same ground truth patterns of signal.

% define SNR levels

snr_all = [.1 .3 .5 .7 .9 1.1];

% create ground truth pattern

pattern = [0.4 1.7 0.5 0.7 0.2
           0.3 0.3 1.1 1.4 0.7
           0.4 0.8 1.8 1.3 0.1
           1.2 2.0 0.3 1.0 0.3 
           0.8 0.5 1.3 0.6 1.6];
       
% make 100 x 100 data matrix with the defined pattern 

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
        
        % Working on the first data
        
        % noise was created using random numbers drawn from a normal distribution with 
        % mu = 0 and sigma = max of pattern / snr (e.g., when max = 1.8 and snr = 0.5, sigma becomes 3.6)

        noise = normrnd(0,max(max(pattern))/snr,100,100);
        
        % add the created noise to the data
        
        dat_noise = dat + noise;
        
        % smoothing
        
        sdat = imgaussfilt(dat_noise,2);
        
        % record the peak location of data 1
        
        idx1 = [];
        [~, idx1(1,1)] = max(max(sdat(3:98, 3:98)));
        [~, idx_temp] = max(sdat(3:98, 3:98));
        idx1(2,1) = idx_temp(idx1);
        
        % Working on the second data
        
        noise = normrnd(0,max(max(pattern))/snr,100,100);
        
        dat_noise = dat + noise;
        
        sdat2 = imgaussfilt(dat_noise,2);
        
        % record the peak location of data 2
        
        idx2 = [];
        [~, idx2(1,1)] = max(max(sdat2(3:98, 3:98)));
        [~, idx_temp] = max(sdat2(3:98, 3:98));
        idx2(2,1) = idx_temp(idx2);
        
        % record euclidean peak distance for an iteration
        measure{snr_i}.dist(iter,1) = sqrt(sum((idx1-idx2).^2));
        % record pattern similarity for an iteration
        measure{snr_i}.corr(iter,1) = corr(sdat(:), sdat2(:));
        
    end
end
    

%% Boxplot: pattern correlation

% Distributions of pattern correlation across different levels of SNR.

for i = 1:numel(measure)
    r(:,i) = measure{i}.corr;
end

boxplot_wani_2016(r, 'boxlinewidth', 1);
set(gcf, 'Position', [ 122   705   431   293]);
set(gca, 'fontsize', 20)

%% Boxplot: peak distances

% Distributions of peak distance across different levels of SNR.

for i = 1:numel(measure)
    dist(:,i) = measure{i}.dist;
end

boxplot_wani_2016(dist, 'boxlinewidth', 1);
set(gcf, 'Position', [ 122   705   431   293]);
set(gca, 'fontsize', 20, 'ytick', 0:30:200)

