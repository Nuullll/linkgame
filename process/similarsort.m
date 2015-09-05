function match_map = similarsort(blocks)
% <1-by-n cell> blocks
% <m-by-3 matrix> match_map: m == n*(n-1)/2,
%       the first 2 elements are indexes of blocks,
%       the third element is similarity
%       rows of match_map are sorted by similarity

    match_map = [];
    
    hp = [-0.3,-0.3,-0.3;
          -0.3, 0.5,-0.3;
          -0.3,-0.3,-0.3];     % construct high pass filter
      
    N = length(blocks);
    for i = 1:N
        im1 = imfilter(double(blocks{i})-128,hp);
        im1 = (im1-min(min(im1)))/(max(max(im1))-min(min(im1)))*255-128;
        for j = i+1:N
            im2 = imfilter(double(blocks{j})-128,hp);
            im2 = (im2-min(min(im2)))/(max(max(im2))-min(min(im2)))*255-128;
            match_map = [match_map;[i,j,similarity(im1,im2)]];
        end
    end
    
    match_map = sortrows(match_map,-3);
    
end