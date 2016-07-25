#compile:

1. main executable file: 
   
   Go to folder cryptonbm/ , and run command: make

2. unittest executable file:
   under folder cryptobnbm/test/ , and run command: make

#run:


1. main executable file:
    
   Go to folder cryptonbm/ , 

   and run command: ./tdsc.exe runtype user_id friend_num stranger_num item_num

   -runtype  1 -> single predication protocol; 2 -> top-n protocol

   An example here on movilen data set: runtype=1,user_id=1,friend_num=70,stranger_num=10,item_num=1682

   ./tdsc.exe 1 1 70 10 1682 

   User can generate a user's friends (Movielens), strangers files by:

   Go to folder tdsc/, run command:

   python run.py 12 user_id friend_num stranger_num

   for example:   python run.py 12 1 70 10


2. unittest executable file:
   under folder cryptobnbm/test/ , and run command: ./test.exe





