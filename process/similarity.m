function S = similarity(im1,im2)
% return similarity of two intensity images: im1 and im2
% notice: 0 <= S <= 1

    im1 = double(im1);
    im2 = double(im2);
    S = max(max(filter2(im1,im2)) / ...
        sqrt(sum(sum(im1.^2))*sum(sum(im2.^2))));
    
end