//
//  NSObject_UniversalHeader.h
//  Goodpasture Application
//
//  Created by Phillip Trent on 10/11/13.
//  Copyright (c) 2013 Phillip Trent Coding. All rights reserved.
//


//This is for whomever needs to edit this application

//---------------------------------ONLY CHANGE BLUE OR RED THINGS------------------------------------

//If it's in quotations, it should always be in quotations
//---------------------------------------
//Twitter:
//---------------------------------------
#define MAX_NUMBER_OF_TWITTER_REQUESTS 15
#define TIME_INTERVAL_TWITTTER_REQUEST_SECONDS 600
//This is the twitter username for the News and #Sports sections of the app
#define ANNOUNCEMENTS_DESTINATION_TWITTER_USERNAME @"GCSAnnouncement"
#define SPORTS_DESTINATION_TWITTER_USERNAME @"GCSsportsTweets"


//This is the number of tweets to receive upon each request to twitter
#define DEFAULT_NUMBER_OF_TWEETS_TO_RETRIEVE 50 //Try not to make this number too small. I wouldn't go lower than 30


//Destination for the "Calendar" section of the application
#define UPCOMING_EVENTS_DESTINATION_URL @"http://goodpasture.org/calendar"
#define POWERSCHOOL_DESTINATION_URL @"https://goodpasture.powerschool.com/guardian/home.html"


//These are the different # sections in the #Sports section. Feel free to change and rearrange, just make sure to follow the pattern
#define HASH_TAGS @[@"#AllSports", @"#Baseball", @"#Basketball", @"#Bowling", @"#Football", @"#Golf", @"#Soccer", @"#Softball", @"#Tennis", @"#Track", @"#Volleyball"]


//---------------------------------------
//Google:
//---------------------------------------
#define YOUTUBE_API_KEY @"AIzaSyCdZaPRsi6NiGBt9jMNcbtWUTmw-he0qIM"