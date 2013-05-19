//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleWeeklyConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGScheduleResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGScheduleWeeklyConcept {

}
@synthesize hoursWeekly = _hoursWeekly;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_SCHEDULE_WEEKLY] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGScheduleWeeklyConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGScheduleWeeklyConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGScheduleWeeklyConcept *concept = [PYGScheduleWeeklyConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _hoursWeekly = I_SAFE_VALUES(@"hours_weekly");
}

+(PYGScheduleWeeklyConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSArray * hoursWeek = [self hoursForOneWeek];

    NSDictionary * resultValues = A_MAKE_HASH(@"week_schedule", hoursWeek);

    return [PYGScheduleResult newWithConcept:self andValues:resultValues];
}

// TODO: add function ScheduleWeeklyConcept#evaluate#hours_for_one_day
 - (NSInteger)hoursForOneDay {
     return self.hoursWeekly/5;
 }

// TODO: add function ScheduleWeeklyConcept#evaluate#hours_for_one_week
- (NSArray *) hoursForOneWeek {
    NSInteger daily = [self hoursForOneDay];
    NSArray * hoursWeek = @[@(daily),@(daily),@(daily),@(daily),@(daily),@0,@0];
    return hoursWeek;
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"hours_weekly" : [@(self.hoursWeekly) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withValue:[self xmlValue] withAttributes:attributes];
    return done;
    return YES;
}

- (NSString *)xmlValue {
    return [NSString stringWithFormat:@"%@ hours", @(self.hoursWeekly)];
}

@end