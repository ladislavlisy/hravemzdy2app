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
#import "PYGTaxReliefResult.h"
#import "PYGIncomeBaseResult.h"

@interface PayrollCalcTaxTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcTaxTests {

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
    self.payProcess = nil;
    [super tearDown];
}

// Insurance employee contribution:	 1 650 Kč
// Partial tax base:                20 100 Kč
// Tax before relief:	             3 015 Kč
// Tax advance:                        945 Kč
// Tax relief:                       2 070 Kč
// Tax bonus:                            0 Kč
// Net income:                      12 405 Kč

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxBaseAmount15_000CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_income_base:REF_TAX_INCOME_BASE];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==15000,  @"Tax Income Base amount should return %d, NOT %d!", 15000, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimPayerReliefValue2_070CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==2070,  @"Tax claim payer relief should return %d, NOT %d!", 2070, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimDisability01ReliefValue210CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code_1" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==210,  @"Tax claim payer disability A should return %d, NOT %d!", 210, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimDisability02ReliefValue420CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code_2" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==420,  @"Tax claim disability B relief should return %d, NOT %d!", 420, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimDisability03ReliefValue1_345CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code_3" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==1345,  @"Tax claim disability C relief should return %d, NOT %d!", 1345, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimStudyingReliefValue335CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_STUDYING];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==335,  @"Tax claim student relief should return %d, NOT %d!", 335, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxClaimChildReliefValue1_117CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGTaxReliefResult * resultValue = (PYGTaxReliefResult *)[evResultDictVal objectForKey:evResultTermTag];
    NSDecimalNumber * payment_base = resultValue.taxRelief;
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==1117,  @"Tax claim child relief should return %d, NOT %d!", 1117, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxAdvanceRoundedBaseValue20_100CZK
{
    NSDictionary * interestTermValues = @{ @"interest_code" : @1};
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evTaxIncTermRef = [PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE];
    PYGCodeNameRefer * evInsHltTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * evInsSocTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * evEmpHltTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];
    PYGCodeNameRefer * evEmpSocTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evTaxIncTermTag = [self.payProcess addTermTagRef:evTaxIncTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsHltTermTag = [self.payProcess addTermTagRef:evInsHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evInsSocTermTag = [self.payProcess addTermTagRef:evInsSocTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpHltTermTag = [self.payProcess addTermTagRef:evEmpHltTermRef andValues:interestTermValues];
    PYGTagRefer  * evEmpSocTermTag = [self.payProcess addTermTagRef:evEmpSocTermRef andValues:interestTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_income_base:REF_TAX_ADVANCE_BASE];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==20100,  @"Tax claim payer relief should return %d, NOT %d!", 20100, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxAmountBeforeReliefValue3_015CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"relief_code" : @1};

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
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_payment:REF_TAX_ADVANCE];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==3015,  @"Tax amount before relief should return %d, NOT %d!", 3015, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxAmountAfterPayerReliefValue945CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL];
    PYGCodeNameRefer * txReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * txReliefTermValues = @{ @"relief_code" : @1};
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
    PYGTagRefer  * txReliefTermTag = [self.payProcess addTermTagRef:txReliefTermRef andValues:txReliefTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * payment_base = [self get_result_payment:REF_TAX_ADVANCE_FINAL];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==945,  @"Tax amount after payer relief should return %d, NOT %d!", 945, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxAmountAfterPayerRelief_C_Value945CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL];
    PYGCodeNameRefer * ppReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
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

    NSDecimalNumber * paymentA_base = [self get_result_after_reliefA:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * paymentC_base = [self get_result_after_reliefC:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * paymentF_base = [self get_result_payment:REF_TAX_ADVANCE_FINAL];
    NSInteger paymentA_base_number  = paymentA_base.integerValue;
    NSInteger paymentC_base_number  = paymentC_base.integerValue;
    NSInteger paymentF_base_number  = paymentF_base.integerValue;

    STAssertTrue(paymentA_base_number==945,  @"Tax amount after payer relief A should return %d, NOT %d!", 945, paymentA_base_number);
    STAssertTrue(paymentC_base_number==945,  @"Tax amount after payer relief C should return %d, NOT %d!", 945, paymentC_base_number);
    STAssertTrue(paymentF_base_number==945,  @"Tax amount after payer relief should return %d, NOT %d!", 945, paymentF_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxAmountAfterChildRelief_C_Value0CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL];
    PYGCodeNameRefer * ppReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER];
    PYGCodeNameRefer * ccReliefTermRef = [PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
    NSDictionary * ccReliefTermValues = @{ @"relief_code" : @1};
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

    NSDecimalNumber * paymentA_base = [self get_result_after_reliefA:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * paymentC_base = [self get_result_after_reliefC:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * paymentF_base = [self get_result_payment:REF_TAX_ADVANCE_FINAL];
    NSInteger paymentA_base_number  = paymentA_base.integerValue;
    NSInteger paymentC_base_number  = paymentC_base.integerValue;
    NSInteger paymentF_base_number  = paymentF_base.integerValue;

    STAssertTrue(paymentA_base_number==945,  @"Tax amount after child relief A should return %d, NOT %d!", 945, paymentA_base_number);
    STAssertTrue(paymentC_base_number==0,    @"Tax amount after child relief C should return %d, NOT %d!", 0, paymentC_base_number);
    STAssertTrue(paymentF_base_number==0,    @"Tax amount after child relief should return %d, NOT %d!", 0, paymentF_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxBonusAfter_One_ChildRelief_Value172CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * ppReliefTermValues = @{ @"relief_code" : @1};
    NSDictionary * ccReliefTermValues = @{ @"relief_code" : @1};
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

    NSDecimalNumber * payment_base = [self get_result_payment:REF_TAX_BONUS_CHILD];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==172,  @"Tax bonus should return %d, NOT %d!", 172, payment_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_TaxBonusAfter_ZTP_ChildRelief_Value1_289CZK
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
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD];

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

    NSDecimalNumber * payment_base = [self get_result_payment:REF_TAX_BONUS_CHILD];
    NSInteger payment_base_number  = payment_base.integerValue;

    STAssertTrue(payment_base_number==1289,  @"Tax bonus should return %d, NOT %d!", 1289, payment_base_number);
}
@end
