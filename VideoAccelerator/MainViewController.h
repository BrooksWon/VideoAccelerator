//
//  MainViewController.h
//  VideoAcc
//
//  Created by Asif on 12/24/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MainMenu.h"
#import <VideoPlayerKit/VideoPlayerKit.h>
#import "VAVideoDetailViewController.h"

@interface MainViewController : UIViewController<VideoPlayerDelegate, UITextFieldDelegate, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>{
    MBProgressHUD *hud;
    MainMenu *_menu;
    NSMutableDictionary *channelImageLinks;
    int playingIndex;
    NSIndexPath *playingIndexPath;
    NSString *nextPageToken;
    BOOL mostPopularFlag;
    NSMutableData *mutData;
    NSString *currentVideoID;
    NSString *isDataSaved;
    BOOL synchronzed;
    
}
- (IBAction)menuButton:(id)sender;
@property (nonatomic, strong) NSURLConnection *downloadingConnection;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) VideoPlayerKit *videoPlayerViewController;
@property (weak, nonatomic) IBOutlet UIButton *searchIcon;
- (void)getMostPopularOnCompletion:(void (^)(void))completion;
- (IBAction)searchOverlayButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)filterSegment:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *filterSegmentO;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (assign, nonatomic) CGPoint lastContentOffset;


@end
