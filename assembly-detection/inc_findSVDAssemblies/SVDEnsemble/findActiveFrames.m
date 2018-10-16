function [data_high,pks_frame,pks] = findActiveFrames(data,pks)
% find high activity frame using a threshold determined from shuffled data
% INPUT:
%     data: N-by-T spike matrix
%     pks: significant level of frame activity; if left empty ([]), this
%         function will determine its value using shuffled data
% OUTPUT:
%     data_high: N-by-T' data matrix with only significant frames
%     pks_frame: 1-by-T' vector containing indices of significant frames
%     pks: value of the final threshold
% 
% Shuting Han, 2017
% LCR Changed to S_index distributions to determine pks. The idea is that
% after some pk value the similarity between vectors in real data will be
% significantly higher than the similarity between vectors in random data

% some parameters
num_shuff = 100;
p = 0.98; %LCR
dims = size(data);
S_out = zeros(num_shuff);

% determine threshold from shuffled data
if isempty(pks)    
    
    % make shuffled data
    data_shuff = zeros(dims(1),dims(2),num_shuff);
    for ii = 1:num_shuff
        data_shuff(:,:,ii) = shuffle(data,'time');
    end
    
    for n = 3:max(sum(data,1))
        
        % find significant frames data
        data_high = data(:,sum(data,1)>=n);
        S = 1-pdist2(data_high',data_high','cosine');

        % calculate similarity matrix shuffled
        warning('off')
        for ii = 1:num_shuff
            data_high_rnd = data_shuff(:,sum(data_shuff(:,:,ii))>=n);
            S_rd = 1-pdist2(data_high_rnd',data_high_rnd','cosine');
            S_out(ii) = nanmean(S_rd(:));
        end
        warning('on')

        % determine threshold
        bins = 0:0.02:max(S_out);
        cd = histc(S_out,bins);
        cd = cumsum(cd/sum(cd));
        scut = bins(find(cd>p,1));
        if  mean(S(:))>scut         
            pks = n;
            break;
        end
    end
    
end

pks_frame = find(sum(data,1)>=pks);
data_high = data(:,pks_frame);

end
