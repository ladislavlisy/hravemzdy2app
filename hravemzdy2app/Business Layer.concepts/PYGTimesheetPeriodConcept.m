//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetPeriodConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGScheduleWorkTag.h"
#import "NSDate+PYGDateOnly.h"
#import "NSArray+Func.h"
#import "PYGScheduleResult.h"
#import "PYGTimesheetResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGTimesheetPeriodConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TIMESHEET_PERIOD] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTimesheetPeriodConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTimesheetPeriodConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTimesheetPeriodConcept *concept = [PYGTimesheetPeriodConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTimesheetPeriodConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGScheduleWorkTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_TIMES;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGScheduleResult * resultScheduleWork = (PYGScheduleResult *) [self getResult:results byTagCode:TAG_SCHEDULE_WORK];

    NSArray * weekHours = resultScheduleWork.weekSchedule;

    NSArray * hoursCalendar = [self monthCalendarDays:weekHours forPeriod:period];

    NSDictionary * resultValues = A_MAKE_HASH(@"month_schedule", hoursCalendar);

    return [PYGTimesheetResult newWithConcept:self andValues:resultValues];
}

- (NSArray *)monthCalendarDays:(NSArray *)weekHours forPeriod:(PYGPayrollPeriod *)period {
    NSArray * templateWeek = weekHours;

    NSDate * calendarBeg = [NSDate dateWithYear:period.year month:period.month day:1];

    NSUInteger calendarBegCwd = (NSUInteger) [calendarBeg weekDay];
    NSUInteger dateCount = (NSUInteger) [NSDate daysInForYear:period.year andMonth:period.month];

    NSArray * daysArray = [self arrayOfDaysFrom:1 to:dateCount];

    NSArray * hoursCalendar = [daysArray map:^id (id obj) {
        NSNumber * indexValue = (NSNumber *)obj;
        return @([self hoursFromWeek:templateWeek forOrdDay:[indexValue unsignedIntegerValue] andCalBegWeekDay:calendarBegCwd]);
    }];
    return hoursCalendar;
}

- (NSInteger)hoursFromWeek:(NSArray *)weekHours forOrdDay:(NSUInteger)dayOrdinal andCalBegWeekDay:(NSUInteger)calendarBegCwd {
    //calendar_day = Date.new(calendar_beg.year, calendar_beg.month, day_ordinal)
    NSUInteger dayOfWeek = [self getDayOfWeekFromOrdinal:dayOrdinal andBeginWeekDay:calendarBegCwd];
    NSNumber * hoursNumber = weekHours[dayOfWeek-1];
    return hoursNumber.integerValue;
}

- (NSUInteger)getDayOfWeekFromOrdinal:(NSUInteger)dayOrdinal andBeginWeekDay:(NSUInteger)calendarBegCwd {
    NSUInteger dayOfWeek = (((dayOrdinal-1)+(calendarBegCwd-1))%7)+1;
    return dayOfWeek;
}

- (NSArray*)arrayOfDaysFrom:(NSUInteger)fromIndex to:(NSUInteger)toIndex {
    NSArray * arrayOfDays = [NSArray array];
    for ( int i = fromIndex ; i <= toIndex ; i ++ ) {
        arrayOfDays = [arrayOfDays arrayByAddingObject:[NSNumber numberWithInt:i]];
    }
    return arrayOfDays;
}

@end