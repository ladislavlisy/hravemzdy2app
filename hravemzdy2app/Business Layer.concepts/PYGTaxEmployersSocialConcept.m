//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersSocialConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGInsuranceSocialBaseTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"


@implementation PYGTaxEmployersSocialConcept {

}
@synthesize interestCode = _interestCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_EMPLOYERS_SOCIAL] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxEmployersSocialConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxEmployersSocialConcept *)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxEmployersSocialConcept *concept = [PYGTaxEmployersSocialConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
}

+(PYGTaxEmployersSocialConcept *)concept
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
    if (self.isInterest == NO) {
        paymentIncome = DECIMAL_ZERO;
    }
    else
    {
        PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_INSURANCE_SOCIAL_BASE];
        paymentIncome = [self maxToZero:resultIncome.employerBase];
    }

    NSInteger paymentValue = [self insurancePayment:period forIncome:paymentIncome];

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", DECIMAL_NUMB(@(paymentValue)));

    return [PYGPaymentResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)insurancePayment:(PYGPayrollPeriod *)period forIncome:(NSDecimalNumber *)paymentBase {
    NSDecimalNumber * socialFactor = [self socialInsuranceFactor:period];

    NSInteger contPaymentValue = [self fixInsuranceRoundUp:[self bigDecimal:paymentBase multiBy:socialFactor]];

    return contPaymentValue;
}

- (BOOL)isInterest {
    return (self.interestCode!=0);
}

- (NSDecimalNumber *)socialInsuranceFactor:(PYGPayrollPeriod *)period {
    double factor = 0.0;
    if (period.year<1993) {
        factor = 0.0;
    }
    else if(period.year<2009)
    {
        factor = 25.0;
    }
    else
    {
        factor = 25.0;
    }
    return [self bigDecimal:@(factor) divBy:@100];
}

@end