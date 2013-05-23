//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetWorkConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTimesheetPeriodTag.h"
#import "PYGScheduleTermTag.h"
#import "PYGTermEffectResult.h"
#import "PYGTimesheetResult.h"
#import "NSArray+Func.h"
#import "PYGXmlBuilder.h"


@implementation PYGTimesheetWorkConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TIMESHEET_WORK] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTimesheetWorkConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTimesheetWorkConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTimesheetWorkConcept *concept = [PYGTimesheetWorkConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTimesheetWorkConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
    TAG_NEW(PYGTimesheetPeriodTag),
    TAG_NEW(PYGScheduleTermTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_TIMES;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_SCHEDULE;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGTermEffectResult * resultScheduleTerm = (PYGTermEffectResult *) [self getResult:results byTagCode:TAG_SCHEDULE_TERM];
    PYGTimesheetResult * resultTimesheetPeriod = (PYGTimesheetResult *) [self getResult:results byTagCode:TAG_TIMESHEET_PERIOD];

    NSUInteger dayOrdFrom = resultScheduleTerm.dayOrdFrom;
    NSUInteger dayOrdEnd  = resultScheduleTerm.dayOrdEnd;
    NSArray * timesheetPeriod = resultTimesheetPeriod.monthSchedule;

    NSArray * hoursCalendar = [timesheetPeriod mapWithIndex:^id (id obj, NSUInteger idx) {
       NSNumber * hoursNumber = (NSNumber *)obj;
       NSInteger hours = [hoursNumber integerValue];
       return @([self hoursFromCalendarByFrom:dayOrdFrom end:dayOrdEnd forDayOrd:(idx+1) hours:hours]);
    }];

    NSDictionary * resultValues = A_MAKE_HASH(@"month_schedule", hoursCalendar);

    return [PYGTimesheetResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)hoursFromCalendarByFrom:(NSUInteger)dayOrdFrom end:(NSUInteger)dayOrdEnd forDayOrd:(NSUInteger)dayOrdinal hours:(NSInteger)workHours {
    NSInteger hoursInDay = workHours;
    if (dayOrdFrom > dayOrdinal) {
        hoursInDay = 0;
    }
    if (dayOrdEnd < dayOrdinal) {
        hoursInDay = 0;
    }
    return hoursInDay;
}

@end