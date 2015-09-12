%% run divide.m
divide;


%% calculate similarity
match_map = similarsort(blocks);


%% classify
category = classify(match_map,0.92,Nc*Nr);


%% get mtx
mtx = zeros(Nc,Nr);

for i = 1:length(category)
    mtx(category{i}) = i;  % rowwise index
end

mtx = mtx.';

% ...
%% solve mtx
[steps,connections] = solvelinkgame(mtx);


%% visualization
% show original picture
figure(1);
imshow(original);
hold on;
pause(5);

% visualize steps
image = original;
[height,width] = size(image);
for n = 1:size(connections,1)
    pre_image = image;  % save previous image
    connection = connections(n,:);
    nodesX = connection{1};
    nodesY = connection{2};
    for m = 1:length(nodesX)-1
        x1 = round(Ys + (min(nodesX(m),nodesX(m+1))-1)*Hb + Hb/2);
        x2 = round(Ys + (max(nodesX(m),nodesX(m+1))-1)*Hb + Hb/2);
        y1 = round(Xs + (min(nodesY(m),nodesY(m+1))-1)*Wb + Wb/2);
        y2 = round(Xs + (max(nodesY(m),nodesY(m+1))-1)*Wb + Wb/2);
        x1 = min(max(x1,round(Ys/2)),round((height+Ys+Nr*Hb)/2));
        y1 = min(max(y1,round(Xs/2)),round((width+Xs+Nc*Wb)/2));
        x2 = min(max(x2,round(Ys/2)),round((height+Ys+Nr*Hb)/2));
        y2 = min(max(y2,round(Xs/2)),round((width+Xs+Nc*Wb)/2));
        
        image(x1:x2+2,y1:y2+2) = 0;     % color=black, width=3
    end
    % show link
    imshow(image);
    pause(1);
    
    image = pre_image;
    x1 = round(Ys + (steps(1+(n-1)*4+1)-1)*Hb);
    y1 = round(Xs + (steps(1+(n-1)*4+2)-1)*Wb);
    x2 = round(x1 + Hb);
    y2 = round(y1 + Wb);
    image(x1:x2,y1:y2) = 255;
    x1 = round(Ys + (steps(1+(n-1)*4+3)-1)*Hb);
    y1 = round(Xs + (steps(1+(n-1)*4+4)-1)*Wb);
    x2 = round(x1 + Hb);
    y2 = round(y1 + Wb);
    image(x1:x2,y1:y2) = 255;
    % show removed blocks
    imshow(image);
    pause(1);
    
end
hold off;