function steps = omg(mtx)
    % -------------- �������˵�� --------------
    
    %   ��������У�mtxΪͼ���ľ������������ĸ�ʽ��
    %   [ 1 2 3;
    %     0 2 1;
    %     3 0 0 ]
    %   ��ͬ�����ִ�����ͬ��ͼ����0����˴�û�п顣
    %   ������[m, n] = size(mtx)��ȡ������������
    
    %   ע��mtx��������Ϸ�����ͼ����λ�ö�Ӧ��ϵ���±�(x1, y1)��������������
    %   ������������½�Ϊԭ�㽨������ϵ��x�᷽���x1����y�᷽���y1��
    
    % --------------- �������˵�� --------------- %
    
    %   Ҫ�����ó��Ĳ����������steps������,��ʽ���£�
    %   steps(1)��ʾ��������
    %   ֮��ÿ�ĸ���x1 y1 x2 y2�������mtx(x1,y1)��mtx(x2,y2)��ʾ�Ŀ�������
    %   ʾ���� steps = [2, 1, 1, 1, 2, 2, 1, 3, 1];
    %   ��ʾһ����2������һ����mtx(1,1)��mtx(1,2)��ʾ�Ŀ�������
    %   �ڶ�����mtx(2,1)��mtx(3,1)��ʾ�Ŀ�������
    
    %% --------------  �������������Ĵ��� O(��_��)O~  ------------
    
    [m,n] = size(mtx);
    
    % add surrounding zeros
    mtx = [0,zeros(1,n),0;
        zeros(m,1),mtx,zeros(m,1);
        0,zeros(1,n),0];
    
    [steps1,mtx] = matchadj(mtx);
    [steps2,mtx] = matchborder(mtx);
    [steps3,mtx] = matchrest(mtx);
    steps = [steps1,steps2,steps3];
    
    % make steps meet interface
    steps = [length(steps)/4,steps-1];
end


function [steps,mtx] = matchadj(mtx)
% match adjacent removable blocks

    steps = [];
    
    % match adjacent blocks
    % using diff() is effective
    % row difference
    rdiff = diff(mtx,1,1);
    [I,J] = find(rdiff==0);
    for n = 1:length(I)
        % ?empty blocks
        if mtx(I(n),J(n)) ~= 0 && mtx(I(n)+1,J(n)) ~= 0
            % match!
            steps = [steps,I(n),J(n),I(n)+1,J(n)];
            % update mtx
            mtx(I(n),J(n)) = 0;
            mtx(I(n)+1,J(n)) = 0;
        end
    end
    
    % column difference
    cdiff = diff(mtx,1,2);
    [I,J] = find(cdiff==0);
    for n = 1:length(I)
        % ?empty blocks
        if mtx(I(n),J(n)) ~= 0 && mtx(I(n),J(n)+1) ~= 0
            % match!
            steps = [steps,I(n),J(n),I(n),J(n)+1];
            % update mtx
            mtx(I(n),J(n)) = 0;
            mtx(I(n),J(n)+1) = 0;
        end
    end
end


function [steps,mtx] = matchborder(mtx)
% match blocks on the same border

    [m,n] = size(mtx);
    steps = [];

    isstable = 0;   % whether mtx is stable, i.e. no more removable pairs on borders
    while isstable ~= 4     % stable on four borders
        for k = 1:4     % four borders
            if k == 1
                % upper border
                ub = sum(cumsum(mtx)==0) + 1;
                ub(ub>m) = nan;     % a column of zeros
                index = sub2ind(size(mtx),ub,1:n);
            elseif k == 2
                % bottom border
                bb = m - sum(cumsum(mtx,'reverse')==0);
                bb(bb<1) = nan;
                index = sub2ind(size(mtx),bb,1:n);
            elseif k == 3
                % left border
                lb = sum(cumsum(mtx,2)==0,2) + 1;
                lb(lb>n) = nan;
                index = sub2ind(size(mtx),1:m,lb.');
            else
                % right border
                rb = n - sum(cumsum(mtx,2,'reverse')==0,2);
                rb(rb<1) = nan;
                index = sub2ind(size(mtx),1:m,rb.');
            end
            index = index(~isnan(index));   % delete nan
            blocks = mtx(index);

            b = unique(blocks);
            if length(b) < length(blocks)   % same blocks
                isstable = 0;
                for be = b
                    i = find(blocks==be);
                    if length(i) >= 2
                        [I,J] = ind2sub(size(mtx),index(i(1:2)));
                        % add steps
                        steps = [steps,I(1),J(1),I(2),J(2)];
                        % update mtx
                        mtx(index(i(1:2))) = 0;
                        break
                    end
                end
            else
                isstable = isstable + 1;
                if isstable == 4
                    break
                end
            end
        end
    end
    
end


function [steps,mtx] = matchrest(mtx)
% match rest blocks

    steps = [];
    
    while any(any(mtx))         % game NOT over
        kinds = unique(mtx);    % get kinds of blocks
        kinds = kinds(2:end);   % remove 0

        for k = 1:length(kinds)
            kind = kinds(k);
            [I,J] = find(mtx==kind);
            for m = 1:length(I)
                for n = m+1:length(I)
                    if canlink(mtx,I(m),J(m),I(n),J(n))
                        steps = [steps,I(m),J(m),I(n),J(n)];
                        % update mtx
                        mtx(I(m),J(m)) = 0;
                        mtx(I(n),J(n)) = 0;
                        break
                    end
                end
            end
        end
    end

end