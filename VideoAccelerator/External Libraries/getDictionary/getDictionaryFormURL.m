//
//  getDictionaryFormURL.m
//  Nayliner
//
//  Created by Alefsys on 7/26/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import "getDictionaryFormURL.h"

@implementation getDictionaryFormURL
-(NSDictionary*)getDictionaryFormURL:(NSString *)urlString{
    
     NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"%@",url);
    
   
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    _fetchedResult=[[NSDictionary alloc] init];
    if(jsonData != nil)
    {
        NSError *error = nil;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        if (error == nil){
            _fetchedResult=result;
            
        }
    }    
    return _fetchedResult;
}

@end
