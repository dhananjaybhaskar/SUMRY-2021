function ranger = src_range_cell0cell(c1, c2, c3, c4)

if (nargin < 4)
    c4 = cell(1,2);
    c4{1} = [0 0];
    c4{2} = [0 0];
end

all_min = 0;
all_max = 0;

%% C1
for i=1:length(c1)
    tgt = c1{i};
    if (~any(isnan(tgt)))
        tgt_min = min(tgt);
        tgt_max = max(tgt);

        if (tgt_min < all_min)
            all_min = tgt_min;
        end
        if (tgt_max > all_max)
            all_max = tgt_max;
        end
    end
end

%% C2
for i=1:length(c2)
    tgt = c2{i};
    if (~any(isnan(tgt)))
        tgt_min = min(tgt);
        tgt_max = max(tgt);

        if (tgt_min < all_min)
            all_min = tgt_min;
        end
        if (tgt_max > all_max)
            all_max = tgt_max;
        end
    end
end

%% C3
for i=1:length(c3)
    tgt = c3{i};
    if (~any(isnan(tgt)))
        tgt_min = min(tgt);
        tgt_max = max(tgt);

        if (tgt_min < all_min)
            all_min = tgt_min;
        end
        if (tgt_max > all_max)
            all_max = tgt_max;
        end
    end
end

%% C4

for i=1:length(c4)
    tgt = c4{i};
    if (~any(isnan(tgt)))
        tgt_min = min(tgt);
        tgt_max = max(tgt);

        if (tgt_min < all_min)
            all_min = tgt_min;
        end
        if (tgt_max > all_max)
            all_max = tgt_max;
        end
    end
end

%% return
ranger = [all_min all_max];

end