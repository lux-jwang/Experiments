
%%  Split data 2: totally excludes some user profile from traing set 
%   created by jun wang
%   jun.wang@uni.lu
%%  configuration

%%
clear;
maxepoch=10;    % the number of iteration
eta = 0.4;      % learning rate
lambda = 0.005; % regular parameter
eps = 5;        % \epsilon-differential privacy
sk=10;          % lower bound of |S_i|I_u^-
beta = 10;      % rescale parameter
NK=500;         % neighbor size
data_name = 'ml1m_tt';


%% cross validation
idxs = [ 1 2 4 5];
for idx=idxs
    clear smat tmp_smat total_sim count count_msk  xmat ymat zmat jac_count pcc_count count_o
    eval_string = sprintf('load %s_%s', data_name, num2str(idx));
    eval(eval_string);
    sparsematrix;
    count_o = count;
    count = bsxfun(@minus,count,mean_p);
    count = count.*count_msk;
    smat = 0.2*(rand(num_m)-0.5)*beta;  % rescale initial similarity
    
    %% training process
    fprintf(1, ' > DPNBM_SGD  start training %s_%s ... \n', data_name, num2str(idx));
    for epoch = 1:maxepoch+1
    tic
        smat = (smat+smat')/2;
        tmp_smat = smat;
        tmp_smat = sort(tmp_smat, 2, 'descend');
        k_vec = tmp_smat(:,NK); 
        tmp_smat = smat;
        tmp_smat(tmp_smat<repmat(k_vec, 1, num_m))= 0;

        total_sim = abs(tmp_smat)*count_msk;
        total_sim(total_sim<sk)=sk;
        pred_out_o = (tmp_smat*count)./total_sim;


        total_sim = abs(smat)*count_msk;
        total_sim(total_sim<sk)=sk;
        pred_out_vt = (smat*count)./total_sim;

        % %%%%%%%%%%% Compute predictions on the test set %%%%%%%%%%%%%%%
        pred_out_o = bsxfun(@plus,pred_out_o,mean_p);
        pred_out_o(pred_out_o>max_r) = max_r;
        pred_out_o(pred_out_o<min_r) = min_r;

        % %%%%%%%%%%%  RMSE on Test set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        t_fs = pred_out_o.*test_msk - test_mat;  
        t_fs = t_fs(t_fs~=0);
        t_err_rmse(epoch) = sqrt(sum(t_fs.^2)/test_num);
        t_err_mae(epoch) = sum(abs(t_fs))/test_num;

        % %%%%%%%%%%%  RMSE on Train set %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        t_fs = pred_out_o.*count_msk-count_o;
        t_fs = t_fs(t_fs~=0); 
        tr_err_rmse(epoch) = sqrt(sum(t_fs.^2)/train_num);
        tr_err_mae(epoch) = sum(abs(t_fs))/train_num;
       
        fprintf(1, 'epoch %4i, Train MAE  %6.4f; Train RMSE  %6.4f; Test MAE  %6.4f; Test RMSE  %6.4f; beta %6.4f, lambda %6.4f  \n', ...
            epoch, tr_err_mae(epoch), tr_err_rmse(epoch),t_err_mae(epoch),t_err_rmse(epoch), eta, lambda);

        %%%%%%%%%%%%%% Compute Gradients %%%%%%%%%%%%%%%%%%%?
        
        % Adding noise:
        emax = 0.5+3/(epoch+1);       % \varphi = 5-1
        df = (2*emax*4)/(sk);         % sensitivity
        err_mat = pred_out_vt.*count_msk-count_o;
        max(err_mat,emax); % clamp error bound
        min(err_mat,-emax);    
        sigma = (maxepoch*df)/(eps);
        lapn = laprnd(num_m,num_m,0,sigma);
       
        err_mat = err_mat./total_sim;
        g_s1 = (err_mat)*(count')+lambda*(smat)+lapn; % add noise
        smat = smat - (eta*g_s1*beta);
        clear err_mat total_sim pred_out_vt 
    toc        
    end
%% 

%% results

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
    fprintf(1, '< DPPBNM_SGD end training %s_%s ... \n', data_name, num2str(idx));
    
end




