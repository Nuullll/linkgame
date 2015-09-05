function category = classify(match_map,threshold,N)
% <m-by-3 matrix> match_map: match_map(i,3) = similarity
% <int> N: number of elements to be classified
% classify by similarity
% they're in the same class if similarity > threshold

% <n-by-1 cell> category: n CLASSes

    category{1} = match_map(1,1:2);
    
    isclassified = zeros(1,N);  % mark CLASS of each element
    isclassified(match_map(1,1:2)) = 1;     % CLASS 1
    
    for i = 1:size(match_map,1)
        row = match_map(i,:);
        if row(3) < threshold
            indexes = find(isclassified==0);
            for index = indexes
                [J,I] = find(match_map.'==index,10);   % find first 10 pairs containing INDEX
                inds = sub2ind(size(match_map),I,3-J);
                class = mode(isclassified(match_map(inds)));
                category{class} = union(category{class},match_map(I(1),J(1)));
                isclassified(match_map(I(1),J(1))) = class;
            end
            % finished
            break
        end
        
        status = isclassified(row(1:2));    % classify status
        if sum(status) == 0
            % all not classified
            % new class
            category{end+1} = row(1:2);
            isclassified(row(1:2)) = length(category);
        elseif all(status~=0)
            % all classified
            class1 = isclassified(row(1));
            class2 = isclassified(row(2));
            if class1 ~= class2
                % merge class2 into class1
                e = category{class2};
                category{class1} = [category{class1},e];
                isclassified(e) = class1;
                category{class2} = [];
            end
        else
            % one classified, the other NOT
            if status(1) == 0
                class = isclassified(row(2));
                category{class} = [category{class},row(1)];
                isclassified(row(1)) = class;
            else
                class = isclassified(row(1));
                category{class} = [category{class},row(2)];
                isclassified(row(2)) = class;
            end
        end
    end
    
    % delete empty cells
    result = {};
    for i = 1:length(category)
        if ~isempty(category{i})
            result{end+1} = category{i};
        end
    end
    
    category = result;
    
end