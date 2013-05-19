//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSavingsPensionsConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGInsuranceSocialBaseTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentDeductionResult.h"
#import "PYGXmlBuilder.h"


@implementation PYGSavingsPensionsConcept {

}
@synthesize interestCode = _interestCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_SAVINGS_PENSIONS] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGSavingsPensionsConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGSavingsPensionsConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGSavingsPensionsConcept *concept = [PYGSavingsPensionsConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
}

+(PYGSavingsPensionsConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGInsuranceSocialBaseTag)
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
    NSDecimalNumber * paymentIncome = DECIMAL_ZERO;
    if (self.isInterest==NO)
    {
        paymentIncome = DECIMAL_ZERO;
    }
    else
    {
        PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *)[self getResult:results byTagCode:TAG_INSURANCE_SOCIAL_BASE];
        paymentIncome = [self maxToZero:resultIncome.employerBase];
    }

    NSDecimalNumber * contPaymentValue = [self insuranceContribution:period withIncome:paymentIncome];

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", contPaymentValue);

    return [PYGPaymentDeductionResult newWithConcept:self andValues:resultValues];
}

-(NSDecimalNumber*) insuranceContribution:(PYGPayrollPeriod *)period withIncome:(NSDecimalNumber *)incomeBase {
    NSDecimalNumber * insuranceBase = [self maxToZero:incomeBase];

    NSDecimalNumber * pensionFactor = [self pensionInsuranceFactor:period.year];

    NSUInteger contPaymentValue = [self fixInsuranceRoundUp:[self bigDecimal:insuranceBase multiBy:pensionFactor]];
    return DECIMAL_NUMB(@(contPaymentValue));
}

- (BOOL)isInterest {
    return (self.interestCode!=0);
}

-(NSDecimalNumber*)pensionInsuranceFactor:(NSUInteger)year {
    double factor = 0.0;
    if (year < 2013)
    {
        factor = 0.0;
    }
    else
    {
        factor = 5.0;
    }
    return [self bigDecimal:@(factor) divBy:@(100)];
}

- (BOOL)exportXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"interest_code" : [@(self.interestCode) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"spec_value" withAttributes:attributes];
    return done;
}

@end