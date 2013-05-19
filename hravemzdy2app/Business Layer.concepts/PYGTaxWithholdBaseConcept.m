//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdBaseConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGTaxEmployersHealthTag.h"
#import "PYGTaxEmployersSocialTag.h"
#import "PYGTaxIncomeBaseTag.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGTaxWithholdBaseConcept {

}

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_WITHHOLD_BASE] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxWithholdBaseConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxWithholdBaseConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxWithholdBaseConcept *concept = [PYGTaxWithholdBaseConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+(PYGTaxWithholdBaseConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGTaxIncomeBaseTag),
        TAG_NEW(PYGTaxEmployersSocialTag),
        TAG_NEW(PYGTaxEmployersHealthTag)
    ];
}

- (NSUInteger)calcCategory {
    return CALC_CATEGORY_NETTO;
}

- (PYGPayrollResult*)evaluateForPeriod:(PYGPayrollPeriod *)period config:(PYGPayTagGateway *)config results:(NSDictionary *)results {
    PYGPaymentResult * healthEmployer = (PYGPaymentResult *) [self getResult:results byTagCode:TAG_TAX_EMPLOYERS_HEALTH];
    PYGPaymentResult * socialEmployer = (PYGPaymentResult *) [self getResult:results byTagCode:TAG_TAX_EMPLOYERS_SOCIAL];
    PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_TAX_INCOME_BASE];

    BOOL isTaxInterest = resultIncome.isInterest;
    BOOL isTaxDeclared = resultIncome.isDeclared;

    NSDecimalNumber * taxableSuper = DECIMAL_ZERO;
    NSDecimalNumber * taxableBase  = DECIMAL_ZERO;
    if (isTaxInterest==NO) {
        taxableBase  = DECIMAL_ZERO;
        taxableSuper = DECIMAL_ZERO;
    }
    else
    {
        taxableBase   = resultIncome.incomeBase;
        NSDecimalNumber * taxableHealth = healthEmployer.payment;
        NSDecimalNumber * taxableSocial = socialEmployer.payment;

        taxableSuper = [[taxableBase decimalNumberByAdding:taxableHealth] decimalNumberByAdding:taxableSocial];

    }
    NSDecimalNumber * paymentValue = [self taxRoundedBase:period withDecl:isTaxDeclared income:taxableBase base:taxableSuper];

    NSDictionary * resultValues = D_MAKE_HASH(@"income_base", paymentValue);

    return [PYGIncomeBaseResult newWithConcept:self andValues:resultValues];
}

- (NSDecimalNumber *)taxRoundedBase:(PYGPayrollPeriod *)period withDecl:(BOOL)taxDecl income:(NSDecimalNumber *)taxIncome base:(NSDecimalNumber *)taxBase {
    if (taxDecl == YES)
    {
        return DECIMAL_ZERO;
    }
    else
    {
        NSInteger taxIncomeLimitInt = [self taxWithholdMax:period.year];
        NSDecimalNumber * taxIncomeLimitDec = DECIMAL_NUMB(@(taxIncomeLimitInt));

        if ([self isGreater:taxIncome thenDecimal:taxIncomeLimitDec]) {
            return DECIMAL_ZERO;
        }
        else
        {
            return [self withholdRoundedBase:period withDecl:taxDecl base:taxBase];
        }
    }
}

- (NSDecimalNumber *)withholdRoundedBase:(PYGPayrollPeriod *)period withDecl:(BOOL)taxDecl base:(NSDecimalNumber *)taxBase {
    NSDecimalNumber * amountForCalc = [self maxToZero:taxBase];
    return [self bigTaxRoundDown:amountForCalc];
}

- (NSInteger)taxWithholdMax:(NSUInteger)year {
    if (year>=2004)
    {
        return 5000;
    }
    else if (year>=2001)
    {
        return 3000;
    }
    else
    {
        return 2000;
    }
}

@end