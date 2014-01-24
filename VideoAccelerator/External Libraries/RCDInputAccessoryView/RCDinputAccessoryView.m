//
//  RCDinputAccessoryView.m
//  textInputViewDemo
//
//  Created by Razib Chandra Deb on 1/28/13.
//  Copyright (c) 2013 RazibDeb. All rights reserved.
//

#import "RCDinputAccessoryView.h"

@implementation RCDinputAccessoryView
@synthesize inputToolBar;
@synthesize doneButton;
- (id)initWithTextField:(UITextField*)textField
{
    self = [super initWithFrame:CGRectMake(0, 250, 320, 40)];
    if (self) {
        
        myTextField=textField;
        inputToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        doneButton= [[UIBarButtonItem alloc]
                     initWithTitle:@"DONE"
                     style:UIBarButtonItemStyleDone
                     target:self
                     action:@selector(performdone:)]
                    ;
        
        inputToolBar.barStyle=UIBarStyleDefault;
        UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [inputToolBar setItems:[NSArray arrayWithObjects:flexSpace,doneButton,Nil] animated:NO];
        [self addSubview:inputToolBar];
    }
    return self;
}

- (id)initWithTextView:(UITextView*)textView
{
    self = [super initWithFrame:CGRectMake(0, 250, 320, 40)];
    if (self) {
        
        myTextView=textView;
        inputToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        doneButton= [[UIBarButtonItem alloc]
                      initWithTitle:@"DONE"
                      style:UIBarButtonItemStyleDone
                      target:self
                      action:@selector(performdone:)]
                     ;
        
        inputToolBar.barStyle=UIBarStyleDefault;
        UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        [inputToolBar setItems:[NSArray arrayWithObjects:flexSpace,doneButton,Nil] animated:NO];
        [self addSubview:inputToolBar];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)performdone:(id)sender
{
    NSLog(@"done clicked");
    [myTextField resignFirstResponder];
    [myTextView resignFirstResponder];
}

@end
