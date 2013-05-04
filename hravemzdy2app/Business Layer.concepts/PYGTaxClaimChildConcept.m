//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimChildConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxClaimResult.h"


@implementation PYGTaxClaimChildConcept {

}
@synthesize reliefCode = _reliefCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_CLAIM_CHILD] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxClaimChildConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxClaimChildConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxClaimChildConcept *concept = [PYGTaxClaimChildConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _reliefCode = U_SAFE_VALUES(@"relief_code");
}

+(PYGTaxClaimChildConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSInteger reliefValue = [self reliefClaimAmount:period.year forCode:self.reliefCode];

    NSDictionary * resultValues = D_MAKE_HASH(@"tax_relief", DECIMAL_NUMB(@(reliefValue)));

    return [PYGTaxClaimResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)reliefClaimAmount:(NSUInteger)year forCode:(NSUInteger)code {
    NSInteger reliefAmount = 0;
    if (code == 0) {
        return reliefAmount;
    }
    if (year >= 2012)
    {
        reliefAmount = 1117;
    }
    else if (year >= 2010)
    {
        reliefAmount = 967;
    }
    else if (year == 2009)
    {
        reliefAmount = 890;
    }
    else if (year == 2008)
    {
        reliefAmount = 890;
    }
    else if (year >= 2006)
    {
        reliefAmount = 500;
    }
    else if (year >= 2005)
    {
        reliefAmount = 500;
    }
    else
    {
        reliefAmount = 0;
    }

    if (code == 2)
    {
        return 2*reliefAmount;
    }
    return reliefAmount;
}

@end