//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefChildConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGPaymentResult.h"
#import "PYGTaxAdvanceTag.h"
#import "PYGTaxReliefPayerTag.h"
#import "PYGTaxClaimChildTag.h"
#import "PYGTaxReliefResult.h"
#import "NSDictionary+Func.h"
#import "PYGTagRefer.h"


@implementation PYGTaxReliefChildConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_RELIEF_CHILD] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxReliefChildConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxReliefChildConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxReliefChildConcept *concept = [PYGTaxReliefChildConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxReliefChildConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxAdvanceTag),
        TAG_NEW(PYGTaxReliefPayerTag),
        TAG_NEW(PYGTaxClaimChildTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_NETTO;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPaymentResult * advanceBaseValue = (PYGPaymentResult *) [self getResult:results byTagCode:TAG_TAX_ADVANCE];
    PYGTaxReliefResult * reliefPayerValue = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_RELIEF_PAYER];
    NSDecimalNumber * reliefClaimValue = [self sumRelief:results byTagCode:TAG_TAX_CLAIM_CHILD];

    NSDecimalNumber * taxAdvanceValue = advanceBaseValue.payment;
    NSDecimalNumber * taxReliefValue = reliefPayerValue.taxRelief;

    NSDecimalNumber * reliefValue = [self reliefAmount:taxAdvanceValue withBaseRelief:taxReliefValue andClaims:reliefClaimValue];

    NSDictionary * resultValues = D_MAKE_HASH(@"tax_relief", reliefValue);

    return [PYGTaxReliefResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber *)reliefAmount:(NSDecimalNumber *)taxAdvance withBaseRelief:(NSDecimalNumber *)taxRelief andClaims:(NSDecimalNumber *)taxClaims {
    NSDecimalNumber * taxAfterRelief = [taxAdvance decimalNumberBySubtracting:taxRelief];
    NSDecimalNumber * taxClaimResult = [taxClaims decimalNumberBySubtracting:taxAfterRelief];
    NSDecimalNumber * taxClaimsMaxim = [self maxToZero:taxClaimResult];
    NSDecimalNumber * taxAfterClaims = [taxClaims decimalNumberBySubtracting:taxClaimsMaxim];
    return taxAfterClaims;
}

- (NSDecimalNumber *)sumRelief:(NSDictionary *)results byTagCode:(NSUInteger)tagCode {
    NSDictionary * resultHash = [results selectWithBlock:^BOOL (id key, id obj) {
        PYGTagRefer * tagRefer = (PYGTagRefer *)key;
        return (tagRefer.code==tagCode);
    }];
    NSDecimalNumber * resultSuma = [resultHash injectForDecimal:DECIMAL_ZERO with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGTaxReliefResult * tagResult = (PYGTaxReliefResult *)obj;
        return [agr decimalNumberByAdding:tagResult.taxRelief];
    }];
    return resultSuma;
}

@end