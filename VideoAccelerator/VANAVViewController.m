//
//  VANAVViewController.m
//  VideoAccelerator
//
//  Created by Alefsys on 28/01/2014.
//  Copyright (c) 2014 Alefsys. All rights reserved.
//

#import "VANAVViewController.h"

@interface VANAVViewController ()

@end

@implementation VANAVViewController

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
- (BOOL)shouldAutorotate {
    NSLog(@"shouldAutorotate");
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    NSLog(@"preferredInterfaceOrientationForPresentation");
    
    return UIInterfaceOrientationPortrait;
}
//ios4 and ios5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    
    return NO;
}
-(NSUInteger)supportedInterfaceOrientations{
    NSLog(@"supportedInterfaceOrientations");
    
    return UIInterfaceOrientationMaskPortrait;
}


@end
