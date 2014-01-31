//
//  VAVideoDetailViewController.m
//  VideoAccelerator
//
//  Created by Alefsys on 30/01/2014.
//  Copyright (c) 2014 Alefsys. All rights reserved.
//

#import "VAVideoDetailViewController.h"

@interface VAVideoDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *aboutContainer;
@property (weak, nonatomic) IBOutlet UIView *seggestedContainer;
@property (weak, nonatomic) IBOutlet UIView *commentContainer;

@end

@implementation VAVideoDetailViewController
@synthesize currentVideoID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.VideoPlayerView setFrame:CGRectMake(0, 0, 320, 177)];
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self handleVideoPlaying];
    
}
- (IBAction)selectedSegment:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        NSLog(@"%ld",(long)sender.selectedSegmentIndex);

        [self.aboutContainer setHidden:NO];
        [self.seggestedContainer setHidden:YES];
        [self.commentContainer setHidden:YES];
    }else if (sender.selectedSegmentIndex==1){
        [self.aboutContainer setHidden:YES];
        [self.seggestedContainer setHidden:NO];
        [self.commentContainer setHidden:YES];
    }else if (sender.selectedSegmentIndex==2){
            [self.aboutContainer setHidden:YES];
            [self.seggestedContainer setHidden:YES];
            [self.commentContainer setHidden:NO];    }
}
- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)playVideo:(NSURL*)url{
    if (!self.videoPlayerViewController) {
        NSLog(@"self.VideoPlayerView :%f",self.VideoPlayerView.frame.size.width);
        self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingView:self.VideoPlayerView optionalTopView:nil hideTopViewWithControls:YES];
        self.videoPlayerViewController.delegate = self;
//        self.videoPlayerViewController.allowPortraitFullscreen = NO;
    }
    [self.VideoPlayerView addSubview:self.videoPlayerViewController.view];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self.videoPlayerViewController playVideoWithTitle:@"Title" asset:asset videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
    
}
-(void)handleVideoPlaying{
    NSLog(@"2 .currentVideoID : %@",currentVideoID);

    NSString *videoStatus = [Utils getValueForKey:[NSString stringWithFormat:@"%@.mp4", currentVideoID]];
    if(videoStatus){
        if([videoStatus isEqualToString:kCompleted]){
            // play video offline
            [self playVideo:[NSURL fileURLWithPath:[Utils getFilePath:currentVideoID]]];
        }else{
            // extract video link, play online and resume download
            [self xtractVideoLink];
        }
    }else{
        // extract video link, play online and start download it also
        [self xtractVideoLink];
    }
}
-(void)xtractVideoLink{

    NSString* urlStr = [NSString stringWithFormat:kYoutubeGetVideoInfo, currentVideoID];
    NSLog(@"video urlStr: %@", urlStr );
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *downloadedData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        if (downloadedData) {
            NSString *videoInfo = [[NSString alloc] initWithData:downloadedData encoding:NSUTF8StringEncoding];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self playVideo:[NSURL URLWithString:finalLink]];
//                [self downloadVideoWithURL:[NSURL URLWithString:finalLink]];
            });
        }
    });
}
@end
