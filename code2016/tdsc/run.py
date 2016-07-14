# author: jun.wang (at) uni.lu
# We will not try improve this implementation. But if you find any bug, please feel free to contact me.

import sys
import datetime
from os import path
from random import shuffle
import numpy as np
import pickle
from scipy import stats
import matplotlib.pyplot as plt

sys.path.append("./src")
from models import Model, FriendsModel
from similarities import CosineSimilarity, JaccardSimilarity
from dataset import get_friends_data, get_user_item_matrix, get_user_item_matrix_sub, \
                    get_reputation, get_original_user_item_matrix,get_original_UI, \
                    get_moive100k, construct_data_set
from evaluators import GlobalJaccardKfold,FriendsJaccardKfold,FriendsCosineKfold, \
                       GlobalCosineKfold,NMFKfold, FriendsReputationKfold, \
                       GlobalReputationKfold, FriendStrangerKfold,\
                       JphKfold, EsoricsSingleUserValidation
from evaluators import root_mean_square_error, mean_absolute_error


def get_friends_from_ml100k():
    dst_file = "./src/dataset/movie100k/ml100kfriend.dat"
    if path.isfile(dst_file):
        friend_data = pickle.load(open(dst_file, "rb"))
        return friend_data

    raw_data = get_moive100k(True);
    raw_model = Model(raw_data);
    cosine_sim = CosineSimilarity(raw_model)
    friend_data = {}

    for user_id in raw_model.get_user_ids():
        neighbors = cosine_sim.get_similarities(user_id)[:250]
        user_ids, x = zip(*neighbors)
        user_ids = list(user_ids)
        shuffle(user_ids)
        # note: 
        # Randomly choose 150 out of 250 neighbors as friends.
        # In such case, systems is able to (possiblly) choose strangers which 
        # are in top-250 similar users, but with a probability slightly
        # smaller than friends selection.
        friend_data[user_id] = user_ids[:150] 

    pickle.dump(friend_data,open(dst_file, "w"),protocol=2)
    return friend_data

def calculate_cosine_similarity_friends(raw_data,friend_data):

    friend_model = FriendsModel(raw_data,friend_data)
    cosine_sim = CosineSimilarity(friend_model)
    c_sims = {}

    for ky in friend_model.get_friends_roster():
        f_ids = friend_model.get_friends(ky)
        sorted_sims = cosine_sim.get_similarities(ky, f_ids)
        c_sims[ky] = sorted_sims
    return c_sims


def calculate_cosine_similarity_global(raw_data,friend_data):
    friend_model = FriendsModel(raw_data,friend_data)
    cosine_sim = CosineSimilarity(friend_model)
    c_sims = {}

    for u_id in friend_model.get_friends_roster():
    	f_num = len(friend_model.get_friends(u_id))
        target_ids = friend_model.get_strangers_in_roster(u_id)
        sorted_sims = cosine_sim.get_similarities(u_id,target_ids)
        c_sims[u_id] = sorted_sims[:f_num]
    return c_sims


def get_metrics_methods():
    return {"RMSE":root_mean_square_error,
            "MAE": mean_absolute_error}

def calculate_cosine_rmse_friends(raw_data,friend_data):
    mtrs = get_metrics_methods()
    fckx = FriendsCosineKfold(5,raw_data,friend_data,mtrs)
    fckx.cross_validate()
    return


def calculate_cosine_friends_strangers(raw_data,friend_data, f_t_shape):
    f_ratios = [0.5,0.6,0.7,0.8,0.9,1.0]
    mtrs = get_metrics_methods()
    results = {}

    for f_n, t_n in f_t_shape:
        for ratio in f_ratios:
            ky = str(f_n)+"-"+str(t_n)+"-"+str(ratio)
            print "start cross validation > friendN-strangerN-ratio: ", ky
            ftkflod = FriendStrangerKfold(5,raw_data,friend_data,mtrs,f_n,t_n,ratio)
            mean_rs, bound, mae_std, max_mae, min_mae = ftkflod.cross_validate()
            one_rs =  [round(mean_rs,4), round(bound,4), round(mae_std,4),round(max_mae,4), round(min_mae,4)]
            results[ky] = one_rs
            print ">> mean: ", round(mean_rs,4), "; max diverse: ", round(bound,4), "; STD: ", round(mae_std,4), "; max MAE, ", round(max_mae,4), "; min MAE: ", round(min_mae,4)
    return results

def single_influence(raw_data, friend_data,testfriend):
    if testfriend:
        f_ns = [11, 31] # randomly remove on when selecting friends
        t_n = 10
        filename = "friend_dif_"
    else:
        f_ns = [10, 30]
        t_n = 11 # randomly remove on when selecting strangers
        filename = "stranger_dif"

    ratio = 0.8
    for f_n in f_ns:
        print "50X(5-fold CV) for friends num: ", f_n
        esvlidation = EsoricsSingleUserValidation(5,raw_data,friend_data,f_n,t_n,ratio,testfriend)
        results = esvlidation.cross_validate()
        tname = filename+str(f_n)
        np.savetxt(tname, results, delimiter=',')
        #print results

def jhk_friends(raw_data, friend_data, f_s):
    mtrs = get_metrics_methods()
    for  f_num in f_s:
       print "start cross validation >  friend num: ", f_num
       jkx = JphKfold(5,raw_data,metrics=mtrs,friends_data=friend_data, friends_num=f_num)
       mean_rs, bound, mae_std, max_mae, min_mae = jkx.cross_validate()
       
       print ">> mean: ", round(mean_rs,4), "; max diverse: ", round(bound,4), "; STD: ", round(mae_std,4), "; max MAE, ", round(max_mae,4), "; min MAE: ", round(min_mae,4)


def MAE_on_10_FMT():
    friend_data = get_friends_data()
    raw_data = get_user_item_matrix()
    f_ts = [(10,10),(20,10),(30,10),(40,10),(50,10)]
    calculate_cosine_friends_strangers(raw_data, friend_data, f_ts)
    return

def MAE_on_MovieLens():
    friend_data = get_friends_from_ml100k()
    raw_data = get_moive100k()
    f_ts = [(10,10),(20,10),(30,10),(40,10),(50,10),(60,10),(70,10),(80,10),(90,10),(100,10)]
    calculate_cosine_friends_strangers(raw_data, friend_data, f_ts)
    return

def Single_Friend_Influence_on_10_FMT():
    friend_data = get_friends_data()
    raw_data = get_user_item_matrix()
    single_influence(raw_data,friend_data,True)

def Single_Friend_Influence_on_MovieLens():
    friend_data = get_friends_from_ml100k()
    raw_data = get_moive100k()
    single_influence(raw_data,friend_data,True)

def Single_Stranger_Influence_on_10_FMT():
    friend_data = get_friends_data()
    raw_data = get_user_item_matrix()
    single_influence(raw_data,friend_data,False)

def Single_Stranger_Influence_on_MovieLens():
    friend_data = get_friends_from_ml100k()
    raw_data = get_moive100k()
    single_influence(raw_data,friend_data,False)

def JPH_on_10_FMT():
    f_s = [10, 20 ,30, 40, 50]
    friend_data = get_friends_data()
    raw_data = get_user_item_matrix()
    jhk_friends(raw_data, friend_data, f_s)


def JPH_on_MovieLens():
    f_s = [20, 40 ,60, 80, 100]
    friend_data = get_friends_from_ml100k()
    raw_data = get_moive100k()
    jhk_friends(raw_data, friend_data, f_s)

def Show_Data_Info():
    print "Location: >>"
    print "    FMT original files: ./src/dataset/expdata. "
    print "    Filted K-FMT files (binary): ./src/dataset/mid_data. "
    print "Dataset description: >> "
    print "    1. This data set is built based on MovieTweetings dataset: https://github.com/sidooms/MovieTweetings."
    print "    2. We crawled the friends information for each user in MovieTweetings dataset since it does not have."

    print "    There are three files in the dataset: ratings.dat, users.dat, friends.dat."


    print "    <ratings.dat> records users' rating information on moives."
    print "    format>> user_id::movie_id::rating::rating_timesstamp"
    print "    The ratings contained in the tweets are scaled from 0 to 10."
 
    print "    <users.dat> contains the mapping for user_id to real twitter_id."
    print "    format>> {user_id1:twitter_id1, user_id2:twitter_id2, ...}"

    print "    <friends.dat> contains each user's friends inforamtion (twitter_id)."
    print "    format>> {user_id1:[twitter_id9,twitter_id17,...,twitter_idn],user_id2:[twitter_id10,...],user_id3:[twitter_id100,...],...}"


def note():
    print "Please indicate target: "
    print "0 -- filter FMT data set by friend num (default value: 10) and rating number (default value: 10)"
    print "1 -- MAE test on 10-FMT "
    print "2 -- MAE test on MovieLens "
    print "3 -- JPH test on 10-FMT "
    print "4 -- JPH test on MovieLens "
    print "5 -- Single friend influence test on 10-FMT "
    print "6 -- Single friend influence test on MovieLens "
    print "7 -- Single stranger influence test on 10-FMT "
    print "8 -- Single stranger influence test on MovieLens "
    print "99 -- Show FMT dataset information"



if __name__ == '__main__':

    if len(sys.argv) < 2:
        note()

    else:
        tasks = {"0": construct_data_set,
                 "1": MAE_on_10_FMT,
                 "2": MAE_on_MovieLens,
                 "3": JPH_on_10_FMT,
                 "4": JPH_on_MovieLens,
                 "5": Single_Friend_Influence_on_10_FMT,
                 "6": Single_Friend_Influence_on_MovieLens,
                 "7": Single_Stranger_Influence_on_10_FMT,
                 "8": Single_Stranger_Influence_on_MovieLens,
                 "99": Show_Data_Info
        }

        tgt = sys.argv[1]
        if not tgt in tasks:
            note()
        else:
            if tgt == '0':
                if len(sys.argv) < 4:
                    print "set both friend num and rate num to default value 10"
                    friend_num = 10
                    rate_num = 10
                else:
                    friend_num = int(sys.argv[2])
                    rate_num = int(sys.argv[3])
                    print "set friend num to ", str(friend_num), ", set rate num to ", str(rate_num)
                construct_data_set(friend_num=friend_num,rate_num=rate_num)
                print "New generated data files are located at: ./src/dataset/mid_data "
                print "Note: For faster IO, we save the data as binary format. The ratings are scaled to [0,5]."
                print "The original ASCII format files of FMT are located at: ./src/dataset/expdata"

            else:
                tasks[tgt]()

