function datastruct = fitF0smoother (datastruct, widthfactor)
if nargin<2
    %Timescale over which to look for a local minimum
    widthfactor = 20;
end
for j = 1:numel(datastruct)
    %extize
    numframes = size(datastruct(j).rawF, 2);
    numcells = size(datastruct(j).rawF,1);
    uncertainty = 99999999*ones(numcells,1); 
    bg = zeros(size(datastruct(j).rawF));
    noise = estimatenoise(datastruct(j).rawF, 2);
    
    %initial smoothing, optional
    for n = 1: numcells
        bg(n,:) = smooth(datastruct(j).rawF(n,:), 0.012, 'rloess');
    end
    
    drift = 0.001*mean(bg, 2)./noise;
    obs = zeros(numcells, numframes);
    R = zeros(numcells, numframes);
    AC = zeros(numcells, numframes);
    Q = zeros(numcells, numframes);
    
    for i = 1:numframes
        data = bg(:, max(i-widthfactor,3):min(i+widthfactor,numframes-2));
        obs(:,i) = min(data,[],2);
        R(:,i) = max((var(data, 0, 2)./noise), eps);
        AC(:,i) = 1;
        Q(:,i) = drift;
    end
    
    prior = min(bg(:,3:widthfactor), [], 2);
    bg2 = fliplr(bg);
    prior2 = min(bg2(:,3:widthfactor), [], 2);
    
    for cellnum = 1:numcells
        %because all our methods are symmetrical in time, smooth going both forwards and backwards and take the minimum
        x_smooth = kalman_smoother(obs(cellnum,:), shiftdim(AC(cellnum,:), -1), shiftdim(AC(cellnum,:), -1), shiftdim(Q(cellnum,:),-1), shiftdim(R(cellnum,:),-1), prior(cellnum), uncertainty(cellnum), 'model', 1:numframes, 'upper', obs(cellnum,:));
        x_smooth2 = kalman_smoother(fliplr(obs(cellnum,:)), shiftdim(fliplr(AC(cellnum,:)), -1), shiftdim(fliplr(AC(cellnum,:)), -1), shiftdim(fliplr(Q(cellnum,:)),-1), shiftdim(fliplr(R(cellnum,:)),-1), prior2(cellnum), uncertainty(cellnum), 'model', 1:numframes, 'upper', fliplr(obs(cellnum,:)));
        datastruct(j).F0(cellnum, :) = smooth(min(x_smooth,fliplr(x_smooth2)), 0.1, 'lowess');
    end
    datastruct(j).Fnorm = (datastruct(j).rawF - datastruct(j).F0) ./ datastruct(j).F0;
end
