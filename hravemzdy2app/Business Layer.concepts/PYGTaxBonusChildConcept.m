//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxBonusChildConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGIncomeNettoTag.h"
#import "PYGTaxAdvanceTag.h"
#import "PYGTaxReliefPayerTag.h"
#import "PYGTaxReliefChildTag.h"
#import "NSDictionary+Func.h"
#import "PYGTagRefer.h"
#import "PYGTaxReliefResult.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"
#import "PYGTaxAdvanceResult.h"


@implementation PYGTaxBonusChildConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_BONUS_CHILD] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxBonusChildConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxBonusChildConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxBonusChildConcept *concept = [PYGTaxBonusChildConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxBonusChildConcept *)concept
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

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_TAX_INCOME_BASE];
    BOOL isTaxInterest = resultIncome.isInterest;
    NSInteger taxAdvanceValue = 0;
    if (isTaxInterest == NO) {
        taxAdvanceValue = 0;
    }
    else
    {
        PYGTaxAdvanceResult * advanceBaseValue = (PYGTaxAdvanceResult *) [self getResult:results byTagCode:TAG_TAX_ADVANCE];
        PYGTaxReliefResult * reliefPayerValue = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_RELIEF_PAYER];
        PYGTaxReliefResult * reliefChildValue = (PYGTaxReliefResult *) [self getResult:results byTagCode:TAG_TAX_RELIEF_CHILD];

        NSInteger advanceBase = DECIMAL_INT(advanceBaseValue.payment);
        NSInteger reliefPayer = DECIMAL_INT(reliefPayerValue.taxRelief);
        NSInteger reliefChild = DECIMAL_INT(reliefChildValue.taxRelief);
        NSInteger reliefClaimValue = [self sumRelief:results byTagCode:TAG_TAX_CLAIM_CHILD];

        NSInteger reliefBonusValue = [self bonusAfterRelief:advanceBase payer:reliefPayer child:reliefChild claims:reliefClaimValue];
        taxAdvanceValue  = [self maxMinBonus:period.year fromBonus:reliefBonusValue];
    }

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", DECIMAL_NUMB(@(taxAdvanceValue)));

    return [PYGPaymentResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)sumRelief:(NSDictionary *)results byTagCode:(NSUInteger)payTag {
    NSDictionary * resultHash = [results selectWithBlock:^BOOL (id key, id obj) {
        return ((PYGTagRefer*)key).code == payTag;
    }];
    NSDecimalNumber * resultSuma = [resultHash injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id item) {
      return [agr decimalNumberByAdding:((PYGTaxReliefResult*)item).taxRelief];
    }];
    return [resultSuma integerValue];
}

- (NSInteger)bonusAfterRelief:(NSInteger)taxAdvance payer:(NSInteger)reliefPayer child:(NSInteger)reliefChild claims:(NSInteger)claimsChild {
    NSInteger bonusForChild = -MIN(0, reliefChild - claimsChild);
    if (bonusForChild >= 50) {
        return bonusForChild;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)maxMinBonus:(NSUInteger)year fromBonus:(NSInteger)taxChildBonus {
    if (taxChildBonus < [self minBonusMonthly:year]) {
        return 0;
    }
    else
    {
        NSInteger maxBonusValue = [self maxBonusMonthly:year];
        if (taxChildBonus > maxBonusValue) {
            return maxBonusValue;
        }
        else
        {
            return taxChildBonus;
        }
    }
}

- (NSInteger)maxBonusMonthly:(NSUInteger)year {
    if (year>=2012)
    {
        return 5025;
    }
    else if (year>=2009)
    {
        return 4350;
    }
    else if (year==2008)
    {
        return 4350;
    }
    else if (year>=2005)
    {
        return 2500;
    }
    else
    {
        return 0;
    }
}

- (NSInteger)minBonusMonthly:(NSUInteger)year {
    if (year>=2005)
    {
        return 50;
    }
    else
    {
        return 0;
    }
}

@end