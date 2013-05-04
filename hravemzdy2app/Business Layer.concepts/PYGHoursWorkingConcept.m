//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursWorkingConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTimesheetWorkTag.h"
#import "PYGTimesheetResult.h"
#import "PYGTermHoursResult.h"


@implementation PYGHoursWorkingConcept {
}
@synthesize hours = _hours;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_HOURS_WORKING] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGHoursWorkingConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGHoursWorkingConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGHoursWorkingConcept *concept = [PYGHoursWorkingConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _hours = [(NSNumber *) values[@"hours"] integerValue];
}

+(PYGHoursWorkingConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTimesheetWorkTag)
    ];
}

- (NSArray *)summaryCodes {
    return @[];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_TIMES;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGTimesheetResult * resultTimesheet = (PYGTimesheetResult *)[self getResult:results byTagCode:TAG_TIMESHEET_WORK];

    NSInteger resultHours = resultTimesheet.hours + self.hours;

    NSDictionary * resultValues = I_MAKE_HASH(@"hours", resultHours);

    return [PYGTermHoursResult newWithConcept:self andValues:resultValues];
}

@end