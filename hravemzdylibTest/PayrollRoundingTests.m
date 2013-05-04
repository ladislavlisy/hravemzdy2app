//
//  PayrollRoundingTests.m
//  PayrollRoundingTests
//
//  Created by Ladislav Lisy on 03/31/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGPayrollPeriod.h"
#import "PYGPayrollConcept.h"
#import "PYGTaxAdvanceBaseConcept.h"
#import "PYGTaxAdvanceConcept.h"
#import "PYGInsuranceHealthConcept.h"
#import "PYGInsuranceSocialConcept.h"

#import <SenTestingKit/SenTestingKit.h>

@interface PayrollRoundingTests : SenTestCase

@property (nonatomic, readwrite) PYGPayrollPeriod * payPeriod;
@property (nonatomic, readwrite) PYGPayTagGateway * payrollTags;
@property (nonatomic, readwrite) PYGPayConceptGateway * payConcepts;

@end

@implementation PayrollRoundingTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
    self.payPeriod   = [PYGPayrollPeriod payrollPeriodWithYear:2013 andMonth:1];
    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];
//    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, @period)
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// Tax base under 100 CZK should be round up to 1 CZK
- (void)testTaxBaseUnder100CZK_ShouldBe_RoundedUpTo1CZK
{
    PYGTaxAdvanceBaseConcept * testConcept = [PYGTaxAdvanceBaseConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:99.0];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:99.1];
    NSDecimalNumber * test3 = [[NSDecimalNumber alloc] initWithDouble:100.0];
    NSDecimalNumber * base1 = [[NSDecimalNumber alloc] initWithDouble:99.0];
    NSDecimalNumber * base2 = [[NSDecimalNumber alloc] initWithDouble:100.0];
    BOOL taxDecl = YES;
    NSDecimalNumber * result1 = [testConcept taxRoundedBase:self.payPeriod withDecl:taxDecl income:test1 base:test1];
    NSDecimalNumber * result2 = [testConcept taxRoundedBase:self.payPeriod withDecl:taxDecl income:test2 base:test2];
    NSDecimalNumber * result3 = [testConcept taxRoundedBase:self.payPeriod withDecl:taxDecl income:test3 base:test3];
    STAssertTrue([result1 isEqual:base1], @"Tax base %@ CZK should be round up to %@ CZK, NOT %@ CZK!", test1.stringValue, base1.stringValue, result1.stringValue);
    STAssertTrue([result2 isEqual:base2], @"Tax base %@ CZK should be round up to %@ CZK, NOT %@ CZK!", test2.stringValue, base2.stringValue, result2.stringValue);
    STAssertTrue([result3 isEqual:base2], @"Tax base %@ CZK should be round up to %@ CZK, NOT %@ CZK!", test3.stringValue, base2.stringValue, result3.stringValue);
}

// 'Tax base over 100 CZK should be round up to 100 CZK'
- (void)testTaxBaseOver100CZK_ShouldBe_RoundedUpTo100CZK
{
    PYGTaxAdvanceBaseConcept * testConcept = [PYGTaxAdvanceBaseConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:100.1];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:101.0];
    NSDecimalNumber * base1 = [[NSDecimalNumber alloc] initWithDouble:200.0];
    BOOL taxDecl = YES;
    NSDecimalNumber * result1 = [testConcept taxRoundedBase:self.payPeriod withDecl:taxDecl income:test1 base:test1];
    NSDecimalNumber * result2 = [testConcept taxRoundedBase:self.payPeriod withDecl:taxDecl income:test2 base:test2];
    STAssertTrue([result1 isEqual:base1], @"Tax base %@ CZK should be round up to %@ CZK, NOT %@ CZK!", test1.stringValue, base1.stringValue, result1.stringValue);
    STAssertTrue([result2 isEqual:base1], @"Tax base %@ CZK should be round up to %@ CZK, NOT %@ CZK!", test2.stringValue, base1.stringValue, result2.stringValue);
}

// 'Tax advance from negative base should be 0 CZK'
- (void)testTaxAdvanceFromNegativeBase_ShouldBe_RoundedUpTo1CZK
{
    PYGTaxAdvanceConcept * testConcept = [PYGTaxAdvanceConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:-1.0];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:0.0];

    NSInteger result1 = [testConcept taxAdvCalculate:self.payPeriod withIncome:test1 base:test1];
    NSInteger result2 = [testConcept taxAdvCalculate:self.payPeriod withIncome:test2 base:test2];
    STAssertTrue(result1==0, @"Tax advance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test1, 0, result1);
    STAssertTrue(result1==0, @"Tax advance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test2, 0, result2);
}

// 'Tax advance should be round up to 1 CZK'
- (void)testTaxAdvance_ShouldBe_RoundedUpTo1CZK
{
    PYGTaxAdvanceConcept * testConcept = [PYGTaxAdvanceConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:3333];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:2222];

    NSInteger result1 = [testConcept taxAdvCalculate:self.payPeriod withIncome:test1 base:test1];
    NSInteger result2 = [testConcept taxAdvCalculate:self.payPeriod withIncome:test2 base:test2];
    STAssertTrue(result1==500, @"Tax advance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test1, 500, result1);
    STAssertTrue(result2==334, @"Tax advance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test2, 334, result2);
}

// 'Health insurance should be round up to 1 CZK'
- (void)testHealthInsurance_ShouldBe_RoundedUpTo1CZK
{
    PYGInsuranceHealthConcept * testConcept = [PYGInsuranceHealthConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:3333];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:2222];

    NSInteger result1 = [testConcept insuranceContribution:self.payPeriod withIncomeEmployer:test1 employee:test1].integerValue;
    NSInteger result2 = [testConcept insuranceContribution:self.payPeriod withIncomeEmployer:test2 employee:test2].integerValue;
    STAssertTrue(result1==150, @"Health insurance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test1, 150, result1);
    STAssertTrue(result2==100, @"Health insurance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test2, 100, result2);
}

// 'Social insurance should be round up to 1 CZK'
- (void)testSocialInsurance_ShouldBe_RoundedUpTo1CZK
{
    PYGInsuranceSocialConcept * testConcept = [PYGInsuranceSocialConcept concept];
    NSDecimalNumber * test1 = [[NSDecimalNumber alloc] initWithDouble:3333];
    NSDecimalNumber * test2 = [[NSDecimalNumber alloc] initWithDouble:2222];

    NSInteger result1 = [testConcept insuranceContribution:self.payPeriod withIncome:test1].integerValue;
    NSInteger result2 = [testConcept insuranceContribution:self.payPeriod withIncome:test2].integerValue;
    STAssertTrue(result1==217, @"Social insurance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test1, 217, result1);
    STAssertTrue(result2==145, @"Social insurance from base %@ CZK should be round up to %d CZK, NOT %d CZK!", test2, 145, result2);
}

@end
