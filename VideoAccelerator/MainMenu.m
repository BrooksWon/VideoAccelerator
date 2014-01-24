//
//  MainMenu.m
//  VideoAcc
//
//  Created by Ibrar on 26/12/2013.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import "MainMenu.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMOAuth2Authentication.h"
#import "DVModalAuthViewController.h"
#import "MainViewController.h"

enum {
    kRow1 = 1,
    kRow2,
    kRow3,
    kRow4,
    kRow5,
    kRow6,
    kRow7,
    kRow8
};

@interface MainMenu ()



@end

@implementation MainMenu

- (void)viewDidLoad{
    [super viewDidLoad];
    tableItems = [[NSArray alloc] initWithObjects: kInteresting, kMostPopular, kFavorites, kChannels, kPlaylists, kHistory, kDownloadedContent, kSettings, nil];
    
    GTMOAuth2Authentication *auth;
    auth = [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                                 clientID:kClientID
                                                             clientSecret:kClientSecret];
    
    self.youtubeService.authorizer = auth;
    
    if(self.isSignedIn){
        [_logButtonO setTitle:kLogOut forState:UIControlStateNormal];
        [self getUserChannel];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (GTLServiceYouTube *)youtubeService{
    
    NSLog(@"youtubeService");
    
    if (!_youtubeService) {
        _youtubeService = [[GTLServiceYouTube alloc] init];
        _youtubeService.retryEnabled = YES;
        _youtubeService.APIKey = kYoutubeDeveloperKey;
    }
    return _youtubeService;
}

- (void)setCurrentUserChannel:(GTLYouTubeChannel *)currentUserChannel{
    _currentUserChannel = currentUserChannel;
    NSLog(@"setUserChannel");
    if (currentUserChannel) {
//        MainViewController *mainViewController = (MainViewController*)self.revealController.frontViewController;
//        [mainViewController getMostPopularOnCompletion:NULL];
    }
}

-(void)updateUI{
    NSString *channelUrl = _currentUserChannel.snippet.thumbnails.defaultProperty.url;
    [_channelTitle setText:_currentUserChannel.snippet.title];
    [_channelImage setImageWithURL:[NSURL URLWithString:channelUrl]
                  placeholderImage:[UIImage imageNamed:@"image_default.png"]
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                             if(error){
                                 [_channelImage setImage:[UIImage imageNamed:@"img_not.png"]];
                             }
                         } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)getUserChannel{
    
    NSLog(@"getUserChannel");
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading";
    GTLQueryYouTube *videoQuery = [GTLQueryYouTube queryForChannelsListWithPart:@"id, snippet, contentDetails"];
    
    videoQuery.mine = YES;
    
    [self.youtubeService executeQuery:videoQuery
                    completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeChannelListResponse *object, NSError *error) {
                        self.currentUserChannel = object.items.lastObject;
                        
                        
                        
                        if(_currentUserChannel){
                            NSLog(@"_currentUserChannel: YES");
                            MainViewController *mainViewController = (MainViewController*)self.revealController.frontViewController;
                            [mainViewController getMostPopularOnCompletion:NULL];
                            [self updateUI];
                        }else{
                            NSLog(@"_currentUserChannel: NO" );
                        }
                        [hud hide:YES];
                        hud = nil;
                    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [tableItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    int row = indexPath.row;
    
    NSString *frontViewControllerClass = NSStringFromClass([self.revealController.frontViewController class]);
    NSLog(@"Front Class : %@", frontViewControllerClass);
    switch (row) {
        case kRow1:{
            if([frontViewControllerClass isEqualToString: kMainViewController]){
                MainViewController *mainViewController = (MainViewController*)self.revealController.frontViewController;
                [mainViewController getMostPopularOnCompletion:NULL];
                [self.revealController showViewController:self.revealController.frontViewController animated:YES completion:nil];
            }else{
                
            }
            break;
        }
        case kRow2:{
            
            break;
        }
        case kRow3:{
            
            break;
        }
        case kRow4:{
            
            break;
        }
        case kRow5:{
            
            break;
        }
        case kRow6:{
            
            break;
        }
        case kRow7:{
            
            break;
        }
        case kRow8:{
            
            break;
        }
        default:
            break;
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (IBAction)logButton:(id)sender {
    
    if (![self isSignedIn]) {
        [self authUserIfNeeded];
    }
    else {
        [GTMOAuth2ViewControllerTouch removeAuthFromKeychainForName:kKeychainItemName];
        self.youtubeService.authorizer = nil;
        [self.logButtonO setTitle:kLogIn forState:UIControlStateNormal];
        self.currentUserChannel = nil;
        //        self.gotChannel = NO;
        //        [self updateUI];
        [self.channelTitle setText:@""];
        [self.channelImage setImage:[UIImage imageNamed:@"thumbnail.png"]];
    }
    
}

- (NSString *)signedInUsername
{
    GTMOAuth2Authentication *auth = self.youtubeService.authorizer;
    BOOL isSignedIn = auth.canAuthorize;
    if (isSignedIn) {
        return auth.userEmail;
    } else {
        return nil;
    }
}

- (BOOL)isSignedIn {
    NSString *name = [self signedInUsername];
    return (name != nil);
}

- (void)authUserIfNeeded{
    
    
    if (self.isSignedIn) {
        [self getUserChannel];
        return;
    }

    DVModalAuthViewController *authViewController = [[DVModalAuthViewController alloc] initWithScope:kGTLAuthScopeYouTube
                                                                                            clientID:kClientID
                                                                                        clientSecret:kClientSecret
                                                                                    keychainItemName:kKeychainItemName
                    completionHandler:^(GTMOAuth2ViewControllerTouch *viewController, GTMOAuth2Authentication *auth, NSError *error) {
                                                                                       
                                if (!error) {

                                    self.youtubeService.authorizer = auth;
                                    [self.logButtonO setTitle:@"Log out" forState:UIControlStateNormal];
                                  [self getUserChannel];
                                }
                                else {
                                    self.youtubeService.authorizer = nil;
                                    NSLog(@"Authentication error: %@", error);
                                    NSData *responseData = [[error userInfo] objectForKey:@"data"]; // kGTMHTTPFetcherStatusDataKey
                                    if ([responseData length] > 0) {
                                         // show the body of the server's authentication failure response
                                         NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                         NSLog(@"str : %@", str);
                                    }
                    }

     }];
    
    NSString *html = @"<html><body bgcolor=white><div align=center>Loading sign-in page...</div></body></html>";
    authViewController.initialHTMLString = html;
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:authViewController] animated:YES completion:NULL];

}

@end
