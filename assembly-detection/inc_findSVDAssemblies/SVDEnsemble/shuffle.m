% # (JM) MODIFIED FROM ORIGINAL FUNCTION 'shuffle'

function shuffled = shuffle(x,method)

%shuffle Shuffles raster data using various different methods
% Shuffles spike data (0 or 1) using three differnt methods
% assumes rows are individual cells and columns are time frames
%
% 'frames' - shuffles the frames in time, maintains activity pattern of
% each frame
%
% 'time' - shuffles the activity of each individual cell in time
%           each cell maintains its total level of activity
%
% 'time_shift' - shifts the time trace of each cell by a random ammount
%           each cell maintains its pattern of activity
%
% Methods fom synfire chains paper
%
% 'isi' - Inter-Spike Interval shuffling within cells
%           each cell maintains in level of activity
%
% 'cell' - shuffles the activity at a given time between cells
%           each frame maintains the number of active cells
%
% 'exchange' - exchange pairs of spikes across cells
%           slow, but each cell and frame maintains level of activity
%
% jzaremba 01/2012

if nargin < 2
    method = 'frames';
end

if ~any(strcmp(method, {'frames','time','time_shift','isi','cell','exchange'}))
    method = 'frames';
end

shuffled=x;

switch method
    case 'frames'
        randp = randperm(length(x));
        shuffled = sortrows([randp;x]')';
        shuffled = shuffled(2:end,:);
        
    case 'time'
        n = size(x,2); % # n = length(x);
        for i = 1:size(x,1)
            randp = randperm(n);
            temp = sortrows([randp; x(i,:)]')';
            shuffled(i,:) = temp(2,:);
        end
        
    case 'time_shift'
        n = size(x,2); % # n = length(x);
        for i = 1:size(x,1)
            randp = randi(n);
            shuffled(i,:) = [  x(i,n-randp+1:n) x(i,1:n-randp) ]; 
        end
       
    case 'isi'
        n = length(x);
        shuffled = zeros(size(x,1),n);
        
        for i = 1:size(x,1)
            % Pull out indices of spikes, get ISIs, buffer at start and end
            isi = diff(find([1 x(i,:) 1]));
            isi = isi(randperm(length(isi))); % Randomize ISIs
            
            temp = cumsum(isi);
            temp = temp(1:end-1); % Removes the end spikes that were added
            % Put the spikes back
            shuffled(i,temp) = true;
        end
        
        
    case 'cell'
        [n,len] = size(x);
        for i = 1:len
            randp = randperm(n);
            temp = sortrows([randp' x(:,i)]);
            shuffled(:,i) = temp(:,2);
        end
        
    case 'exchange'
        n = sum(x(:));
        for i = 1:2*n
            randp = randi(n,1,2);
            [r,c] = find(shuffled);
            
            % Make sure that the swap will actually do something
            while randp(1)==randp(2) || r(randp(1))==r(randp(2)) || c(randp(1))==c(randp(2)) || shuffled(r(randp(2)),c(randp(1)))==true || shuffled(r(randp(1)),c(randp(2)))==true 
                randp = randi(n,1,2);
            end
            
            % Swap
            shuffled(r(randp(2)),c(randp(1))) = true;
            shuffled(r(randp(1)),c(randp(1))) = false;
            
            shuffled(r(randp(1)),c(randp(2))) = true;
            shuffled(r(randp(2)),c(randp(2))) = false;
            
        end
            
end
        
        