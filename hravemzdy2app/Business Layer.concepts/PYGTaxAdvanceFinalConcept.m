//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceFinalConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxAdvanceTag.h"
#import "PYGTaxReliefPayerTag.h"
#import "PYGTaxReliefChildTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGPaymentResult.h"
#import "PYGTaxReliefResult.h"
#import "PYGTaxAdvanceResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGTaxAdvanceFinalConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_ADVANCE_FINAL] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxAdvanceFinalConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxAdvanceFinalConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxAdvanceFinalConcept *concept = [PYGTaxAdvanceFinalConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxAdvanceFinalConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxAdvanceTag),
        TAG_NEW(PYGTaxReliefPayerTag),
        TAG_NEW(PYGTaxReliefChildTag)
    ];
}

- (NSArray *)summaryCodes {
    return @[
        TAG_NEW(PYGIncomeNettoTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_NETTO;
}

- (NSUInteger)typeOfResult {
    return TYPE_RESULT_DEDUCTION;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPaymentResult   * advanceBaseValue = (PYGPaymentResult *) [self getResult:results byTagCode:TAG_TAX_ADVANCE];
    PYGTaxReliefResult * reliefPayerValue = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_RELIEF_PAYER];
    PYGTaxReliefResult * reliefChildValue = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_RELIEF_CHILD];

    NSInteger advanceBase = [advanceBaseValue.payment integerValue];
    NSInteger reliefPayer = [reliefPayerValue.taxRelief integerValue];
    NSInteger reliefChild = [reliefChildValue.taxRelief integerValue];

    NSInteger taxAdvanceAfterA = [self advance:advanceBase afterReliefPayer:reliefPayer andChild:0];
    NSInteger taxAdvanceAfterC = [self advance:advanceBase afterReliefPayer:reliefPayer andChild:reliefChild];
    NSInteger taxAdvanceValue  = taxAdvanceAfterC;

    NSDictionary * resultValues = @{
        D_MAKE_PAIR(@"after_relief_A", @(taxAdvanceAfterA)),
        D_MAKE_PAIR(@"after_relief_C", @(taxAdvanceAfterC)),
        D_MAKE_PAIR(@"payment", @(taxAdvanceValue))
    };

    return [PYGTaxAdvanceResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)advance:(NSInteger)taxAdvance afterReliefPayer:(NSInteger)reliefPayer andChild:(NSInteger)reliefChild {
    return MAX(0, taxAdvance - reliefPayer - reliefChild);
}

@end