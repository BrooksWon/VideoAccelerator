//
//  RCDinputAccessoryView.h
//  textInputViewDemo
//
//  Created by Razib Chandra Deb on 1/28/13.
//  Copyright (c) 2013 RazibDeb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDinputAccessoryView : UIView
{
    UITextField * myTextField;
    UITextView * myTextView;
}
@property (nonatomic, retain)UIToolbar *inputToolBar;
@property (nonatomic,retain)UIBarButtonItem *doneButton;
- (id)initWithTextField:(UITextField*)textField;
- (id)initWithTextView:(UITextView*)textView;
@end
