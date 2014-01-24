//
//  MainMenu.h
//  VideoAcc
//
//  Created by Ibrar on 26/12/2013.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"



@interface MainMenu : UIViewController{
     MBProgressHUD *hud;
    NSArray *tableItems;
    
}

@property (nonatomic, strong) GTLServiceYouTube *youtubeService;
@property (nonatomic, strong) GTLYouTubeChannel *currentUserChannel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)logButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *logButtonO;
@property (weak, nonatomic) IBOutlet UIImageView *channelImage;
@property (weak, nonatomic) IBOutlet UILabel *channelTitle;

@end
