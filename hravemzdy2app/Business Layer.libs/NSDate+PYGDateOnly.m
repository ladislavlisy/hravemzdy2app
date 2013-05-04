//
// Created by Ladislav Lisy on 16.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDate+PYGDateOnly.h"

@implementation NSDate (PYGDateOnly)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateWithYear:(NSInteger)year  endDayOfmonth:(NSInteger)month {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger beginDayOfMonth = 1;
    NSDateComponents * components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:beginDayOfMonth];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate * beginOfMonth = [calendar dateFromComponents:components];
    NSUInteger endDayOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:beginOfMonth].length;
    [components setDay:endDayOfMonth];
    return [calendar dateFromComponents:components];
}

+ (NSInteger)daysInForYear:(NSInteger)year andMonth:(NSInteger)month {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger beginDayOfMonth = 1;
    NSDateComponents * components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:beginDayOfMonth];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate * beginOfMonth = [calendar dateFromComponents:components];
    NSUInteger endDayOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:beginOfMonth].length;
    return endDayOfMonth;
}

-(NSInteger)day{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSDayCalendarUnit fromDate:self];
    return [components day];
}

-(NSInteger)month{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSMonthCalendarUnit fromDate:self];
    return [components month];

}

-(NSInteger)year{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:self];
    return [components year];
}

-(NSInteger)weekDay{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSInteger gregorianWeekday = [components weekday];
    return (gregorianWeekday == 1 ? 7 : gregorianWeekday - 1);
}

-(NSInteger)weekDayOrdinal{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSWeekdayOrdinalCalendarUnit fromDate:self];
    return [components weekdayOrdinal];
}

-(NSInteger)daysInMonth {
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSUInteger endDayOfMonth = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
    return endDayOfMonth;
}

@end