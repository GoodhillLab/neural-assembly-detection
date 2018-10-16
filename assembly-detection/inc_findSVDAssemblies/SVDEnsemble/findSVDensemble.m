% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'findSVDensemble'

function [core_svd,state_pks_full,param] = findSVDensemble(data,coords,param)
% Find ensembles using SVD method.
% INPUT:
%     data: N-by-T binary spike matrix, where N is the number of neurons,
%         T is number of frames
%     coords: N-by-2 matrix, containing coordinates of corresponding
%         neurons (for visualization purpose only)
%     param: struct with the following fields:
%         - pks: significant level of spike count per frame, default 4,
%                leave it empty [] if you want an automated threshold
%         - ticut: percentage of cells in a state; default 0.22, leave it
%                empty [] if you want an automated threshold
%         - jcut: another threshold for coactivity: further removes noise;
%                default 0.06
%         - state_cut: maximum number of states allowed, leave it empty if
%                you want automated value
% OUTPUT:
%     core_svd: K-by-1 cell array, where K is the number of identified
%         ensembles, with the indices of core neurons in each ensemble
%     state_pks_full: 1-by-T vector with the active ensemble identity for
%         each frame
%     param: updated parameter structure with the actual values this code
%         used
% 
% For details about this method, see the following paper:
% Carrillo-Reid, et al. "Endogenous sequential cortical activity evoked by
% visual stimuli." Journal of Neuroscience 35.23 (2015): 8813-8828.
% 
% This code is based on Luis Carrillo-Reid's Stoixeon package, but is made
% more efficient and easier to understand.
% Shuting Han, 2018
% 

%% set parameters
if ~isfield(param,'pks'); param.pks = 4; end
if ~isfield(param,'ticut'); param.ticut = 0.22; end
if ~isfield(param,'jcut'); param.jcut = 0.06; end
if ~isfield(param,'state_cut'); param.state_cut = round(size(data,1)/4); end

pks = param.pks;
ticut = param.ticut;
jcut = param.jcut;
state_cut = param.state_cut;
if isempty(state_cut); state_cut = round(size(data,1)/4); end

%% find similarity structure
% find high-activity frames
[data_active,pk_indx,pks] = findActiveFrames(data,pks);

% run tf-idf - make this into a function
data_tfidf = calcTFIDF(data_active);
data_tfidf( isnan( data_tfidf ) ) = 0; % # 

% calculate cosine similarity of tf-idf matrix
S_ti = 1-pdist2(data_tfidf',data_tfidf','cosine');

% threshold of noise
if isempty(ticut)
    ticut = calc_scut(data_tfidf);
end
S_tib = double(S_ti>ticut);

% jaccard similarity, define structures better
if isempty(jcut)
    jcut = calc_jcut(S_tib);
end
js = 1-pdist2(S_tib,S_tib,'jaccard');


%% do SVD, find states and cells
% Find the peaks in the states and the cells in the states
[state_raster,state_pks,fac_cut] = SVDStateBinary(double(js>jcut),state_cut);
num_state = size(state_raster,2);

% get state from full dataset
state_pks_full = zeros(1,size(data,2));
state_pks_full(pk_indx) = state_pks;

% plot
% # figure; set(gcf,'color','w')
% # imagesc(state_raster'==0); colormap(gray);

%% find sequences
% find most significant cells for each state
ti_vec = 0.01:0.01:0.1; % cross-validate this threshold
core_svd = cell(num_state,1);
pool_svd = cell(num_state,1);
state_member_raster = zeros(size(data,1),num_state);
% # figure; clf; set(gcf,'color','w')
N = ceil(sqrt(num_state));
M = ceil(num_state/N);
cc = jet(length(ti_vec));
cc = max(cc-0.3,0);
for ii = 1:num_state
    
    % pull out all activities in a state
    state_ti_hist = sum(data_tfidf(:,state_pks==ii),2)';
    state_ti_hist = state_ti_hist/max(state_ti_hist);
    
    % cross-validate ti_cut with cosine similarity - the core needs to
    % predict its corresponding state
    % # subplot(M,N,ii); hold on
    auc = zeros(size(ti_vec));
    for n = 1:length(ti_vec)
        core_vec = zeros(size(data_active,1),1);
        core_vec(state_ti_hist>ti_vec(n)) = 1;
        sim_core = 1-pdist2(data_active',core_vec','cosine')';
        [xx,yy,~,auc(n)] = perfcurve(double(state_pks==ii),sim_core,1);
        % # plot(xx,yy,'color',cc(n,:),'linewidth',1);
    end
    % # plot([0 1],[0 1],'k--')
    % # xlim([0 1]); ylim([0 1])
    % # xlabel('FPR'); ylabel('TPR'); title(['state ' num2str(ii)])
    [~,best_indx] = max(auc);
    ti_cut = ti_vec(best_indx);
    state_member_raster(:,ii) = state_ti_hist>ti_cut;
    core_svd{ii} = find(state_member_raster(:,ii));
    pool_svd{ii} = find(state_ti_hist>0);
    
end

%% plot core neurons
% plot ensemble component cells
% # cc_lr = [1 0.8 0.8]; % light red
% # cc_r = [1 0.2 0.2]; % red
% # mksz = 30;
% # figure; clf; set(gcf,'color','w')
% # for ii = 1:num_state
% #     subplot(M,N,ii); hold on
% #     scatter(coords(:,1),-coords(:,2),mksz,'k');
% #     scatter(coords(pool_svd{ii},1),-coords(pool_svd{ii},2),mksz,cc_lr,'filled');
% #     scatter(coords(core_svd{ii},1),-coords(core_svd{ii},2),mksz,cc_r,'filled');
% #     title(['ensemble #' num2str(ii)]);
% #     axis off equal
% # end

%% update parameters for output
param.pks = pks;
param.ticut = ticut;
param.jcut = jcut;
param.state_cut = state_cut;

end