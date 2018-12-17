%% issues in region-level inference

%% load data (woo et al, 2014)
basedir = '/Users/hong/project/replication/';
% basedir = '/Users/clinpsywoo/Nas/replication';
datdir = fullfile(basedir, 'data');
load(fullfile(datdir, 'data_obj_for_lassopcr_n59.mat'), 'data');

%% sort out the images for each subject

subj_idx = repmat(1:59, 8,1);
subj_idx = subj_idx(:);

f = fields(data);

% create dat_hot, _warm, _rejector, _friend

for i = 1:numel(f)
    eval([f{i} '= data.' f{i} ';']);
    eval([f{i} '.dat = [];']);
    eval([f{i} '.Y = [];']);
    eval([f{i} '.image_names = [];']);
end

for i = 1:numel(f)
    for j = 1:59
        eval([f{i} '.dat(:,j) = mean(data.' f{i} '.dat(:,subj_idx==j),2);']);
    end
end

%% ROI

mask = fullfile(datdir,'glm_hwrf_dACC_smooth05_onlydACC.nii');
dat = fmri_data(mask);
dat = preprocess(dat, 'smooth', 1);
orthviews(dat);
dat.fullpath = fullfile(datdir, 'glm_hwrf_dACC_smooth05_onlydACC_addsmooth1.nii');
% write(dat);

%% apply dACC mask on brain image 

mask = fullfile(datdir,'glm_hwrf_dACC_smooth05_onlydACC_addsmooth1.nii');
dat_hot_dacc = apply_mask(dat_hot, mask);
dat_warm_dacc = apply_mask(dat_warm, mask);
dat_rejector_dacc = apply_mask(dat_rejector, mask);
dat_friend_dacc = apply_mask(dat_friend, mask);


%savename = fullfile(datdir, 'data_onlydacc_addsmooth1');
%save(savename, 'dat_*dacc');

%% from here: first 30 subjects

basedir = '/Users/hong/project/replication';
datdir = fullfile(basedir, 'data');
savename = fullfile(datdir, 'data_onlydacc_addsmooth1');
load(savename);

% hot-warmth

dat_hot_warm = dat_hot_dacc; %create a same format file
dat_hot_warm.dat = dat_hot_dacc.dat(:,1:30) - dat_warm_dacc.dat(:,1:30);
dat_hot_warm.fullpath = fullfile(datdir, 'hot_warm_first30.nii');
% write(dat_hot_warm);

m_dat_hot_warm_n30 = mean(dat_hot_warm);
m_dat_hot_warm_n30.fullpath = fullfile(datdir, 'hot_warm_first30_mean.nii');
%write(m_dat_hot_warm_n30);

t_dat_hot_warm_n30 = ttest(dat_hot_warm, .05, 'fdr');
t_dat_hot_warm_n30.fullpath = fullfile(datdir, 'hot_warm_first30_fdr05.nii');
%write(t_dat_hot_warm_n30, 'thresh');



% SVC analysis
% X = ones(30,1);
% niter =1000;
% maskname = fullfile(datdir, 'hot_warm_first30_mean.nii');
% image_names = fullfile(datdir, 'hot_warm_first30.nii');
% x_names = {'intercept'};
% 
% Results_hot_first30 = robust_reg_nonparam(X,niter,'mask',maskname,'data',image_names,'names',x_names);


%% last 29 subjects

dat_hot_warm = dat_hot_dacc; %create a same format file
dat_hot_warm.dat = dat_hot_dacc.dat(:,31:end) - dat_warm_dacc.dat(:,31:end);
dat_hot_warm.fullpath = fullfile(datdir, 'hot_warm_last29.nii');
% write(dat_hot_warm);

m_dat_hot_warm_n29 = mean(dat_hot_warm); 
m_dat_hot_warm_n29.fullpath = fullfile(datdir, 'hot_warm_last29_mean.nii');
%write(m_dat_hot_warm_n29);

t_dat_hot_warm_n29 = ttest(dat_hot_warm, .05, 'fdr');
t_dat_hot_warm_n29.fullpath = fullfile(datdir, 'hot_warm_last29_fdr05.nii');
%write(t_dat_hot_warm_n29, 'thresh');

% SVC analysis
% X = ones(29,1);
% niter =1000;
% maskname = fullfile(datdir, 'hot_warm_first30_mean.nii');
% image_names = fullfile(datdir, 'hot_warm_last29.nii');
% x_names = {'intercept'};
% 
% Results_hot_last29 = robust_reg_nonparam(X,niter,'mask',maskname,'data',image_names,'names',x_names);


%% rejector-friend: first 30 subjects

savename = fullfile(datdir, 'data_onlydacc_addsmooth1');
load(savename);

% hot-warmth

dat_rej_friend = dat_hot_dacc; %create a same format file
dat_rej_friend.dat = dat_rejector_dacc.dat(:,1:30) - dat_friend_dacc.dat(:,1:30);
dat_rej_friend.fullpath = fullfile(datdir, 'rej_friend_first30.nii');
% write(dat_rej_friend);

data = dat_rej_friend.dat;
niter = 10000;
null = [];
signv = sign(randn(size(data,2),niter));
for i = 1:niter
    xtmp = data .* repmat(signv(:,i),1,size(data,1))';
    null(:,i) = mean(xtmp,2);
end
mdat = mean(data,2);
pval = sum(mdat<=null,2)./niter;

m_dat_rej_friend_n30 = mean(dat_rej_friend);
m_dat_rej_friend_n30.fullpath = fullfile(datdir, 'rej_friend_first30_mean.nii');
%write(m_dat_rej_friend_n30);

t_dat_rej_friend_n30 = ttest(dat_rej_friend, .05, 'unc');
t_dat_rej_friend_n30.fullpath = fullfile(datdir, 'rej_friend_first30_unc05.nii');
%write(t_dat_rej_friend_n30, 'thresh');

% SVC analysis
% X = ones(30,1);
% niter =1000;
% maskname = fullfile(datdir, 'hot_warm_first30_mean.nii');
% image_names = fullfile(datdir, 'rej_friend_first30.nii');
% x_names = {'intercept'};
% 
% Results_rej_first30 = robust_reg_nonparam(X,niter,'mask',maskname,'data',image_names,'names',x_names);


%% last 29 subjects

dat_rej_friend = dat_hot_dacc; %create a same format file
dat_rej_friend.dat = dat_rejector_dacc.dat(:,31:end) - dat_friend_dacc.dat(:,31:end);
dat_rej_friend.fullpath = fullfile(datdir, 'rej_friend_last29.nii');
% write(dat_rej_friend);

m_dat_rej_friend_n29 = mean(dat_rej_friend);
m_dat_rej_friend_n29.fullpath = fullfile(datdir, 'rej_friend_last29_mean.nii');
%write(m_dat_rej_friend_n29);

t_dat_rej_friend_n29 = ttest(dat_rej_friend, .05, 'unc');
t_dat_rej_friend_n29.fullpath = fullfile(datdir, 'rej_friend_last29_unc05.nii');
%write(t_dat_rej_friend_n29, 'thresh');



% SVC analysis
% X = ones(29,1);
% niter =1000;
% maskname = fullfile(datdir, 'hot_warm_first30_mean.nii');
% image_names = fullfile(datdir, 'rej_friend_last29.nii');
% x_names = {'intercept'};
% 
% Results_rej_last29 = robust_reg_nonparam(X,niter,'mask',maskname,'data',image_names,'names',x_names);


%% pain vs. rejector

% first 30
% mask1{1} = fullfile(datdir,'hot_warm_first30_mean.nii');
% mask1{2} = fullfile(datdir, 'rej_friend_first30_mean.nii');

mask1{1} = m_dat_hot_warm_n30;
mask1{2} = m_dat_rej_friend_n30;
for i = 1:2, cl{i} = region(mask1{i}); end
info = roi_contour_map([cl{1} cl{2}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 2);


%last 29
% mask2{1} = fullfile(datdir, 'hot_warm_last29_mean.nii');
% mask2{2} = fullfile(datdir, 'rej_friend_last29_mean.nii');
mask2{1} = m_dat_hot_warm_n29;
mask2{2} = m_dat_rej_friend_n29;

for i = 1:2, cl{i} = region(mask2{i}); end
info = roi_contour_map([cl{1} cl{2}], 'cluster', 'use_same_range', 'colorbar', 'xyz', 2);

%% brain orthviews

%Original data: Rejection vs. friend (n = 30)
orthviews(m_dat_rej_friend_n30); % x= -2, z= 31

%Replication data: Rejection vs. friend (n = 29)
orthviews(m_dat_rej_friend_n29); % x= -2, z= 31

%Original data: Pain vs. warmth (n = 30)
orthviews(m_dat_hot_warm_n30); % x= -2, z= 31

%Replication data: Pain vs. warmth (n = 29)
 orthviews(m_dat_hot_warm_n29); % x= -2, z= 31



