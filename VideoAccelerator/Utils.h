//
//  Utils.h
//  Story
//
//  Created by Ibrar on 5/24/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>





@interface Utils : NSObject

+(void)setDoneButtonOnTextField:(UITextField *)textField;
+(void)setDoneButtonOnTextView:(UITextView *)textView;
+(void)setPadding:(UITextField*)textField;
+(BOOL)is7;
+(BOOL)isPad;
+(NSString *)trimString:(NSString *)temp;
+(void)setKeyValuePairWithKey:(NSString *)key andValue:(id)value;
+(id)getValueForKey:(NSString *)key;
+(void)highlightField:(UITextField*)textField;
+(void)unHighlightField:(UITextField*)textField;
+(BOOL)isEmpty:(NSString *)stringObject;
+(BOOL)isDate:(NSDate *)date1 GreaterThan:(NSDate *)date2;
+(BOOL)isPastDate:(NSDate *)selectedDate;

+(void)showDialogWithTitle:(NSString *)title message:(NSString *)msg;
+(NSString*)getCurrentDateTime;
+(NSString*)parseDurarion:(NSString*)duration;
+(NSString*)getTime:(NSString*)duration Range:(NSRange)range;
+(NSString*)parseBublishDate:(NSString*)publishDate;
+(NSDate*)youtubeDate:(NSString*)rawDate;
+(BOOL)isToday:(NSDate*)youtubedate;
+(BOOL)isDate:(NSDate*)youtubeDate Between:(NSDate*)startDate AND :(NSDate*)endDate;
+(NSArray*)getFirstAndLastDateOfPreviousMonth;
+(NSArray*)getFirstAndLastDateOfPreviousWeek;

+(NSString*)getFilePath:(NSString*)videoID;
+(BOOL)isFileExists:(NSString*)videoID;
+(NSUInteger)getDownloadedBytes:(NSString*)videoID;

@end
