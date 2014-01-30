//
//  Utils.m
//  Story
//
//  Created by Ibrar on 5/24/13.
//  Copyright (c) 2013 Alefsys. All rights reserved.
//

#import "Utils.h"
#import "RCDinputAccessoryView.h"
#import "NSDate+PrettyTimestamp.h"



@implementation Utils

- (id) init {
    self = [super init];
    if (self != nil) {
      
    }
    return self;
}


+(void)setDoneButtonOnTextField:(UITextField *)textField{
    RCDinputAccessoryView *myInputAccessoryView=[[RCDinputAccessoryView alloc]initWithTextField: textField];
    [myInputAccessoryView.doneButton setTitle:@"Done"];
    [textField setInputAccessoryView:myInputAccessoryView];
}

+(void)setDoneButtonOnTextView:(UITextView *)textView{
    RCDinputAccessoryView *myInputAccessoryView =[[RCDinputAccessoryView alloc]initWithTextView: textView];
    [myInputAccessoryView.doneButton setTitle:@"Done"];
    [textView setInputAccessoryView:myInputAccessoryView];
}

+(void)setPadding:(UITextField*)textField{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 36)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

+(BOOL)is7{
    NSString *version = [[UIDevice currentDevice] systemVersion];
    int ver = [version intValue];
    if (ver < 7){
//        NSLog(@"iOS Version < 7 work");
        return NO;
    }
//    NSLog(@"iOS Version 7 work");
    return YES;
}

+(BOOL)isPad{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}


+(NSString *)trimString:(NSString *)temp{
    return [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(void)setKeyValuePairWithKey:(NSString *)key andValue:(id)value{
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    [sud setObject:value forKey:key];
}

+(id)getValueForKey:(NSString *)key{
    NSUserDefaults *sud = [NSUserDefaults standardUserDefaults];
    return [sud objectForKey:key];
}



+(void)highlightField:(UITextField*)textField{
    textField.layer.masksToBounds=YES;
    textField.layer.borderWidth= 2.0f;
    textField.layer.borderColor=[[UIColor colorWithRed:169/255.0 green:31/255.0 blue:37/255.0 alpha:1] CGColor];
}

+(void)unHighlightField:(UITextField*)textField{
    textField.layer.masksToBounds = NO;
    textField.layer.borderColor=[[UIColor clearColor]CGColor];
}


+(BOOL)isEmpty:(NSString *)stringObject{
    if(stringObject.length == 0){
        return YES;
    }
    return NO;
}

+(BOOL)isDate:(NSDate *)date1 GreaterThan:(NSDate *)date2{
    NSComparisonResult result = [date2 compare:date1];
    if(result == NSOrderedAscending || result == NSOrderedSame){
        return YES;
    }
    return NO;
}


+(BOOL)isPastDate:(NSDate *)selectedDate{
    
//    NSDateFormatter* df = [[NSDateFormatter alloc] init];
//    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate * today = [NSDate date];

    NSComparisonResult result = [today compare:selectedDate];
    NSLog(@"Selected Date : %@",selectedDate);
    NSLog(@"Today Date : %@",today);
    NSLog(@"\n");
    if(result == NSOrderedDescending){
        return YES;
    }
    return NO;
}


+(void)showDialogWithTitle:(NSString *)title message:(NSString *)msg{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

//+(BOOL) connectedToNetwork{
//	Reachability *r = [Reachability reachabilityWithHostName:@"188.40.135.209"];
//	NetworkStatus internetStatus = [r currentReachabilityStatus];
//	BOOL internet;
//	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
//		internet = NO;
//	} else {
//		internet = YES;
//	}
//	return internet;
//}


+(NSString*)getCurrentDateTime{
    NSDate *date = [NSDate date];
    NSLog(@"date object : %@", date);
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSLog(@"date string : %@",dateString);
    return dateString;
}

+(NSString*)parseDurarion:(NSString*)duration{
    
    duration = [duration stringByReplacingOccurrencesOfString:@"PT" withString:@""];
    
    NSRange rangeOfH = [duration rangeOfString:@"H"];
    
    NSString *time;
    NSString *seconds;
    NSString *mins;
    NSString *hours;
    
    if(rangeOfH.location != NSNotFound){
        hours = [self getTime:duration Range:NSMakeRange(0, rangeOfH.location)];
//        NSLog(@"Hours : %@",hours);
        if(rangeOfH.location+1 < duration.length){
            duration = [duration substringFromIndex:rangeOfH.location+1];
        }
    }
    
    NSRange rangeOfM = [duration rangeOfString:@"M"];
    if(rangeOfM.location != NSNotFound){
        mins = [self getTime:duration Range:NSMakeRange(0, rangeOfM.location)];
//        NSLog(@"Minuts : %@",mins);
        if(rangeOfM.location+1 < duration.length){
            duration = [duration substringFromIndex:rangeOfM.location+1];
        }
    }else{
        mins = @"00";
    }
    
    NSRange rangeOfS = [duration rangeOfString:@"S"];
    if(rangeOfS.location != NSNotFound){
        seconds = [self getTime:duration Range:NSMakeRange(0, rangeOfS.location)];
//        NSLog(@"Sec : %@",seconds);
        if(rangeOfS.location+1 < duration.length){
            duration = [duration substringFromIndex:rangeOfS.location+1];
        }
    }else{
        seconds = @"00";
    }
    
    if(hours){
        time = [NSString stringWithFormat:@"%@:%@:%@", hours, mins, seconds];
    }else{
        time = [NSString stringWithFormat:@"%@:%@", mins, seconds];
    }
    
    return time;
}

+(NSString*)getTime:(NSString*)duration Range:(NSRange)range{
    
    NSString *time = [duration substringWithRange:range];
    if(time.length==1){
        time = [NSString stringWithFormat:@"0%@", time];
    }else{
        time = [NSString stringWithFormat:@"%@", time];
    }
    
    return  time;
}


+(NSString*)parseBublishDate:(NSString*)publishDate{
    NSString *StringRemoveT = [publishDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSString *RemoveZ = [StringRemoveT stringByReplacingOccurrencesOfString:@"Z" withString:@" +0000"];
    
    publishDate = RemoveZ;
//    NSLog(@"Remove T %@",publishDate);
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-ddHH:mm:ss ZZZ"];
    NSDate *endDate = [f dateFromString:publishDate];
    NSLog(@"date old %@",endDate);
    NSString *dateReturn=[NSDate prettyTimestampSinceDate:endDate];
    return dateReturn;
}

+(NSDate*)youtubeDate:(NSString*)rawDate{
    rawDate = [rawDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    rawDate = [rawDate stringByReplacingOccurrencesOfString:@"Z" withString:@" +0000"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    
    NSDate *youtubeDate = [formatter dateFromString:rawDate];
    NSLog(@"youtubeDate : %@",youtubeDate);
    return youtubeDate;
}

+(BOOL)isToday:(NSDate*)youtubedate{
    
    NSDate * today = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSString *uDate = [formatter stringFromDate:today];
    
//    NSLog(@"uDate : %@", uDate);
    NSString *tDate = [formatter stringFromDate:youtubedate];
//    NSLog(@"tDate : %@", tDate);
    
    if([uDate isEqualToString:tDate]){
        NSLog(@"Today Date");
        return YES;
    }
    NSLog(@"Other Date");
    return NO;
}

+(BOOL)isDate:(NSDate*)youtubeDate Between:(NSDate*)startDate AND :(NSDate*)endDate{
    
    NSComparisonResult result = [youtubeDate compare:startDate];
    NSComparisonResult result2 = [youtubeDate compare:endDate];
    if(result == NSOrderedDescending && result2 == NSOrderedAscending){
        NSLog(@"Between");
        return YES;
    }
    NSLog(@"NOt between");
    return NO;
}

+(NSArray*)getFirstAndLastDateOfPreviousMonth{
    
    NSDate *date = [NSDate date];
    NSLog(@"Current Date : %@", date);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:date];
    NSInteger day = [components day];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-day+1];
    [comps setMonth:-1];
    
    NSDate *firstOfLastMonth = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"firstOfLastMonth : %@", firstOfLastMonth);
    
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:-day];
    NSDate *endOfLastMonth = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"endOfLastMonth : %@", endOfLastMonth);
    
    
    return [NSArray arrayWithObjects:firstOfLastMonth, endOfLastMonth, nil];
}

+(NSArray*)getFirstAndLastDateOfPreviousWeek{
    NSDate *date = [NSDate date];
    NSLog(@"Current Date : %@", date);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components: NSCalendarUnitWeekday fromDate:date];

    NSInteger weekDay = [components weekday];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:-weekDay+1];
    [comps setWeek:-1];
    NSDate *firstOfLastWeek = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"firstOfLastWeek : %@", firstOfLastWeek);
    
    comps = [[NSDateComponents alloc] init];
    [comps setDay:-weekDay];
    NSDate *endOfLastWeek = [calendar dateByAddingComponents:comps toDate:date options:0];
    NSLog(@"endOfLastWeek : %@", endOfLastWeek);
    
    return [NSArray arrayWithObjects:firstOfLastWeek, endOfLastWeek, nil];
}

+(NSString*)getFilePath:(NSString*)videoID{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", videoID]];
    return filePath;
}

+(BOOL)isFileExists:(NSString*)videoID{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [self getFilePath:videoID];
    if ([fm fileExistsAtPath:filePath]) {
        NSLog(@"file Exists");
        return YES;
    
    }
    NSLog(@"file not Exists");
    return NO;
}

+(NSUInteger)getDownloadedBytes:(NSString*)videoID{
    NSUInteger downloadedBytes = 0;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [self getFilePath:videoID];
    if ([fm fileExistsAtPath:filePath]) {
        NSError *error = nil;
        NSDictionary *fileDictionary = [fm attributesOfItemAtPath:filePath error:&error];
        if (fileDictionary)
            downloadedBytes = (NSUInteger)[fileDictionary fileSize];
    }
    
    return downloadedBytes;
}



@end