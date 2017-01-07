%%  Randomly, split data set into training set and test set
%   created by jun wang
%   jun.wang@uni.lu
%%

load tml1m
data = ml1m;
data_name = 'ml1m_tt';

i_ids = unique(data(:,2));
u_ids = unique(data(:,1));
num_m = length(i_ids);
num_p = length(u_ids);
if num_m ~= max(i_ids)
     fprintf(1,'WARN: item id may be incorrect \n');
end
if num_p ~= max(u_ids)
     fprintf(1,'WARN: user id may be incorrect \n');
end

pct = 90; % the percentage for traning set


for idx = 1:5
    [train_vec, test_vec] = reshufflex(data, pct);  
    eval_string = sprintf('save %s_%s train_vec test_vec', data_name, num2str(idx));
    eval(eval_string);
end
    




