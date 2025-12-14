dispLevels = 16;
p1 = 5;
p2 = 10;

% Read the stereo images as grayscale
leftImg = rgb2gray(imread('left.png'));
rightImg = rgb2gray(imread('right.png'));

% Apply a Gaussian filter
leftImg = imgaussfilt(leftImg,0.68,'FilterSize',5);
rightImg = imgaussfilt(rightImg,0.68,'FilterSize',5);

% Get image size
[rows,cols] = size(leftImg);

% Compute data cost (matching cost)
dataCost = zeros(rows,cols,dispLevels);
leftImg = double(leftImg);
rightImg = double(rightImg);
for d = 0:dispLevels-1
    rightImgShifted = [zeros(rows,d),rightImg(:,1:end-d)];
    dataCost(:,:,d+1) = abs(leftImg-rightImgShifted);
end

% Compute smoothness cost
d = 0:dispLevels-1;
diff = abs(d-d');
smoothnessCost = (diff==1)*p1+(diff>=2)*p2;

% Initialize tables with costs for the 8 directions
L1 = zeros(rows,cols,dispLevels);
L2 = zeros(rows,cols,dispLevels);
L3 = zeros(rows,cols,dispLevels);
L4 = zeros(rows,cols,dispLevels);

% Forward pass
for y = 2:rows
    for x = 2:cols
        % left to right direction
        cost = squeeze(dataCost(y,x-1,:)+L1(y,x-1,:));
        cost = min(cost+smoothnessCost);
        L1(y,x,:) = cost-min(cost);

        % up to down direction
        cost = squeeze(dataCost(y-1,x,:)+L2(y-1,x,:));
        cost = min(cost+smoothnessCost);
        L2(y,x,:) = cost-min(cost);
    end
end

% Backward pass
for y = rows-1:-1:1
    for x = cols-1:-1:1
        % right to left direction
        cost = squeeze(dataCost(y,x+1,:)+L3(y,x+1,:));
        cost = min(cost+smoothnessCost);
        L3(y,x,:) = cost-min(cost);

        % down to up direction
        cost = squeeze(dataCost(y+1,x,:)+L4(y+1,x,:));
        cost = min(cost+smoothnessCost);
        L4(y,x,:) = cost-min(cost);
    end
end

% Compute total cost (aggregated cost)
S = L1 + L2 + L3 + L4;

% Update disparity map
[~,ind] = min(S,[],3);
disparityMap = ind-1;

% Update disparity image
scaleFactor = 256/dispLevels;
disparityImg = uint8(disparityMap*scaleFactor);

% Show disparity image
figure
imshow(disparityImg)

% Save disparity image
imwrite(disparityImg,'disparity.png')
