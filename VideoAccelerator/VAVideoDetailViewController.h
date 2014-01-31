//
//  VAVideoDetailViewController.h
//  VideoAccelerator
//
//  Created by Alefsys on 30/01/2014.
//  Copyright (c) 2014 Alefsys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VideoPlayerKit/VideoPlayerKit.h>

@interface VAVideoDetailViewController : UIViewController<VideoPlayerDelegate>{
    NSString *currentVideoID;
}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *VideoPlayerView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *threeSegmentsControl;
@property (nonatomic, strong) VideoPlayerKit *videoPlayerViewController;
@property (nonatomic, strong) NSString *currentVideoID;

@end
