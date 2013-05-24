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

@interface PayrollCalcInsuranceTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcInsuranceTests {

}
- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];
    self.payProcess = [PYGPayrollProcess payrollProcessWithPeriodYear:2013 andMonth:1
                                                              andTags:[self payrollTags] andConcepts:[self payConcepts]];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)testSalaryBase15_000CZK_ShouldReturn_InsuranceHealthBaseAmount15_000CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * insurance_base = [self get_result_income_base:REF_INSURANCE_HEALTH_BASE];
    NSInteger insurance_base_number  = insurance_base.integerValue;

    STAssertTrue(insurance_base_number==15000,  @"Insurance base amount should return %d, NOT %d!", 15000, insurance_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_InsuranceSocialBaseAmount15_000CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * insurance_base = [self get_result_income_base:REF_INSURANCE_SOCIAL_BASE];
    NSInteger insurance_base_number  = insurance_base.integerValue;

    STAssertTrue(insurance_base_number==15000,  @"Insurance base amount should return %d, NOT %d!", 15000, insurance_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_InsuranceHealthAmount675CZK
{
    PYGCodeNameRefer * evInBaseTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH];

    NSDictionary * evInBaseTermValues = @{ @"interest_code" : @1};
    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * evInBaseTermTag = [self.payProcess addTermTagRef:evInBaseTermRef andValues:evInBaseTermValues];
    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * insurance_payment = [self get_result_payment:REF_INSURANCE_HEALTH];
    NSInteger insurance_payment_number  = insurance_payment.integerValue;

    STAssertTrue(insurance_payment_number==675,  @"Insurance payment should return %d, NOT %d!", 675, insurance_payment_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_InsuranceSocialAmount975CZK
{
    PYGCodeNameRefer * evInBaseTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL];

    NSDictionary * evInBaseTermValues = @{ @"interest_code" : @1};
    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * evInBaseTermTag = [self.payProcess addTermTagRef:evInBaseTermRef andValues:evInBaseTermValues];
    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * insurance_payment = [self get_result_payment:REF_INSURANCE_SOCIAL];
    NSInteger insurance_payment_number  = insurance_payment.integerValue;

    STAssertTrue(insurance_payment_number==975,  @"Insurance payment should return %d, NOT %d!", 975, insurance_payment_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_EmployerHealthTaxBaseAmount1_350CZK
{
    PYGCodeNameRefer * evInBaseTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE];
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH];

    NSDictionary * evInBaseTermValues = @{ @"interest_code" : @1};
    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * evInBaseTermTag = [self.payProcess addTermTagRef:evInBaseTermRef andValues:evInBaseTermValues];
    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * employer_base = [self get_result_payment:REF_TAX_EMPLOYERS_HEALTH];
    NSInteger employer_base_number  = employer_base.integerValue;

    STAssertTrue(employer_base_number==1350,  @"LABELED_EMPLOYER Tax Base should return %d, NOT %d!", 1350, employer_base_number);
}

- (void)testSalaryBase15_000CZK_ShouldReturn_EmployerSocialTaxBaseAmount3_750CZK
{
    PYGCodeNameRefer * evInBaseTermRef = [PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE];
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evSalaryTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL];

    NSDictionary * evInBaseTermValues = @{ @"interest_code" : @1};
    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evSalaryTermValues = @{ @"amount_monthly" : @15000};
    NSDictionary * evResultTermValues = @{ @"interest_code" : @1};

    PYGTagRefer  * evInBaseTermTag = [self.payProcess addTermTagRef:evInBaseTermRef andValues:evInBaseTermValues];
    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evSalaryTermTag = [self.payProcess addTermTagRef:evSalaryTermRef andValues:evSalaryTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDecimalNumber * employer_base = [self get_result_payment:REF_TAX_EMPLOYERS_SOCIAL];
    NSInteger employer_base_number  = employer_base.integerValue;

    STAssertTrue(employer_base_number==3750,  @"LABELED_EMPLOYER Tax Base should return %d, NOT %d!", 3750, employer_base_number);
}

@end
