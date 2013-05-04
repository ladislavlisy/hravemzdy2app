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
#import "PYGPayrollPeriod.h"
#import "PYGTagRefer.h"

#import <SenTestingKit/SenTestingKit.h>

@interface PayrollProcessSetupTests : SenTestCase

@property (nonatomic, readwrite) PYGPayTagGateway * payrollTags;
@property (nonatomic, readwrite) PYGPayConceptGateway * payConcepts;
@property (nonatomic, readwrite) PYGPayrollProcess * payProcess;

@end

@implementation PayrollProcessSetupTests {

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

- (void)testInsertingTermAndGetCodeOrderAtBeginning_Returns_1
{
    NSUInteger periodBase = PERIOD_NOW;
    PYGCodeNameRefer * tagCodeRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:3 andValues:@{ @"amount" : @(3000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:5 andValues:@{ @"amount" : @(5000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:4 andValues:@{ @"amount" : @(4000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:2 andValues:@{ @"amount" : @(2000) }];
    PYGTagRefer * payTag = [self.payProcess addTermTagRef:tagCodeRef andValues:@{ @"amount" : @(15000) }];
    STAssertTrue(payTag.codeOrder==1, @"Inserted term at begining should have codeOrder %d, NOT %d!", 1, payTag.codeOrder);
}

- (void)testInsertingTermAndGetCodeOrderInMiddle_Returns_3
{
    NSUInteger periodBase = PERIOD_NOW;
    PYGCodeNameRefer * tagCodeRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:5 andValues:@{ @"amount" : @(5000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:1 andValues:@{ @"amount" : @(1000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:4 andValues:@{ @"amount" : @(4000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:2 andValues:@{ @"amount" : @(2000) }];
    PYGTagRefer * payTag = [self.payProcess addTermTagRef:tagCodeRef andValues:@{ @"amount" : @(16000) }];
    STAssertTrue(payTag.codeOrder==3, @"Inserted term in middle should have codeOrder %d, NOT %d!", 3, payTag.codeOrder);
}

- (void)testInsertingTermAndGetCodeOrderAtEnd_Returns_6
{
    NSUInteger periodBase = PERIOD_NOW;
    PYGCodeNameRefer * tagCodeRef = [PYGSymbolTags codeRef:TAG_SALARY_BASE];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:3 andValues:@{ @"amount" : @(3000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:5 andValues:@{ @"amount" : @(5000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:1 andValues:@{ @"amount" : @(1000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:4 andValues:@{ @"amount" : @(4000) }];
    [self.payProcess insTermPeriodBase:periodBase tagRef:tagCodeRef tagOrder:2 andValues:@{ @"amount" : @(2000) }];
    PYGTagRefer * payTag = [self.payProcess addTermTagRef:tagCodeRef andValues:@{ @"amount" : @(17000) }];
    STAssertTrue(payTag.codeOrder==6, @"Inserted term at end should have codeOrder %d, NOT %d!", 6, payTag.codeOrder);
}

- (void)testPayrollPeriod_Returns_January2013
{
    NSUInteger periodCode = [[self.payProcess period] code];
    STAssertTrue(periodCode==201301, @"Should return payroll period january 2013 %d, NOT %d!", 201301, periodCode);
}

@end