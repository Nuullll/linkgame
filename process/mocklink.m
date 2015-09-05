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