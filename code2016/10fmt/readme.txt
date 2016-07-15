1. This data set is built based on MovieTweetings dataset: https://github.com/sidooms/MovieTweetings.
2. We crawled the friends information for each user in MovieTweetings dataset since it does not have.

There are three files in the dataset: ratings.dat, users.dat, friends.dat.


<ratings.dat> records users' rating information on moives.
format>> twitter_id::movie_id::rating::rating_timesstamp
         (!!!in fmt dataset, instead of using twitter_id, it uses user_id )
The ratings contained in the tweets are scaled from 0 to 10.

<users.dat> contains the mapping for user_id to real twitter_id.
format>> {user_id1:twitter_id1, user_id2:twitter_id2, ...}

<friends.dat> contains each user's friends inforamtion (twitter_id).
format>> {user_id1:[twitter_id9,twitter_id17,...,twitter_idn],user_id2:[twitter_id10,...],user_id3:[twitter_id100,...],...}
 
