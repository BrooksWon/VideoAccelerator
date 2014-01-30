//
//  VAViewController.m
//  VideoAccelerator
//
//  Created by Alefsys on 24/01/2014.
//  Copyright (c) 2014 Alefsys. All rights reserved.
//

#import "VAViewController.h"
#import "MainViewController.h"
#import "MainMenu.h"

@interface VAViewController ()

@end

@implementation VAViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    //    NSLog(@"going to present...................... in view did load");
	MainViewController *vaHome = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    MainMenu *mainMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenu"];
    
    self.revealController = [PKRevealController revealControllerWithFrontViewController:vaHome leftViewController:mainMenu];
    self.revealController.delegate = self;
    self.revealController.animationDuration = 0.25;
    [self.navigationController pushViewController:self.revealController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
