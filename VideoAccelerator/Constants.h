//
//  Constants.h
//  VideoAcc
//
//  Created by Ibrar on 26/12/2013.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject


#define kKeychainItemName @"VideoAcc: YouTube"
#define kClientID @"842866038343-47la1csp547lkqrj8p4qurvf4eu17t4q.apps.googleusercontent.com"
#define kClientSecret     @"HrYpau6bJEhBGZJ8P_Co1bu1"
#define kYoutubeDeveloperKey (@"")

//AIzaSyAouRC1EUnk1vxE_H43E5kNj4sPObVNNBI

//#define kClientID @"842866038343-0187tp7jjijkkueecbh61ugjhbcc48rf.apps.googleusercontent.com"
//#define kClientSecret @"vGjEKmQJBr1AjSpc_VM_pzg5"


#define kInteresting        @"Interesting"
#define kMostPopular        @"Most Popular"
#define kFavorites          @"Favorites"
#define kChannels           @"Channels"
#define kPlaylists          @"Playlists"
#define kHistory            @"History"
#define kDownloadedContent  @"Downloaded Content"
#define kSettings           @"Settings"

#define kYoutubeUrl         @"http://www.youtube.com/watch?v="
#define kYoutubeGetVideoInfo @"http://www.youtube.com/get_video_info?video_id=%@&el=detailpage"

#define kUrlEncodedFmtStreamMap @"url_encoded_fmt_stream_map="

#define kLogIn  @"Log In"
#define kLogOut @"Log Out"

#define kMainViewController @"MainViewController"

#define kApiYoutubeVideoList    @"https://www.googleapis.com/youtube/v3/videos?part=contentDetails,statistics&id="

#define kCompleted  @"completed"
#define kInComplete @"in_complete"

#define C_NO  @"NO"
#define C_YES @"YES"
#define C_NEUTRAL @"Neutral"


@end
