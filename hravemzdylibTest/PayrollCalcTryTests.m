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

@interface PayrollCalcTryTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcTryTests {

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


// A
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
    NSDecimalNumber * value_test01 = [self get_result_income_base:REF_TAX_INCOME_BASE];
    NSInteger value_test_number01  = value_test01.integerValue;

    STAssertTrue(value_test_number01==15000,  @"Tax Income Base amount should return %d, NOT %d!", 15000, value_test_number01);

    STAssertTrue(payment_base_number==20100,  @"Tax claim payer relief should return %d, NOT %d!", 20100, payment_base_number);
}

 // F
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

@end
