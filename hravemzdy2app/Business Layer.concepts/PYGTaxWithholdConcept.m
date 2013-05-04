//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxWithholdBaseTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"
#import "PYGPaymentDeductionResult.h"


@implementation PYGTaxWithholdConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_WITHHOLD] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxWithholdConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxWithholdConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxWithholdConcept *concept = [PYGTaxWithholdConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxWithholdConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxWithholdBaseTag)
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
    PYGIncomeBaseResult * resultAdvance = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_TAX_WITHHOLD_BASE];

    NSDecimalNumber * taxableIncome = resultIncome.incomeBase;
    NSDecimalNumber * taxablePartial = resultAdvance.incomeBase;

    NSInteger paymentValue = [self taxWithholdCalculate:period withIncome:taxableIncome base:taxablePartial];

    NSDecimalNumber * resultPayment = DECIMAL_NUMB(@(paymentValue));

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", resultPayment);

    return [PYGPaymentDeductionResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)taxWithholdCalculate:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase {
    if ([self isLessOrEqZero:taxBase]) {
        return 0;
    }
    else
    {
        return [self taxWithholdCalculateMonth:period withIncome:taxIncome base:taxBase];
    }
}

- (NSUInteger)taxWithholdCalculateMonth:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase {
    if ([self isLessOrEqZero:taxBase]==YES)
    {
        return 0;
    }
    else
    if (period.year < 2008)
    {
        return 0;
    }
    else if (period.year < 2013)
    {
        return [self fixTaxRoundUp:[self bigDecimal:taxBase multiBy:[self taxAdvBracket1:period.year]]];
    }
    else
    {
        return [self fixTaxRoundUp:[self bigDecimal:taxBase multiBy:[self taxAdvBracket1:period.year]]];
    }
}

- (NSDecimalNumber*)taxAdvBracket1:(NSUInteger)year {
    double factor = 0.0;
    if (year >= 2009)
    {
        factor = 15.0;
    }
    else if (year == 2008)
    {
        factor = 15.0;
    }
    else if (year >= 2006)
    {
        factor = 12.0;
    }
    else
    {
        factor = 15.0;
    }
    return [self bigDecimal:@(factor) divBy:@(100)];
}

@end