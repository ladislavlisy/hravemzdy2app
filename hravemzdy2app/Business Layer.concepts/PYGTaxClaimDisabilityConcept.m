//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimDisabilityConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxClaimResult.h"


@implementation PYGTaxClaimDisabilityConcept {

}
@synthesize reliefCode3 = _reliefCode3;
@synthesize reliefCode1 = _reliefCode1;
@synthesize reliefCode2 = _reliefCode2;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_CLAIM_DISABILITY] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxClaimDisabilityConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxClaimDisabilityConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxClaimDisabilityConcept *concept = [PYGTaxClaimDisabilityConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _reliefCode1 = U_SAFE_VALUES(@"relief_code_1");
    _reliefCode2 = U_SAFE_VALUES(@"relief_code_2");
    _reliefCode3 = U_SAFE_VALUES(@"relief_code_3");
}

+(PYGTaxClaimDisabilityConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    NSInteger reliefValue1 = [self relief1ClaimAmount:period.year forCode:self.reliefCode1];
    NSInteger reliefValue2 = [self relief2ClaimAmount:period.year forCode:self.reliefCode2];
    NSInteger reliefValue3 = [self relief3ClaimAmount:period.year forCode:self.reliefCode3];

    NSInteger reliefValue = reliefValue1 + reliefValue2 + reliefValue3;

    NSDictionary * resultValues = D_MAKE_HASH(@"tax_relief", DECIMAL_NUMB(@(reliefValue)));

    return [PYGTaxClaimResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)relief1ClaimAmount:(NSUInteger)year forCode:(NSUInteger)code {
    NSInteger reliefAmount = 0;
    if (code == 0) {
        return reliefAmount;
    }
    reliefAmount = [self disability1Relief:year];
    return reliefAmount;
}

- (NSInteger)relief2ClaimAmount:(NSUInteger)year forCode:(NSUInteger)code {
    NSInteger reliefAmount = 0;
    if (code == 0) {
        return reliefAmount;
    }
    reliefAmount = [self disability2Relief:year];
    return reliefAmount;
}

- (NSInteger)relief3ClaimAmount:(NSUInteger)year forCode:(NSUInteger)code {
    NSInteger reliefAmount = 0;
    if (code == 0) {
        return reliefAmount;
    }
    reliefAmount = [self disability3Relief:year];
    return reliefAmount;
}

- (NSInteger)disability1Relief:(NSUInteger)year
{
    NSInteger reliefAmount = 0;
    if (year >= 2009)
    {
        reliefAmount = 210;
    }
    else if (year == 2008)
    {
        reliefAmount = 210;
    }
    else if (year >= 2006)
    {
        reliefAmount = 125;
    }
    else
    {
        reliefAmount = 0;
    }
    return reliefAmount;
}

- (NSInteger)disability2Relief:(NSUInteger)year
{
    NSInteger reliefAmount = 0;
    if (year >= 2009)
    {
        reliefAmount = 420;
    }
    else if (year == 2008)
    {
        reliefAmount = 420;
    }
    else if (year >= 2006)
    {
        reliefAmount = 250;
    }
    else
    {
        reliefAmount = 0;
    }
    return reliefAmount;
}

- (NSInteger)disability3Relief:(NSUInteger)year
{
    NSInteger reliefAmount = 0;
    if (year >= 2009)
    {
        reliefAmount = 1345;
    }
    else if (year == 2008)
    {
        reliefAmount = 1345;
    }
    else if (year >= 2006)
    {
        reliefAmount = 800;
    }
    else
    {
        reliefAmount = 0;
    }
    return reliefAmount;
}

@end