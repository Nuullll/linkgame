function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== 参数说明 ==========================
    
    % 输入参数中，mtx为图像块的矩阵，类似这样的格式：
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % 相同的数字代表相同的图案，0代表此处没有块。
    % 可以用[m, n] = size(mtx)获取行数和列数。
    % (x1, y1)与(x2, y2)为需判断的块的下标，即判断mtx(x1, y1)与mtx(x2, y2)
    % 是否可以消去。
    
    % 注意mtx矩阵与游戏区域的图像不是位置对应关系。下标(x1, y1)在连连看界面中
    % 代表的是以左下角为原点建立坐标系，x轴方向第x1个，y轴方向第y1个
    
    % 输出参数bool = 1表示可以消去，bool = 0表示不能消去。
    
    %% 在下面添加你的代码O(∩_∩)O
    
    [m,n] = size(mtx);
    
    % add surrounding zeros
    mtx = [0,zeros(1,n),0;
        zeros(m,1),mtx,zeros(m,1);
        0,zeros(1,n),0];
    
    origin = mtx(x1+1,y1+1);
    target = mtx(x2+1,y2+1);
    
    if origin == target && canlink2(mtx,x1+1,y1+1,x2+1,y2+1)
        bool = 1;
    else
        bool = 0;
    end
       
end


function [I,J] = adjcross(mtx,x,y)
% return index vector of can-reach blocks of mtx(x,y) on both directions
% notice: x >= 2 && y >= 2 && all(mtx >= 0)

% get vectors of four directions
left = mtx(x,1:y-1);
right = mtx(x,y+1:end);
up = mtx(1:x-1,y);
down = mtx(x+1:end,y);

% get zero run length adjacent to mtx(x,y)
lz = find(cumsum(left,'reverse')==0);
rz = find(cumsum(right,'forward')==0);
uz = find(cumsum(up,'reverse')==0);
dz = find(cumsum(down,'forward')==0);

I = [x*ones(1,length([lz,rz])),uz.',x+dz.'];
J = [lz,y+rz,y*ones(1,length([uz;dz]))];

end


function bool = canlink0(mtx,x1,y1,x2,y2)
% return 1 if it's a direct link (no turns)

if x1 == x2 && ~any(mtx(x1,min(y1,y2)+1:max(y1,y2)-1))
    bool = 1;
elseif y1 == y2 && ~any(mtx(min(x1,x2)+1:max(x1,x2)-1,y1))
    bool = 1;
else
    bool = 0;
end

end


function bool = canlink1(mtx,x1,y1,x2,y2)
% return 1 if the turns of link path <= 1

if canlink0(mtx,x1,y1,x2,y2)
    bool = 1;
    return
end

% grow the cross of origin
[I,J] = adjcross(mtx,x1,y1);

for n = 1:length(I)
    i = I(n); j = J(n);
    if canlink0(mtx,i,j,x2,y2)
        bool = 1;
        return
    end
end

bool = 0;

end


function bool = canlink2(mtx,x1,y1,x2,y2)
% return 1 if these two blocks can link!

if canlink1(mtx,x1,y1,x2,y2)
    bool = 1;
    return
end

% grow the cross of origin
[I,J] = adjcross(mtx,x1,y1);

for n = 1:length(I)
    i = I(n); j = J(n);
    if canlink1(mtx,i,j,x2,y2)
        bool = 1;
        return
    end
end

bool = 0;

end
