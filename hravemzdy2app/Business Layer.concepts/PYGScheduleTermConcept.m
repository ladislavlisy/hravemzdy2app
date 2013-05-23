//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleTermConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "NSDate+PYGDateOnly.h"
#import "PYGTermEffectResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGScheduleTermConcept {

}
@synthesize dateFrom = _dateFrom;
@synthesize dateEnd = _dateEnd;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_SCHEDULE_TERM] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGScheduleTermConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGScheduleTermConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGScheduleTermConcept *concept = [PYGScheduleTermConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _dateFrom = DT_SAFE_VALUES(@"date_from");
    _dateEnd  = DT_SAFE_VALUES(@"date_end");
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_SCHEDULE;
}

+(PYGScheduleTermConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSInteger dayTermFrom = TERM_BEG_FINISHED;
    NSInteger dayTermEnd  = TERM_END_FINISHED;

    NSDate * periodDateBeg = [NSDate dateWithYear:period.year month:period.month day:1];
    NSDate * periodDateEnd = [NSDate dateWithYear:period.year endDayOfmonth:period.month];

    dayTermFrom = (self.dateFrom != nil) ? [self.dateFrom day] : dayTermFrom;
    dayTermEnd  = (self.dateEnd != nil) ? [self.dateEnd day] : dayTermEnd;

    if (self.dateFrom == nil || [self.dateFrom compare:periodDateBeg] == NSOrderedAscending ) {
        dayTermFrom = periodDateBeg.day;

    }
    if (self.dateEnd == nil || [self.dateEnd  compare:periodDateEnd] == NSOrderedDescending) {
        dayTermEnd  = periodDateEnd.day;
    }

    NSDictionary * resultValues = @{
        I_MAKE_PAIR(@"day_ord_from", dayTermFrom),
        I_MAKE_PAIR(@"day_ord_end", dayTermEnd)
    };

    return [PYGTermEffectResult newWithConcept:self andValues:resultValues];
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDateFormatter *xmlFormatter = [[NSDateFormatter alloc] init];
    [xmlFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];

    NSDictionary *attributes = @{
            @"date_from" : [xmlBuilder stringFromDate:self.dateFrom],
            @"date_to" : [xmlBuilder stringFromDate:self.dateEnd]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withAttributes:attributes];
    return done;
}

@end