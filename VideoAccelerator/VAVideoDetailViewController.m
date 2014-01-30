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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)playVideo:(NSURL*)url :(UITableViewCell*) cell{
    
    if (!self.videoPlayerViewController) {
        self.videoPlayerViewController = [VideoPlayerKit videoPlayerWithContainingView:self.VideoPlayerView optionalTopView:nil hideTopViewWithControls:YES];
        self.videoPlayerViewController.delegate = self;
        self.videoPlayerViewController.allowPortraitFullscreen = NO;
    }
    //    [cell.contentView addSubview:mainView];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self.videoPlayerViewController playVideoWithTitle:@"Title" asset:asset videoID:nil shareURL:nil isStreaming:NO playInFullScreen:NO];
    
}
@end
