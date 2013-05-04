//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersHealthConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGInsuranceHealthBaseTag.h"
#import "PYGIncomeNettoTag.h"
#import "PYGPaymentResult.h"
#import "PYGIncomeBaseResult.h"


@implementation PYGTaxEmployersHealthConcept {

}
@synthesize interestCode = _interestCode;

- (id)initWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_TAX_EMPLOYERS_HEALTH] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGTaxEmployersHealthConcept *)conceptWithTagCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGTaxEmployersHealthConcept *)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGTaxEmployersHealthConcept *concept = [PYGTaxEmployersHealthConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
}

+(PYGTaxEmployersHealthConcept *)concept
{
    return [[self alloc] initWithTagCode:TAG_UNKNOWN andValues:EMPTY_VALUES];
}

- (NSArray *)pendingCodes {
    return @[
        TAG_NEW(PYGInsuranceHealthBaseTag)
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
    NSDecimalNumber * employerIncome = DECIMAL_ZERO;
    NSDecimalNumber * employeeIncome = DECIMAL_ZERO;
    if (self.isInterest == NO) {
        employerIncome = DECIMAL_ZERO;
        employeeIncome = DECIMAL_ZERO;
    }
    else
    {
        PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *) [self getResult:results byTagCode:TAG_INSURANCE_HEALTH_BASE];
        employerIncome = [self maxToZero:resultIncome.employerBase];
        employeeIncome = [self maxToZero:resultIncome.employeeBase];
    }

    NSInteger paymentValue = [self insurancePayment:period forEmployerIncome:employerIncome andEmployeeIncome:employeeIncome];

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", DECIMAL_NUMB(@(paymentValue)));

    return [PYGPaymentResult newWithConcept:self andValues:resultValues];
}

- (NSInteger)insurancePayment:(PYGPayrollPeriod *)period forEmployerIncome:(NSDecimalNumber *)employerIncome andEmployeeIncome:(NSDecimalNumber *)employeeIncome {
    NSDecimalNumber * employerBase = [self maxToBig:employerIncome andDecimal:employeeIncome];
    NSDecimalNumber * employeeSelf = [self maxToZero:[employeeIncome decimalNumberBySubtracting:employerIncome]];
    NSDecimalNumber * employeeBase = [self maxToZero:[employerBase decimalNumberBySubtracting:employeeSelf]];

    NSDecimalNumber * healthFactor = [self healthInsuranceFactor:period];

    NSInteger sumaPaymentValue = [self fixInsuranceRoundUp:[self bigDecimal:employerBase multiBy:healthFactor]];
    NSDecimalNumber * insuranceEmployeeSelf = [self bigDecimal:employeeSelf multiBy:healthFactor];
    NSDecimalNumber * insuranceEmployeeRegs = [self bigDecimal:employeeBase multiBy:healthFactor divBy:@(3)];
    NSDecimalNumber * insuranceEmployeeSuma = [insuranceEmployeeSelf decimalNumberByAdding:insuranceEmployeeRegs];
    NSInteger emplPaymentValue = [self fixInsuranceRoundUp:insuranceEmployeeSuma];
    NSInteger contPaymentValue = sumaPaymentValue - emplPaymentValue;

    return contPaymentValue;
}

- (BOOL)isInterest {
    return (self.interestCode!=0);
}

- (NSDecimalNumber *)healthInsuranceFactor:(PYGPayrollPeriod *)period {
    double factor = 0.0;
    if (period.year<1993) {
        factor = 0.0;
    }
    else if(period.year<2009)
    {
        factor = 13.5;
    }
    else
    {
        factor = 13.5;
    }
    return [self bigDecimal:@(factor) divBy:@100];
}

@end