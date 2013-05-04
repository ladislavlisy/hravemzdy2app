 //
// Created by lisy on 02.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGCodeNameRefer.h"
#import "PYGSymbolTags.h"
#import "PYGPayrollProcess.h"
#import "PYGTagRefer.h"
#import "PYGScheduleWeeklyConcept.h"
#import "PYGScheduleResult.h"
#import "PYGPaymentResult.h"
#import "PYGPayrollProcessTestCase.h"

@interface PayrollCalcIncomeTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcIncomeTests {

}
- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.payProcess = [PYGPayrollProcess payrollProcessWithPeriodYear:2013 andMonth:1
                                                              andTags:[self payrollTags] andConcepts:[self payConcepts]];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testSalaryBase15_000CZK_ShouldReturn_IncomeGrossValue15_000CZK
{
    NSDictionary * interestTermValues = @{ @"interest_code" : @1, @"declare_code" : @1 };
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];

    PYGCodeNameRefer * evTaxIncTermRef = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    PYGCodeNameRefer * evInsHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * evInsSocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * baseIHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];
    PYGCodeNameRefer * baseISocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];
    PYGCodeNameRefer * evEmpHltTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    PYGCodeNameRefer * evEmpSocTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];

    PYGCodeNameRefer * ppReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];

    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INCOME_GROSS];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
    NSDictionary * ccReliefTermValues = @{ @"relief_code" : @2};
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evTaxIncTermTag = [self.payProcess addTermTagRef:evTaxIncTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsHltTermTag = [self.payProcess addTermTagRef:evInsHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsSocTermTag = [self.payProcess addTermTagRef:evInsSocTermRef andValues:interestTermValues];
    PYGTagRefer  * baseIHltTermTag = [self.payProcess addTermTagRef:baseIHltTermRef andValues:interestTermValues];
    PYGTagRefer  * baseISocTermTag = [self.payProcess addTermTagRef:baseISocTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpHltTermTag = [self.payProcess addTermTagRef:evEmpHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpSocTermTag = [self.payProcess addTermTagRef:evEmpSocTermRef andValues:interestTermValues];
    PYGTagRefer  * ppReliefTermTag = [self.payProcess addTermTagRef:ppReliefTermRef andValues:ppReliefTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_amount:REF_INCOME_GROSS];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==15000,  @"Income Gross should return %d, NOT %d!", 15000, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_IncomeNettoValue12_405CZK
{
    NSDictionary * interestTermValues = @{ @"interest_code" : @1, @"declare_code" : @1 };
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];

    PYGCodeNameRefer * evTaxIncTermRef = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    PYGCodeNameRefer * evInsHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * evInsSocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * baseIHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];
    PYGCodeNameRefer * baseISocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];
    PYGCodeNameRefer * evEmpHltTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    PYGCodeNameRefer * evEmpSocTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];

    PYGCodeNameRefer * ppReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];

    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INCOME_NETTO];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
    NSDictionary * ccReliefTermValues = @{ @"relief_code" : @2};
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evTaxIncTermTag = [self.payProcess addTermTagRef:evTaxIncTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsHltTermTag = [self.payProcess addTermTagRef:evInsHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsSocTermTag = [self.payProcess addTermTagRef:evInsSocTermRef andValues:interestTermValues];
    PYGTagRefer  * baseIHltTermTag = [self.payProcess addTermTagRef:baseIHltTermRef andValues:interestTermValues];
    PYGTagRefer  * baseISocTermTag = [self.payProcess addTermTagRef:baseISocTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpHltTermTag = [self.payProcess addTermTagRef:evEmpHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpSocTermTag = [self.payProcess addTermTagRef:evEmpSocTermRef andValues:interestTermValues];
    PYGTagRefer  * ppReliefTermTag = [self.payProcess addTermTagRef:ppReliefTermRef andValues:ppReliefTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_amount:REF_INCOME_NETTO];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==12405,  @"Income Netto should return %d, NOT %d!", 12405, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_NettoIncomeWithBonusValue13_350_and_12_89CZK
{
    NSDictionary * interestTermValues = @{ @"interest_code" : @1, @"declare_code" : @1 };
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];

    PYGCodeNameRefer * evTaxIncTermRef = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    PYGCodeNameRefer * evInsHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * evInsSocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * baseIHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];
    PYGCodeNameRefer * baseISocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];
    PYGCodeNameRefer * evEmpHltTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    PYGCodeNameRefer * evEmpSocTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];

    PYGCodeNameRefer * ppReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];
    PYGCodeNameRefer * ccReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD];

    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INCOME_NETTO];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
    NSDictionary * ccReliefTermValues = @{ @"relief_code" : @2};
    NSDictionary * evResultTermValues = EMPTY_VALUES;

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evTaxIncTermTag = [self.payProcess addTermTagRef:evTaxIncTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsHltTermTag = [self.payProcess addTermTagRef:evInsHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsSocTermTag = [self.payProcess addTermTagRef:evInsSocTermRef andValues:interestTermValues];
    PYGTagRefer  * baseIHltTermTag = [self.payProcess addTermTagRef:baseIHltTermRef andValues:interestTermValues];
    PYGTagRefer  * baseISocTermTag = [self.payProcess addTermTagRef:baseISocTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpHltTermTag = [self.payProcess addTermTagRef:evEmpHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpSocTermTag = [self.payProcess addTermTagRef:evEmpSocTermRef andValues:interestTermValues];
    PYGTagRefer  * ppReliefTermTag = [self.payProcess addTermTagRef:ppReliefTermRef andValues:ppReliefTermValues];
    PYGTagRefer  * ccReliefTermTag = [self.payProcess addTermTagRef:ccReliefTermRef andValues:ccReliefTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_amount:REF_INCOME_NETTO];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==(13350+1289),  @"Income Netto should return %d, NOT %d!", (13350+1289), payment_base_number);
}

@end
