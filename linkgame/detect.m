function bool = detect(mtx, x1, y1, x2, y2)
    % ========================== ����˵�� ==========================
    
    % ��������У�mtxΪͼ���ľ������������ĸ�ʽ��
    % [ 1 2 3;
    %   0 2 1;
    %   3 0 0 ]
    % ��ͬ�����ִ�����ͬ��ͼ����0����˴�û�п顣
    % ������[m, n] = size(mtx)��ȡ������������
    % (x1, y1)��(x2, y2)Ϊ���жϵĿ���±꣬���ж�mtx(x1, y1)��mtx(x2, y2)
    % �Ƿ������ȥ��
    
    % ע��mtx��������Ϸ�����ͼ����λ�ö�Ӧ��ϵ���±�(x1, y1)��������������
    % ������������½�Ϊԭ�㽨������ϵ��x�᷽���x1����y�᷽���y1��
    
    % �������bool = 1��ʾ������ȥ��bool = 0��ʾ������ȥ��
    
    %% �����������Ĵ���O(��_��)O
    
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
