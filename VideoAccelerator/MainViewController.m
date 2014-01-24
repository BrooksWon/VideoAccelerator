//
//  MainViewController.m
//  VideoAcc
//
//  Created by Asif on 12/24/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import "MainViewController.h"
#import <objc/message.h>
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2Authentication.h"
#import "DVModalAuthViewController.h"
#import "UIImageView+AFNetworking.h"
#import "VAViewController.h"
#import "getDictionaryFormURL.h"


enum{
    eCompleted,
    eInComplete
};

@class GTLQueryYouTube;

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *mostPopularVideos;
@property (nonatomic, strong) NSMutableArray *mostPopularVideosOriginal;
@property (nonatomic, strong) NSMutableArray *searchVideos;
@property (nonatomic, strong) NSMutableArray *searchVideosOriginal;
@property (nonatomic, strong) NSArray *searchVideosDetails;

@end

@implementation MainViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    isDataSaved = C_NEUTRAL;
    [_searchField setFrame:CGRectMake(286, _searchField.frame.origin.y, _searchField.frame.size.width, _searchField.frame.size.height)];
    [Utils setPadding:_searchField];
    
    _searchField.delegate = self;
    _mostPopularVideos =[[NSMutableArray alloc] init];
    [self.revealController.navigationController setNavigationBarHidden:YES];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    playingIndex = -1;
    channelImageLinks = [[NSMutableDictionary alloc] init];
    
//    GTMOAuth2Authentication *auth;
//    auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
//                                                                 clientID:kClientID
//                                                             clientSecret:kClientSecret];
    
    _menu = (MainMenu*)self.revealController.leftViewController;
	
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(void) detectOrientation {
    
}

-(NSUInteger)supportedInterfaceOrientations{
    //make the check for iphone/ipad here
   return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    if(interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    
    return NO;
}

//-(BOOL)shouldAutorotate{
//    
//    NSLog(@"shouldAutorotate");
//    [super shouldAutorotate];
//    return NO;
//}

-(void)xtractVideoLink:(UITableViewCell*)cell{
    if(synchronzed){
        return;
    }
    
    synchronzed = YES;
    NSString* urlStr = [NSString stringWithFormat:kYoutubeGetVideoInfo, currentVideoID];
    NSLog(@"video urlStr: %@", urlStr );
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        if (downloadedData) {
//            NSLog(@"downloadedData : %@", downloadedData );
            
            NSString *videoInfo = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
            
//            NSLog(@"videoInfo : %@", videoInfo );
            
            NSArray *totalParameters = [videoInfo componentsSeparatedByString:@"&"];
            NSString *fmt_parameter;
            for (int i =0; i< totalParameters.count; i++) {
                fmt_parameter = [totalParameters objectAtIndex:i];
                if([fmt_parameter rangeOfString:kUrlEncodedFmtStreamMap].location != NSNotFound){
                    fmt_parameter = [fmt_parameter stringByReplacingOccurrencesOfString:kUrlEncodedFmtStreamMap withString:@""];
                    break;
                }
            }
            
            fmt_parameter = [fmt_parameter stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSArray *all_links = [fmt_parameter componentsSeparatedByString:@","];
            
//            NSLog(@"all_links 0 : %@", [all_links objectAtIndex:0]);
            
            NSArray *singleLink = [[all_links objectAtIndex:0] componentsSeparatedByString:@"&"];
            
            NSString *url;
            NSString *signature;
            
            for (int i =0; i< singleLink.count; i++) {
                NSString *link_parameter = [singleLink objectAtIndex:i];
                if([link_parameter rangeOfString:@"url="].location != NSNotFound){
                    url = [link_parameter stringByReplacingOccurrencesOfString:@"url=" withString:@""];
                    url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }else if([link_parameter rangeOfString:@"sig="].location != NSNotFound){
                    signature = [link_parameter stringByReplacingOccurrencesOfString:@"sig=" withString:@"signature="];
                }
            }
            
            NSString *finalLink = [NSString stringWithFormat:@"%@&%@", url, signature];
            
            NSLog(@"finalLink : %@", finalLink);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playVideo:[NSURL URLWithString:finalLink] :cell ];
                [self downloadVideoWithURL:[NSURL URLWithString:finalLink]];
            });
        }
    });
}

-(void)downloadVideoWithURL:(NSURL*)url{
    
    mutData = [[NSMutableData alloc] init];
    
    NSUInteger downloadedBytes = 0 ;
    
    if([Utils isFileExists:currentVideoID]){
        downloadedBytes = [Utils getDownloadedBytes:currentVideoID];
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    if (downloadedBytes > 0) {
        NSString *requestRange = [NSString stringWithFormat:@"bytes=%d-", downloadedBytes];
        [req setValue:requestRange forHTTPHeaderField:@"Range"];
    }
    
    if (![NSURLConnection canHandleRequest:req]) {
        NSLog(@"Cannot Handle Request");
    }else{
        NSURLConnection *conn = [NSURLConnection connectionWithRequest:req delegate:self];
        _downloadingConnection = conn;
        [conn start];
    }
    
    synchronzed = NO;
}

//-(void)download:(NSString*) videoId :(NSString *)urlStr{
////    NSCache *memoryCache = [[NSCache alloc] init];
//
//    urlStr = [urlStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"%@", urlStr);
////    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//       
//        NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            NSLog(@"downloadedData back: %@", downloadedData );
//            if (downloadedData) {
//                NSLog(@"downloadedData back: %@", downloadedData );
//                
//                NSString* cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                NSString *file = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4v", videoId] ];
//                [downloadedData writeToFile:file atomically:YES];
//                //            [memoryCache setObject:downloadedData forKey:videoId];
//            }
//        });
//        
//       
//    });
//}

-(void)playVideo:(NSURL*)url :(UITableViewCell*) cell{

    UIImageView *preview = (UIImageView*) [cell viewWithTag:1];
 
    if (!self.videoPlayerViewController) {
        self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingView:cell.contentView optionalTopView:nil hideTopViewWithControls:YES];
        // Need to set edge inset if top view is inserted
//        [self.videoPlayerViewController setControlsEdgeInsets:UIEdgeInsetsMake(self.topView.frame.size.height, 0, 0, 0)];
        self.videoPlayerViewController.delegate = self;
        self.videoPlayerViewController.allowPortraitFullscreen = NO;
    }
    [cell.contentView addSubview:self.videoPlayerViewController.view];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self.videoPlayerViewController playVideoWithTitle:@"Title" asset:asset videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(tableView.tag == 0){
        NSLog(@"_mostPopularVideos.count numberOfRowsInSection: %d", _mostPopularVideos.count);
        return _mostPopularVideos.count;
    }
    NSLog(@"_searchVideos.count numberOfRowsInSection: %d", _searchVideos.count);
    return _searchVideos.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell;
    static NSString *identifier = @"Video-Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath] ;

    __weak UIImageView *preview = (UIImageView*) [cell viewWithTag:1];
    UILabel *name = (UILabel*) [cell viewWithTag:2];
    UILabel *channelName = (UILabel*) [cell viewWithTag:3];
    UILabel *views = (UILabel*) [cell viewWithTag:4];
    UILabel *uploadTime = (UILabel*) [cell viewWithTag:5];
    __weak UIImageView *channelImage = (UIImageView*) [cell viewWithTag:6];
    UILabel *duration = (UILabel*) [cell viewWithTag:8];
    
    UIImageView *cachedMarker = (UIImageView*) [cell viewWithTag:10];
    

    GTLYouTubeVideo *video;
    GTLYouTubeSearchResult *searchVideo;
    
    NSURL *imageURL;
    NSString *channelURL;
    
    NSString *videoID;
    
//    NSLog(@"tableView.tag : %d", tableView.tag);
    if(tableView.tag == 0){
        video = self.mostPopularVideos[indexPath.row];
        videoID = video.identifier;
        imageURL = [NSURL URLWithString:video.snippet.thumbnails.medium.url]; 
        [name setText:video.snippet.title];
        [channelName setText:video.snippet.channelTitle];
        [views setText:[NSString stringWithFormat:@"%@ Views" , video.statistics.viewCount]];
        [duration setText: [Utils parseDurarion:video.contentDetails.duration] ];
        channelURL = [channelImageLinks objectForKey:video.snippet.channelId];
        
        NSString *time = [Utils parseBublishDate: video.snippet.publishedAt.stringValue];
//        NSLog(@"Time Uploaded : %@", video.snippet.publishedAt.stringValue);
        [uploadTime setText:time];
    }else{
        searchVideo = self.searchVideos[indexPath.row];
        videoID = [searchVideo.identifier.JSON objectForKey:@"videoId"];
        [preview setImage:nil];
        imageURL = [NSURL URLWithString:searchVideo.snippet.thumbnails.medium.url];
        [name setText: @"" ];
        [name setText:searchVideo.snippet.title];
        [channelName setText: @"" ];
        [channelName setText:searchVideo.snippet.channelTitle];
        NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"id=%@", [searchVideo.identifier.JSON objectForKey:@"videoId"]];
        NSArray *filtered = [_searchVideosDetails filteredArrayUsingPredicate:idPredicate];
    
        if(filtered.count > 0){
            NSDictionary *contentDetails = [[filtered firstObject] objectForKey:@"contentDetails"];
            NSDictionary *statistics = [[filtered firstObject] objectForKey:@"statistics"];
            [duration setText: @"" ];
            [duration setText:[Utils parseDurarion:[contentDetails valueForKey:@"duration"]]];
            [views setText: @"" ];
            [views setText:[NSString stringWithFormat:@"%@ Views" , [statistics valueForKey:@"viewCount"]]];
        }
        
        [channelImage setImage:nil];
        channelURL = [channelImageLinks objectForKey:searchVideo.snippet.channelId];
        
        [uploadTime setText:[Utils parseBublishDate: searchVideo.snippet.publishedAt.stringValue]];
    }
    
    NSString *status = [Utils getValueForKey:[NSString stringWithFormat:@"%@.mp4", videoID]];
    
    if(status != nil && [status isEqualToString:kCompleted]){
        [cachedMarker setHidden:NO];
    }else{
        [cachedMarker setHidden:YES];
    }
    
    [preview setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *playVideo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playYouTubeVideo:)];
    [playVideo setNumberOfTapsRequired:1];
    
    NSString *indexPathStr = [NSString stringWithFormat:@"%ld:%ld", (long)indexPath.section, (long)indexPath.row];
    [playVideo setAccessibilityLabel:indexPathStr];
    [preview addGestureRecognizer:playVideo];
    
    if(imageURL){
        [preview setImageWithURL:imageURL
                placeholderImage:[UIImage imageNamed:@"image_default.png"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           
                           if(error){
                               [preview setImage:[UIImage imageNamed:@"img_not.png"]];
                           }
                           
                       } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }else{
        [preview setImage:[UIImage imageNamed:@"img_not.png"]];
    }
    
    [channelImage setImageWithURL:[NSURL URLWithString:channelURL]
                placeholderImage:[UIImage imageNamed:@"image_default.png"]
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           
                           if(error){
                               [channelImage setImage:[UIImage imageNamed:@"img_not.png"]];
                           }
                           
                       } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    if(indexPath.row!= playingIndex){

        NSArray *subviews = [cell.contentView subviews];
        for (UIView *view in subviews){
            NSString *viewClass = [NSString stringWithFormat:@"%@", [view class]];
            if([viewClass isEqualToString:@"MPMovieView"]){
                [view setHidden:YES];
            }
        }
    }else{
        [_videoPlayerViewController.view setHidden:NO];
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == _mostPopularVideos.count -1 && !mostPopularFlag){
//        NSLog(@"LAst Row");
//        if(nextPageToken){
//            [self getMostPopularOnCompletion:NULL];
//        }
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void) playYouTubeVideo: (UITapGestureRecognizer *)recognizer{
    
    NSLog(@"isDataSaved : %@", isDataSaved);
    
    if([isDataSaved isEqualToString:C_NO]){
        [_downloadingConnection cancel];
        [self saveData:eInComplete];
    }
    
    [_mainTableView deselectRowAtIndexPath:playingIndexPath animated:YES];
    
    NSArray *tmp = [recognizer.accessibilityLabel componentsSeparatedByString:@":"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tmp[1] integerValue] inSection:[tmp[0] integerValue]];

    UITableViewCell *cell = [_mainTableView cellForRowAtIndexPath:indexPath];
    GTLYouTubeVideo *video;
    GTLYouTubeSearchResult *searchVideo;
    NSString *videoID;
    if(_mainTableView.tag == 0){
        video = self.mostPopularVideos[indexPath.row];
        videoID = video.identifier;
    }else{
        searchVideo = self.searchVideos[indexPath.row];
        videoID = [searchVideo.identifier.JSON objectForKey:@"videoId"];
    }
    
    NSLog(@"video.identifier : %@", videoID);

    UITableViewCell *previousCell = [_mainTableView cellForRowAtIndexPath:playingIndexPath];
    NSArray *subviews = [previousCell.contentView subviews];
    for (UIView *view in subviews){
        NSString *viewClass = [NSString stringWithFormat:@"%@", [view class]];
        if([viewClass isEqualToString:@"MPMovieView"]){
            
            [view removeFromSuperview];
            _videoPlayerViewController = nil;
        }
    }

    playingIndexPath = indexPath;
    playingIndex = indexPath.row;
    currentVideoID = videoID;
    
    [_mainTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [self handleVideoPlaying:cell];
}

-(void)handleVideoPlaying:(UITableViewCell*)cell{

    NSString *videoStatus = [Utils getValueForKey:[NSString stringWithFormat:@"%@.mp4", currentVideoID]];
    if(videoStatus){
        if([videoStatus isEqualToString:kCompleted]){
            // play video offline
            NSLog(@"kCompleted");
            isDataSaved = C_YES;
            [self playVideo:[NSURL fileURLWithPath:[Utils getFilePath:currentVideoID]] :cell];
        }else{
            // extract video link, play online and resume download
            NSLog(@"kInComplete");
            isDataSaved = C_NO;
            [self xtractVideoLink:cell];
        }
    }else{
        // extract video link, play online and start download it also
        NSLog(@"download first time");
        isDataSaved = C_NO;
        [self xtractVideoLink:cell];
        
    }
    
}

- (void)updateUI{

    [_mainTableView reloadData];
}

- (void)getMostPopularOnCompletion:(void (^)(void))completion{
    mostPopularFlag = YES;
    hud = [MBProgressHUD showHUDAddedTo:self.revealController.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    
    GTLQueryYouTube *videoQuery = [GTLQueryYouTube queryForPlaylistItemsListWithPart:@"id, snippet, contentDetails, statistics" Chart:@"mostPopular"];
    
    videoQuery.maxResults = 50;
//    if(nextPageToken){
//        videoQuery.pageToken = nextPageToken;
//    }
    
    
    [_menu.youtubeService executeQuery:videoQuery
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeVideoListResponse *object, NSError *error) {
                        _mostPopularVideos = [object.items mutableCopy];
                        _mostPopularVideosOriginal = [object.items mutableCopy];
//                        [_mostPopularVideos addObjectsFromArray:object.items];
                        [_filterSegmentO setSelectedSegmentIndex:0];
                        [_mainTableView setAccessibilityHint:@"0"];
                        
                        [hud hide:YES];
                        hud=nil;
                        
                        [_mainTableView setTag:0];
                        [_mainTableView reloadData];
                        
//                        nextPageToken =  object.nextPageToken;
                        
                        for (int i = 0; i < object.items.count; i++) {
                            GTLYouTubeVideo *video = object.items[i];
                            [self getChannelImage:video.snippet.channelId];
                        }
                        
                        NSLog(@"mostPopularVideos.count: %d", _mostPopularVideos.count);

                        
//                        mostPopularFlag = NO;
                        
                        if (completion){
                            completion();
                        }
                        
                    }];
    
}

- (void)getSearchOnCompletion:(void (^)(void))completion :(NSString*)q{
    
    if(![_menu.youtubeService.authorizer canAuthorize]){
        return;
    }
    
    [_mostPopularVideos removeAllObjects];
    [_mainTableView reloadData];
    
    if(_videoPlayerViewController){
        [_videoPlayerViewController.view removeFromSuperview];
        _videoPlayerViewController = nil;
    }
    
    GTLQueryYouTube *videoQuery = [GTLQueryYouTube queryForSearchListWithPart:@"id, snippet" :q];
    
    videoQuery.maxResults = 50;


    [_menu.youtubeService executeQuery:videoQuery
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeSearchListResponse *object, NSError *error) {
                        _searchVideos = [object.items mutableCopy];
                        
                        _searchVideosOriginal = [object.items mutableCopy];
                        
                        [_filterSegmentO setSelectedSegmentIndex:0];
                        [_mainTableView setAccessibilityHint:@"0"];
                        
                        NSString *allIDs = @"";
                        
                        NSMutableArray *searchVideos = [[NSMutableArray alloc] initWithArray:_searchVideos];
                        
                        for (GTLYouTubeSearchResult *result in _searchVideos ) {
                           
                            NSString *identifier = [result.identifier.JSON objectForKey:@"videoId"];
                            NSLog(@"ID : %@", identifier);
                            if(identifier){
                                allIDs = [NSString stringWithFormat:@"%@%@,", allIDs, identifier];
                                [self getChannelImage:result.snippet.channelId];
                            }else{
                                [searchVideos removeObject:result];
                            }
                        }
                        
                        [_searchVideos removeAllObjects];
                        [_searchVideos addObjectsFromArray:searchVideos];
                        
//                        NSLog(@"_searchVideos  :--_--: _searchVideosCount : %d", _searchVideos.count);
                        
                        [_mainTableView setTag:1];
                        [_mainTableView reloadData];
                        
                        allIDs = [allIDs stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
                        
//                        NSLog(@"allIDs : %@", allIDs);
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                            // Background work
                            NSString *urlStr = [NSString stringWithFormat:@"%@", kApiYoutubeVideoList];
                            
                            urlStr = [NSString stringWithFormat:@"%@%@&key=%@", urlStr, allIDs, @"AIzaSyAMy-6HFKz8q1LTyUCi3h1Iuk5DMp7LG-k"];
                            
                            
                            NSDictionary *fetchResult = [[getDictionaryFormURL alloc] getDictionaryFormURL:urlStr];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                // Update UI
//                                NSLog(@"Fetch Result : %@",fetchResult);
                                
                                _searchVideosDetails = [fetchResult objectForKey:@"items"];
//                                NSLog(@"totalItems[0] : %@", _searchVideosDetails[0]);
                                
                                [_mainTableView reloadData];
                                
                            });
                            
                        });
                        
                        if (completion){
                            completion();
                        }
                        
                    }];
    
}

- (IBAction)searchOverlayButton:(id)sender {
    
    if([Utils isEmpty:_searchField.text] ){
        int originX;
        float alpha;
        if(_searchField.tag == 0){
            [_searchField setTag:1];
            originX = 78;
            alpha = 1;
        }else{
            [_searchField setTag:0];
            originX = 286;
            alpha = 0;
        }
        
        [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [_searchField setFrame:CGRectMake(originX, _searchField.frame.origin.y, _searchField.frame.size.width, _searchField.frame.size.height)];
            [_searchField setAlpha:alpha];
        } completion:^(BOOL fin) {
            if (fin){
            }
            
        }];
        
    }else{
        [self getSearchOnCompletion:NULL :_searchField.text];
    }
    
}

-(void)getChannelImage:(NSString*)channelID{
    __block NSString *channelUrl;
    
    GTLQueryYouTube *videoQuery = [GTLQueryYouTube queryForChannelWithPart:@"snippet" ID:channelID];
    
    [_menu.youtubeService executeQuery:videoQuery
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse *object, NSError *error) {
                        GTLYouTubeChannel *userChannel = object.items.lastObject;
                        channelUrl =  userChannel.snippet.thumbnails.defaultProperty.url;
                        
//                        NSLog(@"key : %@ --- object : %@", channelID, channelUrl);
                        if(channelUrl){
                            [channelImageLinks setObject:channelUrl forKey:channelID];
                        }
                        
                    }];
}

- (IBAction)menuButton:(id)sender {
    [self.revealController showViewController:self.revealController.leftViewController];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)filterSegment:(id)sender {
    int selectedIndex = _filterSegmentO.selectedSegmentIndex;
    
    [self filterListWithTag:selectedIndex];
    [_mainTableView reloadData];

}

-(void)filterListWithTag:(int)tag{
    if(_mainTableView.tag == 0){
        
        [_mostPopularVideos removeAllObjects];
        [_mostPopularVideos addObjectsFromArray:_mostPopularVideosOriginal];
        
        NSLog(@"_mostPopularVideosOriginal count: %d", _mostPopularVideosOriginal.count);
        NSLog(@"_mostPopularVideos count: %d", _mostPopularVideos.count);
        
        
        for( GTLYouTubeVideo *video in _mostPopularVideosOriginal){
            NSDate *publishedDate = [Utils youtubeDate:video.snippet.publishedAt.stringValue];
            NSArray *rangeOfDates;
            switch (tag) {
                case 0:{
                    NSLog(@"selectedIndex : 0");
                    return;
                    break;
                }
                case 1:{
                    NSLog(@"selectedIndex : 1");
                    if(![Utils isToday:publishedDate]){
                        [_mostPopularVideos removeObject:video];
                    }
                    break;
                }
                    
                case 2:{
                    NSLog(@"selectedIndex : 2");
                    rangeOfDates = [Utils getFirstAndLastDateOfPreviousWeek];
                    BOOL isLastMonthVideo = [Utils isDate:publishedDate Between:rangeOfDates[0] AND:rangeOfDates[1]];
                    if(!isLastMonthVideo){
                        [_mostPopularVideos removeObject:video];
                    }
                    break;
                }
                    
                case 3:{
                    NSLog(@"selectedIndex : 3");
                    rangeOfDates = [Utils getFirstAndLastDateOfPreviousMonth];
                    BOOL isLastMonthVideo = [Utils isDate:publishedDate Between:rangeOfDates[0] AND:rangeOfDates[1]];
                    if(!isLastMonthVideo){
                        [_mostPopularVideos removeObject:video];
                    }
                    break;
                }
                default:
                    break;
            }
            
        }
        
    }else{
        
        [_searchVideos removeAllObjects];
        [_searchVideos addObjectsFromArray:_searchVideosOriginal];
        
        NSLog(@"_mostPopularVideosOriginal count: %d", _mostPopularVideosOriginal.count);
        NSLog(@"_mostPopularVideos count: %d", _mostPopularVideos.count);
        
        for( GTLYouTubeSearchResult *searchVideo in _searchVideosOriginal){
            NSDate *publishedDate = [Utils youtubeDate:searchVideo.snippet.publishedAt.stringValue];
            NSArray *rangeOfDates;
            switch (tag) {
                case 0:{
                    NSLog(@"selectedIndex : 0");
                    return;
                    break;
                }
                case 1:{
                    NSLog(@"selectedIndex : 1");
                    if(![Utils isToday:publishedDate]){
                        [_searchVideos removeObject:searchVideo];
                    }
                    break;
                }
                    
                case 2:{
                    NSLog(@"selectedIndex : 2");
                    rangeOfDates = [Utils getFirstAndLastDateOfPreviousWeek];
                    BOOL isLastMonthVideo = [Utils isDate:publishedDate Between:rangeOfDates[0] AND:rangeOfDates[1]];
                    if(!isLastMonthVideo){
                        [_searchVideos removeObject:searchVideo];
                    }
                    break;
                }
                    
                case 3:{
                    NSLog(@"selectedIndex : 3");
                    rangeOfDates = [Utils getFirstAndLastDateOfPreviousMonth];
                    BOOL isLastMonthVideo = [Utils isDate:publishedDate Between:rangeOfDates[0] AND:rangeOfDates[1]];
                    if(!isLastMonthVideo){
                        [_searchVideos removeObject:searchVideo];
                    }
                    break;
                }
                default:
                    break;
            }

        }
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint currentOffset = scrollView.contentOffset;
    if (currentOffset.y > self.lastContentOffset.y){
        NSLog(@"Downward"); // filter menu disssapear
        if(!_segmentView.hidden){
            [_segmentView setHidden:YES];
        }
        
    }else{
        NSLog(@"Upward");   // filter menu appears
        if(_segmentView.hidden){
            [_segmentView setHidden:NO];
        }
    }
    _lastContentOffset = currentOffset;
    
}

-(void)saveData:(int)status{
    NSString *filePath = [Utils getFilePath:currentVideoID];
    if([Utils isFileExists:currentVideoID]){
        NSMutableData *previous = [[NSMutableData dataWithContentsOfFile:filePath] mutableCopy];
        [previous appendData:mutData];
        [previous writeToFile:filePath atomically:YES];
    }else{
        [mutData writeToFile:filePath atomically:YES];
    }
    
    isDataSaved = C_YES;
    
    switch (status) {
        case eCompleted:{
            [Utils setKeyValuePairWithKey:[NSString stringWithFormat:@"%@.mp4", currentVideoID] andValue:kCompleted];

            break;
        }
        case eInComplete:{
            [Utils setKeyValuePairWithKey:[NSString stringWithFormat:@"%@.mp4", currentVideoID] andValue:kInComplete];
            break;
        }
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    [self saveData:eCompleted];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData");
    [mutData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"didFailWithError : %@", error);
    _downloadingConnection = nil;
    [self saveData:eInComplete];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"didReceiveResponse");
}


@end
