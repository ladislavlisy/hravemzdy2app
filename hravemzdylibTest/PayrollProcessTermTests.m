//
// Created by lisy on 02.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollProcess.h"
#import "PYGSymbolTags.h"
#import "PYGSalaryMonthlyConcept.h"
#import "PYGScheduleWeeklyConcept.h"

#import <SenTestingKit/SenTestingKit.h>

@interface PayrollProcessTermTests : SenTestCase

@property (nonatomic, readwrite) PYGPayTagGateway * payrollTags;
@property (nonatomic, readwrite) PYGPayConceptGateway * payConcepts;
@property (nonatomic, readwrite) PYGPayrollProcess * payProcess;

@end

@implementation PayrollProcessTermTests {

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

- (void)testWorkingSchedule_Returns_WeeklyScheduleHours40
{
    PYGCodeNameRefer * tagCodeRef = [PYGSymbolTags codeRef:TAG_SCHEDULE_WORK];
    NSDictionary * tagValues = @{ @"hours_weekly" : @(40) };
    PYGTagRefer * payTag = [self.payProcess addTermTagRef:tagCodeRef andValues:tagValues];
    NSDictionary * payTer = [self.payProcess getTerm:payTag];
    PYGScheduleWeeklyConcept * concept = (PYGScheduleWeeklyConcept*)payTer[payTag];
    STAssertTrue(concept.hoursWeekly==40, @"Should return hours weekly %d, NOT %d!", 40, concept.hoursWeekly);
}

- (void)testBaseSalary_Returns_MonthlyAmount15000CZK
{
    PYGCodeNameRefer * tagCodeRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    NSDictionary * tagValues = @{ @"amount_monthly" : @(15000) };
    PYGTagRefer * payTag = [self.payProcess addTermTagRef:tagCodeRef andValues:tagValues];
    NSDictionary * payTer = [self.payProcess getTerm:payTag];
    PYGSalaryMonthlyConcept * concept = (PYGSalaryMonthlyConcept*)payTer[payTag];
    NSInteger conceptValue = concept.amountMonthly.integerValue;
    STAssertTrue(conceptValue==15000, @"Should return hours weekly %d, NOT %d!", 15000, conceptValue);
}

@end