%%  Differentially private NBM - posterior sampling via SGLD
%   created by jun wang
%   jun.wang@uni.lu
%%


%%  configuration 
clear;
maxepoch=300;       % the number of sampling iteration
reduce_begin = 40;  % accelerate training process
eta1 = 4e-7;        % initial learning rate
mineta = 1e-12;     % min learning rate
eta = eta1;         % initialization
lambda = 2e-2;      % regular parameter
NK=500;             % neighbor size
gam = 0.3;          % decay rate
temp = 0.004;       % temperature
tau = 200;          % max rating per user
eps = tau*1;        % differential privacy, in form of x \times \tau
data_name = 'ml1m_tt';

%% cross validation
idxs = [1 2 4 5];
for idx=idxs
    tic
    clear smat tmp_smat total_sim count count_msk smat  count_o tr_err_rmse t_err_mae
   
    eval_string = sprintf('load %s_%s', data_name, num2str(idx));
    eval(eval_string);
    sparsematrix;
    count_o = count;
    count = bsxfun(@minus,count,mean_p);
    count = count.*count_msk;
    
    %  !!!
    %  nm_c denotes \mathbb{H}, in algorithm 2 
    %  sumx = sum(count_msk,2);
    %  nm_c = 1-(sumx*sumx')./(train_num^2); % -> 1, such that we let nm_c = 1 
    nm_c = 1; 
    
    bound = eps/(64*tau); % (\hat{r}_{ui}-r_{ui})^2 = 64
    smat = 0.2*(rand(num_m)-0.5); % Initialize latent similarity matrix
    fprintf(1, '> PNBM_PS start training %s_%s ... \n', data_name, num2str(idx));
    
    %% training process
    fprintf(1, ' > DPNBM_PS  start training %s_%s ... \n', data_name, num2str(idx));
    for epoch = 1:maxepoch+1
        tic
        % note, noise here is for samling, not for privacy
        smat = smat+randn(num_m).*sqrt(eta*temp); 
        smat = (smat+smat')/2;
 
        tmp_smat = smat;
        tmp_smat = sort(tmp_smat, 2, 'descend');
        k_vec = tmp_smat(:,NK); 
        tmp_smat = smat;
        tmp_smat(tmp_smat<repmat(k_vec, 1, num_m))= 0;

        total_sim = abs(tmp_smat)*count_msk;
        total_sim(total_sim == 0) = 1;
        pred_out_o = (tmp_smat*count)./total_sim;
        

        total_sim = abs(smat)*count_msk;
        total_sim(total_sim == 0) = 1;
        pred_out_vt = (smat*count)./total_sim;
        
        pred_out_o = bsxfun(@plus,pred_out_o,mean_p);
        pred_out_o(pred_out_o>max_r) = max_r;
        pred_out_o(pred_out_o<min_r) = min_r;
        
        % %%%%%%%%%%% Compute predictions on the Test set %%%%%%%%%%%%%%%
        t_fs = pred_out_o.*test_msk - test_mat;  
        t_fs = t_fs(t_fs~=0);
        t_err_rmse(epoch) = sqrt(sum(t_fs.^2)/test_num);
        t_err_mae(epoch) = sum(abs(t_fs))/test_num;

        % %%%%%%%%%%% Compute predictions on the Train set %%%%%%%%%%%%%%%
        t_fs = pred_out_o.*count_msk-count_o;
        t_fs = t_fs(t_fs~=0); 
        tr_err_rmse(epoch) = sqrt(sum(t_fs.^2)/train_num);
        tr_err_mae(epoch) = sum(abs(t_fs))/train_num;
       

        fprintf(1, 'epoch %4i, Train MAE  %6.4f; Train RMSE  %6.4f; Test MAE  %6.4f; Test RMSE  %6.4f; beta %6.4f, lambda %6.4f  \n', ...
            epoch, tr_err_mae(epoch), tr_err_rmse(epoch),t_err_mae(epoch),t_err_rmse(epoch), eta, lambda);

        % %%%%%%%%%%%%% Compute Gradient %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear t_fs pred_out_o
        err_mat = pred_out_vt.*count_msk-count_o;
        g_s = ((err_mat./total_sim)*(count')*(train_num*bound)) +(smat./nm_c)*(train_num*lambda*bound); 
        smat = smat - eta*g_s;
        clear err_mat total_sim g_s pred_out_vt
        
        % %%%%%%%%%%%%% update parameter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        eta = eta1/(epoch^gam);
        eta = max(eta, mineta);
        if epoch <reduce_begin
            eta = eta1;
        end
    toc        
    end

    fprintf(1, '\n tr_err_rmse: ');
    for em = tr_err_rmse
         fprintf(1, ' %6.4f', em);
    end

    fprintf(1, '\n t_err_rmse: ');
    for em = t_err_rmse
         fprintf(1, ' %6.4f', em);
    end

    fprintf(1, '\n tr_err_mae: ');
    for em = tr_err_mae
         fprintf(1, ' %6.4f', em);
    end

    fprintf(1, '\n t_err_mae: ');
    for em = t_err_mae
         fprintf(1, ' %6.4f', em);
    end
    fprintf(1, '\n end testing... \n ');
    fprintf(1, '<<<<< PNBM_PS end training %s_%s ...>>>> \n', data_name, num2str(idx));
    toc
    
end

