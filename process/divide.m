%% load image and preprocess
image = imread('graycapture.jpg');
% image = im2bw(image,0.8);
imshow(image)
image = double(image);
image = image - 128;


%% get block size and position of game region
hor = mean(image,1);
ver = mean(image,2);

figure(1);
subplot 211; plot(hor);
xlabel('Pixels'); ylabel('Gray Level'); title('水平扫描线均值');
subplot 212; plot(ver);
xlabel('Pixels'); ylabel('Gray Level'); title('竖直扫描线均值');

npeak = min(hor);   % negative peak
I = find(hor<0.9*npeak);
I = sort(I);
Xs = I(1);
I = diff(I);        % width between peaks
I = I(I>30);        % filter too small blocks
Wb = mean(I)+1;
Nc = length(I);     % number of block columns

npeak = min(ver);   % negative peak
I = find(ver<0.9*npeak);
I = sort(I);
Ys = I(1);
I = diff(I);        % width between peaks
I = I(I>30);        % filter too small blocks
Hb = mean(I)+1;
Nr = length(I);     % number of block rows


%% get all blocks
blocks = {};
figure(2);
for i = 1:Nr
    for j = 1:Nc
        block = image(Ys+(i-1)*Hb+1:Ys+i*Hb,Xs+(j-1)*Wb+1:Xs+j*Wb);
        blocks{end+1} = block;
        subplot(Nr,Nc,(i-1)*Nc+j);
        imshow(uint8(block+128));
    end
end