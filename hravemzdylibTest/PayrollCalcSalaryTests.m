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

@interface PayrollCalcSalaryTests : PYGPayrollProcessTestCase

@end

@implementation PayrollCalcSalaryTests {

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

- (void)testSalaryBase15_000CZK_ShouldReturn_SalaryValue15_000CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * evResultTermValues = @{ @"amount_monthly" : @15000};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGPaymentResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSDecimalNumber * salary_payment = [self get_result_payment:REF_SALARY_BASE];
    NSInteger salary_payment_number  = salary_payment.integerValue;

    STAssertTrue(salary_payment_number==15000,  @"Salary amount should return %d, NOT %d!", 15000, salary_payment_number);
}

- (void)testSalaryBase20_000CZK_ShouldReturn_SalaryValue15_000CZK
{
    PYGCodeNameRefer * scheduleWorkRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    PYGCodeNameRefer * scheduleTermRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_TERM];
    PYGCodeNameRefer * absencesTermRef = [PYGSymbolTags codeRef:TAG_HOURS_ABSENCE];
    PYGCodeNameRefer * evResultTermRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];

    NSDictionary * scheduleWorkValues = @{ @"hours_weekly" : @40 };
    NSDictionary * scheduleTermValues = EMPTY_VALUES;
    NSDictionary * absencesTermValues = @{ @"hours" : @46 };
    NSDictionary * evResultTermValues = @{ @"amount_monthly" : @20000};

    PYGTagRefer  * scheduleWorkTag = [self.payProcess addTermTagRef:scheduleWorkRef andValues:scheduleWorkValues];
    PYGTagRefer  * scheduleTermTag = [self.payProcess addTermTagRef:scheduleTermRef andValues:scheduleTermValues];
    PYGTagRefer  * absencesTermTag = [self.payProcess addTermTagRef:absencesTermRef andValues:absencesTermValues];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:evResultTermRef andValues:evResultTermValues];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    PYGPaymentResult * resultValue = [evResultDictVal objectForKey:evResultTermTag];

    NSDecimalNumber * salary_payment = [self get_result_payment:REF_SALARY_BASE];
    NSInteger salary_payment_number  = salary_payment.integerValue;

    STAssertTrue(salary_payment_number==15000,  @"Salary amount should return %d, NOT %d!", 15000, salary_payment_number);
}

@end
