function [canlink,nodesX,nodesY] = findpath(mtx,x1,y1,x2,y2)
% Update function CANLINK to FINDPATH, returning path nodes as well
% return [1,nodesX,nodesY] if these two blocks can be linked
    
    nodesX = [];
    nodesY = [];

    if mtx(x1,y1) ~= mtx(x2,y2) || ~mtx(x1,y1) || ~mtx(x2,y2)
        canlink = 0;
        return
    end
    
    [canlink,nodesX,nodesY] = findpath1(mtx,x1,y1,x2,y2);
    if canlink
        return
    end
    
    % grow the cross of origin
    [I,J] = adjcross(mtx,x1,y1);

    for n = 1:length(I)
        i = I(n); j = J(n);
        [canlink,nodesX,nodesY] = findpath1(mtx,i,j,x2,y2);
        if canlink
            nodesX = [x1,nodesX];
            nodesY = [y1,nodesY];
            return
        end
    end

    canlink = 0;

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


function [bool,nodesX,nodesY] = findpath0(mtx,x1,y1,x2,y2)
% return [1,nodesX,nodesY] if it's a direct link (no turns)
% return [0,~,~] otherwise

    nodesX = [];
    nodesY = [];

    if x1 == x2 && ~any(mtx(x1,min(y1,y2)+1:max(y1,y2)-1))
        bool = 1;
        nodesX = [x1,x2];
        nodesY = [y1,y2];
    elseif y1 == y2 && ~any(mtx(min(x1,x2)+1:max(x1,x2)-1,y1))
        bool = 1;
        nodesX = [x1,x2];
        nodesY = [y1,y2];
    else
        bool = 0;
    end

end


function [bool,nodesX,nodesY] = findpath1(mtx,x1,y1,x2,y2)
% return [1,nodesX,nodesY] if the turns of link path <= 1
% return [0,~,~] otherwise

    [bool,nodesX,nodesY] = findpath0(mtx,x1,y1,x2,y2);
    if bool
        return
    end

    % grow the cross of origin
    [I,J] = adjcross(mtx,x1,y1);

    for n = 1:length(I)
        i = I(n); j = J(n);
        [bool,nodesX,nodesY] = findpath0(mtx,i,j,x2,y2);
        if bool
            nodesX = [x1,nodesX];
            nodesY = [y1,nodesY];
            return
        end
    end

    bool = 0;
    nodesX = [];
    nodesY = [];

end