//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefPayerConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxAdvanceTag.h"
#import "PYGTaxClaimPayerTag.h"
#import "PYGTaxClaimDisabilityTag.h"
#import "PYGTaxClaimStudyingTag.h"
#import "PYGPaymentResult.h"
#import "PYGTaxReliefResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGTaxReliefPayerConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_RELIEF_PAYER] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxReliefPayerConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxReliefPayerConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxReliefPayerConcept *concept = [PYGTaxReliefPayerConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxReliefPayerConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxAdvanceTag),
        TAG_NEW(PYGTaxClaimPayerTag),
        TAG_NEW(PYGTaxClaimDisabilityTag),
        TAG_NEW(PYGTaxClaimStudyingTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_NETTO;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_SUMMARY;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPaymentResult * advanceBaseValue = (PYGPaymentResult *) [self getResult:results byTagCode:TAG_TAX_ADVANCE];
    PYGTaxReliefResult * reliefClaimPayer = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_CLAIM_PAYER];
    PYGTaxReliefResult * reliefClaimDisab = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_CLAIM_DISABILITY];
    PYGTaxReliefResult * reliefClaimStudy = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_CLAIM_STUDYING];

    NSDecimalNumber * taxAdvanceValue = advanceBaseValue.payment;
    NSDecimalNumber * taxReliefValue = DECIMAL_ZERO;
    NSDecimalNumber * claimsValPayer = reliefClaimPayer.taxRelief;
    NSDecimalNumber * claimsValDisab = reliefClaimDisab.taxRelief;
    NSDecimalNumber * claimsValStudy = reliefClaimStudy.taxRelief;

    NSDecimalNumber * taxClaimsValue = [claimsValPayer decimalNumberByAdding:[claimsValDisab decimalNumberByAdding:claimsValStudy]];

    NSDecimalNumber * reliefValue = [self reliefAmount:taxAdvanceValue withBaseRelief:taxReliefValue andClaims:taxClaimsValue];

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

@end