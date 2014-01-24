//
//  getDictionaryFormURL.h
//  Nayliner
//
//  Created by Alefsys on 7/26/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface getDictionaryFormURL : NSDictionary

@property (nonatomic, strong) NSDictionary *fetchedResult;
-(NSDictionary*)getDictionaryFormURL:(NSString *)urlString;


@end
