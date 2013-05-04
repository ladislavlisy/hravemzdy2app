//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursAbsenceConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTimesheetWorkTag.h"
#import "PYGTermHoursResult.h"


@implementation PYGHoursAbsenceConcept {

}
@synthesize hours =  _hours;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_HOURS_ABSENCE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGHoursAbsenceConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGHoursAbsenceConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGHoursAbsenceConcept *concept = [PYGHoursAbsenceConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _hours = I_SAFE_VALUES(@"hours");
}

+(PYGHoursAbsenceConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTimesheetWorkTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_TIMES;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSInteger resultHours = self.hours;

    NSDictionary * resultValues = I_MAKE_HASH(@"hours", resultHours);

    return [PYGTermHoursResult newWithConcept:self andValues:resultValues];
}

@end