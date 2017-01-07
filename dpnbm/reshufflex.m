%% triplets: original data set
%% percentage: for training 

function [train_set, test_set] = reshufflex( triplets, percentage )
    percentage = 1-percentage/100;
    tri_len = length(triplets(:,1));
    xx = 1:tri_len;
    test_idx = randsample(xx, round(tri_len*percentage));
    test_set = triplets(test_idx,:);
    xx(test_idx)=0;
    train_idx = xx>0;
    train_set = triplets(train_idx,:);
end
