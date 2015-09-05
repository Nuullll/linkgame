%% load image and preprocess
% original = imread('graygroundtruth.jpg');
original = imread('graycapture.jpg');
image = im2bw(original,0.8);
image = double(image);


%% get block size and position of game region
hor = mean(image,1);
ver = mean(image,2);

[~,I] = findpeaks(-hor,'MinPeakProminence',0.3,'MaxPeakWidth',10,'MinPeakDistance',30);
[~,J] = findpeaks(-ver,'MinPeakProminence',0.3,'MaxPeakWidth',10,'MinPeakDistance',30);
Xs = I(1); Ys = J(1);
Wb = mean(diff(I)); Nc = length(I) - 1;
Hb = mean(diff(J)); Nr = length(J) - 1;


%% get all blocks
blocks = {};
figure(2);
for i = 1:Nr
    for j = 1:Nc
        block = original(round(Ys+(i-1)*Hb+1):round(Ys+i*Hb),...
            round(Xs+(j-1)*Wb+1):round(Xs+j*Wb));
        blocks{end+1} = block;
        subplot(Nr,Nc,(i-1)*Nc+j);
        imshow(block);
    end
end