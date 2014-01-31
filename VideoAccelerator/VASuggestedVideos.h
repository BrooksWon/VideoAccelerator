//
//  VASuggestedVideos.h
//  VideoAccelerator
//
//  Created by Alefsys on 31/01/2014.
//  Copyright (c) 2014 Alefsys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VASuggestedVideos : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *suggestedTableView;

@end
