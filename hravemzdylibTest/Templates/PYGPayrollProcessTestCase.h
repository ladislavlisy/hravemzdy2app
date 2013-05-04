//
// Created by Ladislav Lisy on 20.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import "PYGCodeNameRefer.h"

@class PYGPayTagGateway;
@class PYGPayConceptGateway;
@class PYGPayrollProcess;

@interface PYGPayrollProcessTestCase : SenTestCase {
    PYGCodeNameRefer * REF_SCHEDULE_WORK         ;
    PYGCodeNameRefer * REF_SCHEDULE_TERM         ;
    PYGCodeNameRefer * REF_HOURS_ABSENCE         ;
    PYGCodeNameRefer * REF_SALARY_BASE           ;
    PYGCodeNameRefer * REF_TAX_INCOME_BASE       ;
    PYGCodeNameRefer * REF_INSURANCE_HEALTH_BASE ;
    PYGCodeNameRefer * REF_INSURANCE_HEALTH      ;
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL_BASE ;
    PYGCodeNameRefer * REF_INSURANCE_SOCIAL      ;
    PYGCodeNameRefer * REF_SAVINGS_PENSIONS      ;
    PYGCodeNameRefer * REF_TAX_CLAIM_PAYER       ;
    PYGCodeNameRefer * REF_TAX_CLAIM_CHILD       ;
    PYGCodeNameRefer * REF_TAX_CLAIM_DISABILITY  ;
    PYGCodeNameRefer * REF_TAX_CLAIM_STUDYING    ;
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_HEALTH  ;
    PYGCodeNameRefer * REF_TAX_EMPLOYERS_SOCIAL  ;
    PYGCodeNameRefer * REF_TAX_ADVANCE_BASE      ;
    PYGCodeNameRefer * REF_TAX_ADVANCE           ;
    PYGCodeNameRefer * REF_TAX_WITHHOLD_BASE     ;
    PYGCodeNameRefer * REF_TAX_WITHHOLD          ;
    PYGCodeNameRefer * REF_TAX_RELIEF_PAYER      ;
    PYGCodeNameRefer * REF_TAX_ADVANCE_FINAL     ;
    PYGCodeNameRefer * REF_TAX_RELIEF_CHILD      ;
    PYGCodeNameRefer * REF_TAX_BONUS_CHILD       ;
    PYGCodeNameRefer * REF_INCOME_GROSS          ;
    PYGCodeNameRefer * REF_INCOME_NETTO          ;
    NSUInteger TAX_PAYER;
    NSUInteger TAX_DECLARED;
}

@property (nonatomic, readwrite) PYGPayTagGateway * payrollTags;
@property (nonatomic, readwrite) PYGPayConceptGateway * payConcepts;
@property (nonatomic, readwrite) PYGPayrollProcess * payProcess;

- (NSDecimalNumber *)get_result_income_base:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_payment:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_employee_base:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_tax_relief:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_after_reliefA:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_after_reliefC:(PYGCodeNameRefer *)tagRefer;

- (NSDecimalNumber *)get_result_amount:(PYGCodeNameRefer *)tagRefer;

@end