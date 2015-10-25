//
//  NSDate+Utils.h
//  Custom properties
//
//  Created by HB-32 on 4/26/14.
//  Copyright (c) 2014 konga.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)
- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

// commonly used format strings
+ (NSString *)dbFormatString; // unix
+ (NSString *)shortdbFormatString; // short unix ie no secs
+ (NSString *)dayFormatString;
+ (NSString *)shortFormatString; // 12/09/10
+ (NSString *)humanFormatString; // Wednesday, August 12
+ (NSString *)fullDateFormatString; // Wednesday, October 12, 2010
+ (NSString *)shortHumanFormatString; // 22 Aug 10
+ (NSString *)shortHumanFormatStringWithTime; // 22 Aug 2010 12:45
+ (NSString *)usefulhumanFormatString; // Sat, Dec 12 2011

//
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromDayString:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString*)format;
+ (NSDate *)dateFromUKString:(NSString *)string withFormat:(NSString*)format;
- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;


// NSDDate 12/24 Bug support
+(NSString *)time24FromDate:(NSDate *)date withTimeZone:(NSTimeZone *)timeZone;
+(NSDate *)dateFromTime24:(NSString *)time24String withTimeZone:(NSTimeZone *)timeZone;
+(BOOL)userSetTwelveHourMode;
+(NSString *)time12FromTime24:(NSString *)time24String;


+(NSPredicate *)dateMatcher:(NSDate *)date forAttribute:(NSString *)attributeName;


+(NSDate*)convertEpochMSTimeToDate:(NSString*)time;

+(NSDate*)newDateTimeIgnoringDate:(NSDate*)date;
- (NSString *)timeAgoOld;
- (NSString *) timeAgoSimple;
- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;
- (NSString *)dateTimeAgoUptoWeeks;

// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;
@end
