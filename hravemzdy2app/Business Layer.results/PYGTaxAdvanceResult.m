//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGTaxAdvanceResult.h"
#import "PYGPayrollConcept.h"


@implementation PYGTaxAdvanceResult {

}

@synthesize payment      = _payment;
@synthesize afterReliefA = _afterReliefA;
@synthesize afterReliefC = _afterReliefC;

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
    _payment      = D_SAFE_VALUES(@"payment");
    _afterReliefA = D_SAFE_VALUES(@"after_relief_A");
    _afterReliefC = D_SAFE_VALUES(@"after_relief_C");
}

- (NSDecimalNumber *)getDeduction {
    return self.payment;
}

- (NSDecimalNumber *)getPayment {
    return self.payment;
}

- (NSString *)xmlValue {
    return @"";
}

- (NSString *)exportValueResult {
    return @"";
}

@end