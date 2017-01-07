%Note that triplets-style orignal data set should be Prepared before this

%file


to_vec = [train_vec; test_vec];
num_m = max(to_vec(:,2));
num_p = max(to_vec(:,1));

denoi = max(to_vec(:,3))/5;
clear to_vec

%train_mat
max_r = max(train_vec(:,3)/denoi);
min_r = min(train_vec(:,3)/denoi);
g_avg = mean(train_vec(:,3));

count = sparse(train_vec(:,2),train_vec(:,1),train_vec(:,3)/denoi,num_m,num_p);
test_mat = sparse(test_vec(:,2),test_vec(:,1),test_vec(:,3)/denoi,num_m,num_p);
count=full(count);
test_mat=full(test_mat);

train_num = length(train_vec);
test_num = length(test_vec);

count_msk = count;
count_msk(count_msk~=0)=1;

mean_p = sum(count,2)./ sum(count~=0, 2);
mean_p(isnan(mean_p)) = g_avg;
mean_p = full(mean_p);
test_msk = test_mat;
test_msk(test_msk~=0)=1;

%clear train_vec test_vec










 

