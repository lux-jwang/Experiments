author: jun.wang (at) uni.lu

We will not try to improve this implementation. But if you find any bug, please feel free to contact me.
#

#Description
1  You can run.py to start the program. e.g.: "python run.py 99". This command is to show FMT dataset information. 
    
    more details:
    
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
    
    print "9 -- Single friend influence without involving any stranger on 10-FMT"

    print "10 -- Single friend influence without involving any stranger on MovieLens"

    print "11 -- Create protocol similation files from 10-FMT. You should input user_id (FMT is twitter ID)"

    print "12 -- Create protocol similation files from MovieLens. You should input user_id (FMT is twitter ID)"

    print "13 -- show a number of user ids of FMT"
    
    print "14 -- show a number of user ids of MovieLens"
    
    print "99 -- Show FMT dataset information"

2  Required packages:
   
   numpy, pickle 
