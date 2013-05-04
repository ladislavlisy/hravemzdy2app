//
// Created by Ladislav Lisy on 16.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@interface NSDate (PYGDateOnly)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateWithYear:(NSInteger)year  endDayOfmonth:(NSInteger)month;
+ (NSInteger)daysInForYear:(NSInteger)year andMonth:(NSInteger)month;

-(NSInteger)day;
-(NSInteger)month;
-(NSInteger)year;
-(NSInteger)weekDay;
-(NSInteger)weekDayOrdinal;
-(NSInteger)daysInMonth;

@end