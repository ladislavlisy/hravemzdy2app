 //
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollResult.h"
#import "PYGSymbolTags.h"
#import "PYGIncomeNettoTag.h"
#import "PYGInsuranceHealthBaseTag.h"
#import "PYGPaymentDeductionResult.h"
#import "PYGIncomeBaseResult.h"


 @implementation PYGInsuranceHealthConcept

 @synthesize interestCode = _interestCode;

 - (id)initWithTagCode:(NSUInteger)tagCode  andValues:(NSDictionary *)values {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_INSURANCE_HEALTH] andTagCode:tagCode])) return nil;
    [self setupValues:values];
    return self;
}

+ (PYGInsuranceHealthConcept *)conceptWithTagCode:(NSUInteger)tagCode  andValues:(NSDictionary *)values {
    return [[self alloc] initWithTagCode:tagCode andValues:values];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGInsuranceHealthConcept*)newConceptWithCode:(NSUInteger)tagCode andValues:(NSDictionary *)values {
    PYGInsuranceHealthConcept *concept = [PYGInsuranceHealthConcept conceptWithTagCode:tagCode andValues:values];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _interestCode = U_SAFE_VALUES(@"interest_code");
}

+(PYGInsuranceHealthConcept *)concept
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
    if (self.isInterest==NO)
    {
        employerIncome = DECIMAL_ZERO;
        employeeIncome = DECIMAL_ZERO;
    }
    else
    {
        PYGIncomeBaseResult * resultIncome = (PYGIncomeBaseResult *)[self getResult:results byTagCode:TAG_INSURANCE_HEALTH_BASE];
        employerIncome = [self maxToZero:resultIncome.employerBase];
        employeeIncome = [self maxToZero:resultIncome.employeeBase];
    }

    NSDecimalNumber * contPaymentValue = [self insuranceContribution:period withIncomeEmployer:employerIncome employee:employeeIncome];

    NSDictionary * resultValues = D_MAKE_HASH(@"payment", contPaymentValue);

    return [PYGPaymentDeductionResult newWithConcept:self andValues:resultValues];
}

-(NSDecimalNumber *) insuranceContribution:(PYGPayrollPeriod *)period withIncomeEmployer:(NSDecimalNumber *)employerIncome employee:(NSDecimalNumber *)employeeIncome {
    NSDecimalNumber * employerBase = [self maxToBig:employerIncome andDecimal:employeeIncome];
    NSDecimalNumber * employeeSelf = [self maxToZero:[employeeIncome decimalNumberBySubtracting:employerIncome]];
    NSDecimalNumber * employeeBase = [self maxToZero:[employerBase decimalNumberBySubtracting:employeeSelf]];

    NSDecimalNumber * healthFactor = [self healthInsuranceFactor:period.year];

    NSDecimalNumber * emplPaymentSelfV = [self bigDecimal:employeeSelf multiBy:healthFactor];
    NSDecimalNumber * emplPaymentSelf3 = [self bigDecimal:[self bigDecimal:employeeBase multiBy:healthFactor] divBy:@(3)];
    NSUInteger contPaymentValue = [self fixInsuranceRoundUp:[emplPaymentSelfV decimalNumberByAdding:emplPaymentSelf3]];
    return DECIMAL_NUMB(@(contPaymentValue));
}

 - (BOOL)isInterest {
     return (self.interestCode!=0);
 }

 -(NSDecimalNumber*)healthInsuranceFactor:(NSUInteger)year {
    double factor = 0.0;
    if (year < 1993)
    {
        factor = 0.0;
    }
    else if (year < 2009)
    {
        factor = 13.5;
    }
    else
    {
        factor = 13.5;
    }
    return [self bigDecimal:@(factor) divBy:@(100)];
}
@end