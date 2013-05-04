//
// Created by Ladislav Lisy on 20.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "PYGPayrollProcessTestCase.h"
#import "PYGPayrollProcess.h"
#import "PYGCodeNameRefer.h"
#import "PYGTagRefer.h"
#import "PYGScheduleResult.h"
#import "NSDictionary+Func.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPaymentResult.h"
#import "PYGTaxAdvanceResult.h"
#import "PYGAmountResult.h"
#import "PYGSymbolTags.h"
#import "PYGPayTagGateway.h"
#import "PYGPayConceptGateway.h"
#import "PYGTaxReliefResult.h"


@implementation PYGPayrollProcessTestCase : SenTestCase {
}
@synthesize payrollTags = _payrollTags;
@synthesize payConcepts = _payConcepts;
@synthesize payProcess = _payProcess;

- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];

    REF_SCHEDULE_WORK          = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    REF_SCHEDULE_TERM          = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    REF_HOURS_ABSENCE          = [PYGSymbolTags codeRef:TAG_HOURS_ABSENCE];
    REF_SALARY_BASE            = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    REF_TAX_INCOME_BASE        = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    REF_INSURANCE_HEALTH_BASE  = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    REF_INSURANCE_HEALTH       = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];
    REF_INSURANCE_SOCIAL_BASE  = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    REF_INSURANCE_SOCIAL       = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];
    REF_SAVINGS_PENSIONS       = [PYGSymbolTags codeRef:TAG_SAVINGS_PENSIONS];
    REF_TAX_CLAIM_PAYER        = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];
    REF_TAX_CLAIM_CHILD        = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD];
    REF_TAX_CLAIM_DISABILITY   = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY];
    REF_TAX_CLAIM_STUDYING     = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_STUDYING];
    REF_TAX_EMPLOYERS_HEALTH   = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    REF_TAX_EMPLOYERS_SOCIAL   = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];
    REF_TAX_ADVANCE_BASE       = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_BASE];
    REF_TAX_ADVANCE            = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE];
    REF_TAX_WITHHOLD_BASE      = [PYGSymbolTags codeRef:TAG_TAX_WITHHOLD_BASE];
    REF_TAX_WITHHOLD           = [PYGSymbolTags codeRef:TAG_TAX_WITHHOLD];
    REF_TAX_RELIEF_PAYER       = [PYGSymbolTags codeRef:TAG_TAX_RELIEF_PAYER];
    REF_TAX_ADVANCE_FINAL      = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL];
    REF_TAX_RELIEF_CHILD       = [PYGSymbolTags codeRef:TAG_TAX_RELIEF_CHILD];
    REF_TAX_BONUS_CHILD        = [PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD];
    REF_INCOME_GROSS           = [PYGSymbolTags codeRef:TAG_INCOME_GROSS];
    REF_INCOME_NETTO           = [PYGSymbolTags codeRef:TAG_INCOME_NETTO];
    TAX_PAYER                  = 1;
    TAX_DECLARED               = 3;
}

- (NSDecimalNumber *)get_result_income_base:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGIncomeBaseResult * resultObj = (PYGIncomeBaseResult *)obj;
        return [agr decimalNumberByAdding:resultObj.incomeBase];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_payment:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGPaymentResult * resultObj = (PYGPaymentResult *)obj;
        return [agr decimalNumberByAdding:resultObj.payment];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_employee_base:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGIncomeBaseResult * resultObj = (PYGIncomeBaseResult *)obj;
        return [agr decimalNumberByAdding:resultObj.employeeBase];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_tax_relief:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGTaxReliefResult * resultObj = (PYGTaxReliefResult *)obj;
        return [agr decimalNumberByAdding:resultObj.taxRelief];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_after_reliefA:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGTaxAdvanceResult * resultObj = (PYGTaxAdvanceResult *)obj;
        return [agr decimalNumberByAdding:resultObj.afterReliefA];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_after_reliefC:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGTaxAdvanceResult * resultObj = (PYGTaxAdvanceResult *)obj;
        return [agr decimalNumberByAdding:resultObj.afterReliefC];
    }];
    return resultValue;
}

- (NSDecimalNumber *)get_result_amount:(PYGCodeNameRefer *) tagRefer {
    NSDictionary * results = [self.payProcess getResults];

    NSDictionary *resultSelect= [self getResultsDictionary:results byTagCode:tagRefer.code];

    NSDecimalNumber * resultValue = [resultSelect injectForDecimal:(DECIMAL_ZERO) with:^NSDecimalNumber * (NSDecimalNumber * agr, id key, id obj) {
        PYGAmountResult * resultObj = (PYGAmountResult *)obj;
        return [agr decimalNumberByAdding:resultObj.amount];
    }];
    return resultValue;
}

- (NSDictionary *)getResultsDictionary:(NSDictionary *)results byTagCode:(NSUInteger)tagCode {
    NSDictionary * resultSelect = [results selectWithBlock:^BOOL (id key, id obj) {
        PYGTagRefer * keyRef = (PYGTagRefer *)key;
        return (keyRef.code == tagCode);
    }];
    return resultSelect;
}

@end
