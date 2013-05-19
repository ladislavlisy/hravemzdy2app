 //
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"
#import "PYGTaxAdvanceBaseTag.h"
#import "PYGXmlBuilder.h"

 @implementation PYGTaxAdvanceConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_ADVANCE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxAdvanceConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxAdvanceConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxAdvanceConcept *concept = [PYGTaxAdvanceConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxAdvanceConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxAdvanceBaseTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_NETTO;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_TAX_INCOME_BASE];
    PYGIncomeBaseResult * resultAdvance = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_TAX_ADVANCE_BASE];

    NSDecimalNumber * taxableIncome = resultIncome.incomeBase;
    NSDecimalNumber * taxablePartial = resultAdvance.incomeBase;

    NSInteger paymentValue = [self taxAdvCalculate:period withIncome:taxableIncome base:taxablePartial];

    NSDecimalNumber * resultPayment = DECIMAL_NUMB(@(paymentValue));

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", resultPayment);

    return [PYGPaymentResult newWithConcept:self andValues:resultValues];
}

-(NSInteger)taxAdvCalculate:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase {
    NSDecimalNumber * amountHundred = [[NSDecimalNumber alloc] initWithDouble:100.0f];
    if ([self isLessThenZero:taxBase]==YES)
    {
        return 0;
    }
    else if ([self isLessOrEq:taxBase thenDecimal:amountHundred])
    {
        return [self fixTaxRoundUp:[self bigDecimal:taxBase multiBy:[self taxAdvBracket1:period.year]]];
    }
    else
    {
        return [self taxAdvCalculateMonth:period withIncome:taxIncome base:taxBase];
    }
}

-(NSInteger)taxAdvCalculateMonth:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase {

    NSInteger taxStandard = 0;
    NSInteger taxSolidary = 0;
    if ([self isLessThenZero:taxBase]==YES)
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
        taxStandard = [self fixTaxRoundUp:[self bigDecimal:taxBase multiBy:[self taxAdvBracket1:period.year]]];
    }
    else
    {
        taxStandard = [self fixTaxRoundUp:[self bigDecimal:taxBase multiBy:[self taxAdvBracket1:period.year]]];
        NSDecimalNumber * maxBase = [self taxSolBracketMax:period.year];
        NSDecimalNumber * subBase = [taxIncome decimalNumberBySubtracting:maxBase];
        NSDecimalNumber * solBase = [self maxToBig:[NSDecimalNumber zero] andDecimal:subBase];
        taxSolidary = [self fixTaxRoundUp:[self bigDecimal:solBase multiBy:[self taxSolBracket:period.year]]];
    }
    return (taxStandard + taxSolidary);
}

-(NSDecimalNumber*)taxSolBracketMax:(NSUInteger)year {
    if (year >= 2013)
    {
        return [self bigDecimal:@(25884) multiBy:@(4)];
    }
    else
    {
        return [NSDecimalNumber zero];
    }
}

-(NSDecimalNumber*)taxAdvBracket1:(NSUInteger)year {
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

 -(NSDecimalNumber*)taxSolBracket:(NSUInteger)year {
    double factor = 0.0;
    if (year >= 2013)
    {
        factor = 7.0;
    }
    else
    {
        factor = 0.0;
    }
    return [self bigDecimal:@(factor) divBy:@(100)];
}

@end