//
//  NSDateTime+Wrapper.m
//
//
//  Created by luongnguyen on 7/23/14.
//  Copyright (c) 2014 appiphany. All rights reserved.
//

#import "NSDateTime+Wrapper.h"

@implementation NSDate (Wrapper)
#pragma mark STATIC
static NSDateFormatter* dateFormatter_ = nil;

+ (void) setupSharedDateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter_ = [[NSDateFormatter alloc] init];
        [dateFormatter_ setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"us"]];
        [dateFormatter_ setTimeZone:[NSTimeZone systemTimeZone]];
    });
}

+ (NSDateFormatter*) getSharedFormatter
{
    if (!dateFormatter_) [NSDate setupSharedDateFormatter];
    return dateFormatter_;
}

#pragma mark MAIN
- (NSDate*) convertToLocalDate
{
    if (!dateFormatter_) [NSDate setupSharedDateFormatter];
    
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate:self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate*) convertToUTCDate
{
    if (!dateFormatter_) [NSDate setupSharedDateFormatter];
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    NSInteger seconds = -[tz secondsFromGMTForDate: self];
    return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDateComponents*) getDifferenceWithDate:(NSDate*)date
{
    if (!dateFormatter_) [NSDate setupSharedDateFormatter];
    
    NSDate* dateFrom = self;
    NSDate* dateTo = date;
    
    if ([self compare:date] == NSOrderedDescending) //self > date
    {
        dateFrom = date;
        dateTo = self;
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:dateFrom
                                                 toDate:dateTo
                                                options:0];
    
    return components;
}

- (NSString*) toStringWithFormat:(NSString*)format
{
    if (!dateFormatter_) [NSDate setupSharedDateFormatter];

    [dateFormatter_ setDateFormat:format];
    return [dateFormatter_ stringFromDate:self];
}

- (NSString *) getNowDateDifferenceWithFormat:(NSString*)expectedFormat
{
    NSDate *date = self;
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if(time < 10) {
        
        return @"now";
        
    } else if (time < 60) {
        return @"a minute ago";
        
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return @"a minute ago";
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return @"yesterday";
        if (diff == 7)
            return @"last week";
        return [NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return [self toStringWithFormat:expectedFormat];
    }
}


@end
