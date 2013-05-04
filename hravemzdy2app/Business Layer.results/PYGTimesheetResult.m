//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGTimesheetResult.h"
#import "PYGPayrollConcept.h"
#import "NSArray+Func.h"


@implementation PYGTimesheetResult {

}

@synthesize monthSchedule = _monthSchedule;

// tag_code, concept_code, concept_item, values
- (id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    if (!(self=[super initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept])) return nil;
    [self setupValues:values];
    return self;
}

+ (id)newWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept andValues:values];
}

+ (id)newWithConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:concept.tagCode andConceptCode:concept.code andConcept:concept andValues:values];
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _monthSchedule = A_SAFE_VALUES(@"month_schedule");
}

- (NSInteger)hours {
    NSInteger monthHours = 0;
    if (self.monthSchedule != nil) {
        monthHours = [self.monthSchedule injectForInteger:(0) with:^NSInteger (NSInteger agr, NSInteger dh, NSUInteger index) {
            return (agr + dh);
        }];
    }
    return monthHours;
}

- (NSString *)xmlValue {
    return @"";
}

- (NSString *)exportValueResult {
    return @"";
}

@end