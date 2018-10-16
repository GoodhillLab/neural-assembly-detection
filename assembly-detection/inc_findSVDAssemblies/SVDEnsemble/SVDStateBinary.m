% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'SVDStateBinary'

function [state_raster,state_pks,fac_cut] = SVDStateBinary(S,state_cut)
% Find SVD states.
% Shuting Han, 2018

p = 0.025; %significant states need to appear at least 5% of the time to be considered LCR

% do SVD on binarized similarity matrix
sz = size(S,1);
[~,S_svd,V_svd] = svd(S);

% binary search factor cut
fac_cut = 0.4;
dlt = 1;
while dlt > 0
    
    % restore factors
    fac_count = zeros(state_cut,1);
    for n = 1:min(state_cut,size(V_svd,2)) % # for n = 1:state_cut
        fac_count(n) = sum(sum((V_svd(:,n)*V_svd(:,n)'*S_svd(n,n))>fac_cut));
    end
    
    state_count = floor(sqrt(fac_count));
    state_count = find(state_count/sum(state_count)>=p);
    num_state = length(state_count);
    
    % find cells for each state
    svd_sig = zeros(sz,sz,num_state);
    for n = 1:num_state
        svd_sig(:,:,n) = (V_svd(:,state_count(n))*V_svd(:,state_count(n))'...
            *S_svd(state_count(n),state_count(n)))>fac_cut;
    end
    
    state_pks_num = zeros(num_state,sz);
    for n = 1:num_state
        state_pks_num(n,sum(svd_sig(:,:,n))>0) = 1;
    end
    
    % if there's no overlapping state, stop searching
    if max(sum(state_pks_num))>1
        fac_cut = fac_cut+0.01;
        dlt = 1;
    else
        dlt = 0;
    end
    
end

state_raster = rot90(sortrows(state_pks_num)')';
state_pks_sort = state_raster.*repmat(1:num_state,sz,1);
state_pks = sum(state_pks_sort,2)';

% plot identified states
% figure(3);
% imagesc(edos_pks_num_sort_n==0);colormap(gray)
% xlabel('frame'); ylabel('ensemble index'); title('ensemble activity')



end
