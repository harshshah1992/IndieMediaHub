//
//  NSDate+Utils.m
//  Custom properties
//
//  Created by HB-32 on 4/26/14.
//  Copyright (c) 2014 konga.com. All rights reserved.
//

#import "NSDate+Utils.h"

@interface NSDate()
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value;
@end

@implementation NSDate (Utils)

#ifndef NSDateTimeAgoLocalizedStrings
#define NSDateTimeAgoLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"NSDateTimeAgo", [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"NSDateTimeAgo.bundle"]], nil)
#endif
/*
 * This guy can be a little unreliable and produce unexpected results,
 * you're better off using daysAgoAgainstMidnight
 */
- (NSUInteger)daysAgo {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit)
                                               fromDate:self
                                                 toDate:[NSDate date]
                                                options:0];
    return [components day];
}

- (NSUInteger)daysAgoAgainstMidnight {
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];
    
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

- (NSString *)stringDaysAgo {
    return [self stringDaysAgoAgainstMidnight:YES];
}

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    NSString *text = nil;
    switch (daysAgo) {
        case 0:
            text = @"Today";
            break;
        case 1:
            text = @"Yesterday";
            break;
        default:
            text = [NSString stringWithFormat:@"%d days ago", daysAgo];
    }
    return text;
}

- (NSUInteger)weekday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    return [weekdayComponents weekday];
}

+ (NSString *)dbFormatString {
    return @"yyyy-MM-dd HH:mm:ss";
}
+ (NSString *)shortdbFormatString {
    return @"yyyy-MM-dd HH:mm";
}

+ (NSString *)dayFormatString {
    return @"yyyy-MM-dd";
}

+ (NSString *)shortFormatString {
    return @"dd/MM/yy";
}

+ (NSString *)humanFormatString {
    return @"EEEE, MMMM d";
}

+ (NSString *)usefulhumanFormatString {
    return @"EE, MMM d yyyy";
}

+ (NSString *)shortHumanFormatString {
    return @"dd MMM YY";
}

+ (NSString *)shortHumanFormatStringWithTime {
    return @"dd MMM yyyy HH:mm";
}

+ (NSString *)fullDateFormatString {
    return @"EEEE, MMMM dd, yyyy";
}



+ (NSDate *)dateFromString:(NSString *)string {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:[NSDate dbFormatString]];
    // NOTE: this is required to overcome the iPhone SDK Bug where the users time format setting will override any application formatting
    [inputFormatter setLocale:[NSLocale systemLocale]];
    //
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromDayString:(NSString *)string {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:[NSDate dayFormatString]];
    [inputFormatter setLocale:[NSLocale systemLocale]];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    //[outputFormatter setLocale:[NSLocale systemLocale]]; NOTE: use of setLocate seriously messes this up.
    NSString *newDateString = [outputFormatter stringFromDate:date];
    return newDateString;
}

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString*)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSDate *)dateFromUKString:(NSString *)string withFormat:(NSString*)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    [inputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/London"]];
    
    NSDate *date = [inputFormatter dateFromString:string];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [NSDate stringFromDate:date withFormat:[NSDate dbFormatString]];
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    /*
     * if the date is in today, display 12-hour time with meridian,
     * if it is within the last 7 days, display weekday name (Friday)
     * if within the calendar year, display as Jan 23
     * else display as Nov 11, 2008
     */
    
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = nil;
    
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today options:0];
        if ([date compare:lastweek] == NSOrderedDescending) {
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            
            NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                           fromDate:date];
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MMM d"];
            } else {
                [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
        }
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];
        }
    }
    
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSDate *)beginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question. (If today's Sunday, subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:beginningOfWeek];
    return [calendar dateFromComponents:components];
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}




//
/***********************************************
 * @description SUPPORT FOR BUG IN NSDateFormatter which overrides your formmating string with the users Date/Time pref Setting
 ***********************************************/
//

// Returns time string in 24-hour mode from the given NSDate
+(NSString *)time24FromDate:(NSDate *)date withTimeZone:(NSTimeZone *)timeZone
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    NSString* time = [dateFormatter stringFromDate:date];
    
    if (time.length > 5) {
        NSRange range;
        range.location = 3;
        range.length = 2;
        int hour = [[time substringToIndex:2] intValue];
        NSString *minute = [time substringWithRange:range];
        range = [time rangeOfString:@"AM"];
        if (range.length==0)
            hour += 12;
        time = [NSString stringWithFormat:@"%02d:%@", hour, minute];
    }
    
    return time;
}

// Returns a proper NSDate given a time string in 24-hour mode
+(NSDate *)dateFromTime24:(NSString *)time24String withTimeZone:(NSTimeZone *)timeZone
{
    int hour = [[time24String substringToIndex:2] intValue];
    int minute = [[time24String substringFromIndex:3] intValue];
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *result;
    if ([self userSetTwelveHourMode]) {
        [dateFormatter setDateFormat:@"hh:mm aa"];
        if (hour > 12) {
            result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d PM", hour - 12, minute]];
        } else {
            result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d AM", hour, minute]];
        }
    } else {
        [dateFormatter setDateFormat:@"HH:mm"];
        result = [dateFormatter dateFromString:[NSString stringWithFormat:@"%02d:%02d", hour, minute]];
    }
    
    return result;
}

// Tests whether the user has set the 12-hour or 24-hour mode in their settings.
+(BOOL)userSetTwelveHourMode
{
    NSDateFormatter *testFormatter = [[NSDateFormatter alloc] init];
    [testFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *testTime = [testFormatter stringFromDate:[NSDate date]];
    return [testTime hasSuffix:@"M"] || [testTime hasSuffix:@"m"];
}

// Converts a 24-hour time string to 12-hour time string
+(NSString *)time12FromTime24:(NSString *)time24String
{
    NSDateFormatter *testFormatter = [[NSDateFormatter alloc] init];
    int hour = [[time24String substringToIndex:2] intValue];
    int minute = [[time24String substringFromIndex:3] intValue];
    
    NSString *result = [NSString stringWithFormat:@"%02d:%02d %@", hour % 12, minute, hour > 12 ? [testFormatter PMSymbol] : [testFormatter AMSymbol]];
    return result;
}


+(NSPredicate *)dateMatcher:(NSDate *)date forAttribute:(NSString *)attributeName{
    
    //First set the unit flags you want automatically put into your date from an NSDate object
    unsigned startUnitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //now create an NSCalendar object
    NSCalendar *startCal = [NSCalendar currentCalendar];
    //Use the NSCalendar object to create an NSDateComponents object from the date you are interested in rounding
    //In this case we are just using the time now by calling [NSDate date]
    NSDateComponents *minDateComps = [startCal components:startUnitFlags fromDate:[NSDate date]];
    //Now we use the NSCalendar object again to generate a date from the date components object
    NSDate *startDate = [startCal dateFromComponents:minDateComps];
    
    
    //First set the unit flags you want automatically put into your date from an NSDate object
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //now create an NSCalendar object
    NSCalendar *cal = [NSCalendar currentCalendar];
    //Use the NSCalendar object to create an NSDateComponents object from the date you are interested in rounding
    //In this case we are just using the time now by calling [NSDate date]
    NSDateComponents *maxDateComps = [cal components:unitFlags fromDate:[NSDate date]];
    //now set the hours, minutes and seconds to the end of the day
    maxDateComps.hour = 23;
    maxDateComps.minute = 59;
    maxDateComps.second = 59;
    //Now we use the NSCalendar object again to generate a date from the date components object
    NSDate *endDate = [cal dateFromComponents:maxDateComps];
    
    
    // Finally create the predicate with the correct format
    return [NSPredicate predicateWithFormat:@"(%K >= %@) AND (%K <= %@)",attributeName, startDate, attributeName, endDate];
}


+(NSDate*)convertEpochMSTimeToDate:(NSString*)time{
    
    long long plong;
    NSRange range;
    range.length = time.length;
    range.location = 0;
    
    [[NSScanner scannerWithString:[time substringWithRange:range]]
     scanLongLong:&plong];
    
    plong=plong/1000;
    
    return [NSDate dateWithTimeIntervalSince1970:plong];
    
}


+(NSDate*)newDateTimeIgnoringDate:(NSDate*)date{
    
    unsigned int flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:date];
    [components setSecond:0];
    
    NSDate* timeOnlyDate = [calendar dateFromComponents:components];
    
    return timeOnlyDate;
    
}

- (NSString *)timeAgoSimple
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int value;
    
    if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d%@s" withValue:deltaSeconds];
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d%@m" withValue:deltaMinutes];
    }
    else if (deltaMinutes < (24 * 60))
    {
        value = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d%@h" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        value = (int)floor(deltaMinutes/(60 * 24));
        return [self stringFromFormat:@"%%d%@d" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 31))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 7));
        return [self stringFromFormat:@"%%d%@w" withValue:value];
    }
    else if (deltaMinutes < (24 * 60 * 365.25))
    {
        value = (int)floor(deltaMinutes/(60 * 24 * 30));
        return [self stringFromFormat:@"%%d%@mo" withValue:value];
    }
    
    value = (int)floor(deltaMinutes/(60 * 24 * 365));
    return [self stringFromFormat:@"%%d%@yr" withValue:value];
}

- (NSString *)timeAgo
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    int minutes;
    if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [NSDate stringFromDate:self withFormat:@"hh:mm a"];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    } else {
        return [NSDate stringFromDate:self withFormat:[NSDate shortFormatString]];
    }
//    if(deltaSeconds < 5)
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Just now");
//    }
//    else if(deltaSeconds < 60)
//    {
//        return [self stringFromFormat:@"%%d %@sec ago" withValue:deltaSeconds];
//    }
//    else if(deltaSeconds < 120)
//    {
//        return NSDateTimeAgoLocalizedStrings(@"A min ago");
//    }
//    else if (deltaMinutes < 60)
//    {
//        return [self stringFromFormat:@"%%d %@mins ago" withValue:deltaMinutes];
//    }
//    else if (deltaMinutes < 120)
//    {
//        return NSDateTimeAgoLocalizedStrings(@"An hr ago");
//    }
//    else if (deltaMinutes < (24 * 60))
//    {
//        minutes = (int)floor(deltaMinutes/60);
//        return [self stringFromFormat:@"%%d %@hrs ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 2))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
//    }
//    else if (deltaMinutes < (24 * 60 * 7))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24));
//        return [self stringFromFormat:@"%%d %@days ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 14))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last week");
//    }
//    else if (deltaMinutes < (24 * 60 * 31))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
//        return [self stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 61))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last month");
//    }
//    else if (deltaMinutes < (24 * 60 * 365.25))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
//        return [self stringFromFormat:@"%%d %@months ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 731))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last year");
//    }
//    
//    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
//    return [self stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

- (NSString *)timeAgoOld
{
    NSDate *now = [NSDate date];
    double deltaSeconds = fabs([self timeIntervalSinceDate:now]);
    double deltaMinutes = deltaSeconds / 60.0f;
    int minutes;
    if(deltaSeconds < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    else if(deltaSeconds < 60)
    {
        return [self stringFromFormat:@"%%d %@sec ago" withValue:deltaSeconds];
    }
    else if(deltaSeconds < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"A min ago");
    }
    else if (deltaMinutes < 60)
    {
        return [self stringFromFormat:@"%%d %@mins ago" withValue:deltaMinutes];
    }
    else if (deltaMinutes < 120)
    {
        return NSDateTimeAgoLocalizedStrings(@"An hr ago");
    }
    else if (deltaMinutes < (24 * 60))
    {
        minutes = (int)floor(deltaMinutes/60);
        return [self stringFromFormat:@"%%d %@hrs ago" withValue:minutes];
    }
    else if (deltaMinutes < (24 * 60 * 2))
    {
        return NSDateTimeAgoLocalizedStrings(@"Yesterday");
    } else {
        return [NSDate stringFromDate:self withFormat:[NSDate shortFormatString]];
    }
//    else if (deltaMinutes < (24 * 60 * 7))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24));
//        return [self stringFromFormat:@"%%d %@days ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 14))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last week");
//    }
//    else if (deltaMinutes < (24 * 60 * 31))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24 * 7));
//        return [self stringFromFormat:@"%%d %@weeks ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 61))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last month");
//    }
//    else if (deltaMinutes < (24 * 60 * 365.25))
//    {
//        minutes = (int)floor(deltaMinutes/(60 * 24 * 30));
//        return [self stringFromFormat:@"%%d %@months ago" withValue:minutes];
//    }
//    else if (deltaMinutes < (24 * 60 * 731))
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Last year");
//    }
//    
//    minutes = (int)floor(deltaMinutes/(60 * 24 * 365));
//    return [self stringFromFormat:@"%%d %@years ago" withValue:minutes];
}

// Similar to timeAgo, but only returns "
- (NSString *)dateTimeAgo
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:
                                    NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSWeekCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit|
                                    NSSecondCalendarUnit
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.year >= 1)
    {
        if (components.year == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 year ago");
        }
        return [self stringFromFormat:@"%%d %@years ago" withValue:components.year];
    }
    else if (components.month >= 1)
    {
        if (components.month == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 month ago");
        }
        return [self stringFromFormat:@"%%d %@months ago" withValue:components.month];
    }
    else if (components.week >= 1)
    {
        if (components.week == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 week ago");
        }
        return [self stringFromFormat:@"%%d %@weeks ago" withValue:components.week];
    }
    else if (components.day >= 1) // up to 6 days ago
    {
        if (components.day == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1 day ago");
        }
        return [self stringFromFormat:@"%%d %@days ago" withValue:components.day];
    }
    else if (components.hour >= 1) // up to 23 hours ago
    {
        if (components.hour == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"An hour ago");
        }
        return [self stringFromFormat:@"%%d %@hours ago" withValue:components.hour];
    }
    else if (components.minute >= 1) // up to 59 minutes ago
    {
        if (components.minute == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"A minute ago");
        }
        return [self stringFromFormat:@"%%d %@minutes ago" withValue:components.minute];
    }
    else if (components.second < 5)
    {
        return NSDateTimeAgoLocalizedStrings(@"Just now");
    }
    
    // between 5 and 59 seconds ago
    return [self stringFromFormat:@"%%d %@seconds ago" withValue:components.second];
}


- (NSString *)dateTimeAgoUptoWeeks
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate * now = [NSDate date];
    NSDateComponents *components = [calendar components:
                                    NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSWeekCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit|
                                    NSSecondCalendarUnit
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
//    if (components.year >= 1)
//    {
//        if (components.year == 1)
//        {
//            return NSDateTimeAgoLocalizedStrings(@"1 year ago");
//        }
//        return [self stringFromFormat:@"%%d %@years ago" withValue:components.year];
//    }
//    else if (components.month >= 1)
//    {
//        if (components.month == 1)
//        {
//            return NSDateTimeAgoLocalizedStrings(@"1 month ago");
//        }
//        return [self stringFromFormat:@"%%d %@months ago" withValue:components.month];
//    }
//    else
    if (components.week >= 1)
    {
        if (components.week == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1w");
        }
        return [self stringFromFormat:@"%%d%@w" withValue:components.week];
    }
    else if (components.day >= 1) // up to 6 days ago
    {
        if (components.day == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1d");
        }
        return [self stringFromFormat:@"%%d%@d" withValue:components.day];
    }
    else if (components.hour >= 1) // up to 23 hours ago
    {
        if (components.hour == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1h");
        }
        return [self stringFromFormat:@"%%d%@h" withValue:components.hour];
    }
    else if (components.minute >= 1) // up to 59 minutes ago
    {
        if (components.minute == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"1m");
        }
        return [self stringFromFormat:@"%%d%@m" withValue:components.minute];
    }
//    else if (components.second < 5)
//    {
//        return NSDateTimeAgoLocalizedStrings(@"Just now");
//    }
    
    // between 5 and 59 seconds ago
    return [self stringFromFormat:@"%%d%@s" withValue:components.second];
}



- (NSString *)dateTimeUntilNow
{
    NSDate * now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSHourCalendarUnit
                                               fromDate:self
                                                 toDate:now
                                                options:0];
    
    if (components.hour >= 6) // if more than 6 hours ago, change precision
    {
        NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                                 inUnit:NSEraCalendarUnit
                                                forDate:self];
        NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                               inUnit:NSEraCalendarUnit
                                              forDate:now];
        
        NSInteger diffDays = endDay - startDay;
        if (diffDays == 0) // today!
        {
            NSDateComponents * startHourComponent = [calendar components:NSHourCalendarUnit fromDate:self];
            NSDateComponents * endHourComponent = [calendar components:NSHourCalendarUnit fromDate:self];
            if (startHourComponent.hour < 12 &&
                endHourComponent.hour > 12)
            {
                return NSDateTimeAgoLocalizedStrings(@"This morning");
            }
            else if (startHourComponent.hour >= 12 &&
                     startHourComponent.hour < 18 &&
                     endHourComponent.hour >= 18)
            {
                return NSDateTimeAgoLocalizedStrings(@"This afternoon");
            }
            return NSDateTimeAgoLocalizedStrings(@"Today");
        }
        else if (diffDays == 1)
        {
            return NSDateTimeAgoLocalizedStrings(@"Yesterday");
        }
        else
        {
            NSInteger startWeek = [calendar ordinalityOfUnit:NSWeekCalendarUnit
                                                      inUnit:NSEraCalendarUnit
                                                     forDate:self];
            NSInteger endWeek = [calendar ordinalityOfUnit:NSWeekCalendarUnit
                                                    inUnit:NSEraCalendarUnit
                                                   forDate:now];
            NSInteger diffWeeks = endWeek - startWeek;
            if (diffWeeks == 0)
            {
                return NSDateTimeAgoLocalizedStrings(@"This week");
            }
            else if (diffWeeks == 1)
            {
                return NSDateTimeAgoLocalizedStrings(@"Last week");
            }
            else
            {
                NSInteger startMonth = [calendar ordinalityOfUnit:NSMonthCalendarUnit
                                                           inUnit:NSEraCalendarUnit
                                                          forDate:self];
                NSInteger endMonth = [calendar ordinalityOfUnit:NSMonthCalendarUnit
                                                         inUnit:NSEraCalendarUnit
                                                        forDate:now];
                NSInteger diffMonths = endMonth - startMonth;
                if (diffMonths == 0)
                {
                    return NSDateTimeAgoLocalizedStrings(@"This month");
                }
                else if (diffMonths == 1)
                {
                    return NSDateTimeAgoLocalizedStrings(@"Last month");
                }
                else
                {
                    NSInteger startYear = [calendar ordinalityOfUnit:NSYearCalendarUnit
                                                              inUnit:NSEraCalendarUnit
                                                             forDate:self];
                    NSInteger endYear = [calendar ordinalityOfUnit:NSYearCalendarUnit
                                                            inUnit:NSEraCalendarUnit
                                                           forDate:now];
                    NSInteger diffYears = endYear - startYear;
                    if (diffYears == 0)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"This year");
                    }
                    else if (diffYears == 1)
                    {
                        return NSDateTimeAgoLocalizedStrings(@"Last year");
                    }
                }
            }
        }
    }
    
    // anything else uses "time ago" precision
    return [self dateTimeAgo];
}



- (NSString *) stringFromFormat:(NSString *)format withValue:(NSInteger)value
{
    NSString * localeFormat = [NSString stringWithFormat:format, [self getLocaleFormatUnderscoresWithValue:value]];
    return [NSString stringWithFormat:NSDateTimeAgoLocalizedStrings(localeFormat), value];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit
{
    return [self timeAgoWithLimit:limit dateFormat:NSDateFormatterFullStyle andTimeFormat:NSDateFormatterFullStyle];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self timeAgo];
    
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:dFormatter
                                          timeStyle:tFormatter];
}

- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter
{
    if (fabs([self timeIntervalSinceDate:[NSDate date]]) <= limit)
        return [self timeAgo];
    
    return [formatter stringFromDate:self];
}

// Helper functions

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

/*
 - Author : Almas Adilbek
 - Method : getLocaleFormatUnderscoresWithValue
 - Param : value (Double value of seconds or minutes)
 - Return : @"" or the set of underscores ("_")
 in order to define exact translation format for specific translation rules.
 (Ex: "%d _seconds ago" for "%d секунды назад", "%d __seconds ago" for "%d секунда назад",
 and default format without underscore %d seconds ago" for "%d секунд назад")
 Updated : 12/12/2012
 Note : This method must be used for all languages that have specific translation rules.
 Using method argument "value" you must define all possible conditions language have for translation
 and return set of underscores ("_") as it is an ID for locale format. No underscore ("") means default locale format;
 */
-(NSString *)getLocaleFormatUnderscoresWithValue:(double)value
{
    NSString *localeCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    
    // Russian (ru)
    if([localeCode isEqual:@"ru"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) return @"";
        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20)) return @"_";
        if(Y == 1 && XY != 11) return @"__";
    }
    
    // Add more languages here, which are have specific translation rules...
    
    return @"";
}
@end
