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
#import "PYGPayrollProcessTestCase.h"

@interface PayrollCalcNetIncomeTests : PYGPayrollProcessTestCase

@property (nonatomic, readwrite) NSMutableDictionary * payrollSpecs;
@property (nonatomic, readwrite) NSMutableDictionary * payrollResults;

@end

@implementation PayrollCalcNetIncomeTests {
}
- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Tear-down code here.

    [super tearDown];
}

- (void)setUpTestSpecs:(NSArray *) values {
//    Given Payroll process for payroll period 01 2013
    self.payProcess = [PYGPayrollProcess payrollProcessWithPeriodYear:2013 andMonth:1
                                                              andTags:[self payrollTags] andConcepts:[self payConcepts]];
    NSUInteger valueIn1 = [(NSNumber *) values[12] unsignedIntegerValue];
    NSUInteger valueIn2 = [(NSNumber *) values[13] unsignedIntegerValue];
    NSUInteger valueIn3 = [(NSNumber *) values[14] unsignedIntegerValue];
    NSUInteger values3I = (valueIn1 + 10*valueIn2 + 100*valueIn3);

    _payrollSpecs = [NSMutableDictionary dictionaryWithDictionary:@{
        S_MAKE_PAIR(@"name"                  , STRTYPE(values[ 0])),
        U_MAKE_PAIR(@"period"                , U_UNBOX(values[ 1])), // Given Payroll process for payroll period 01 2013
        I_MAKE_PAIR(@"schedule"              , I_UNBOX(values[ 2])), // And   Employee works in Weekly schedule 40 hours
        I_MAKE_PAIR(@"absence"               , I_UNBOX(values[ 3])), // And   Employee has 0 hours of absence
        D_MAKE_PAIR(@"salary"                , NUMTYPE(values[ 4])), // And   Employee Salary is CZK 15000 monthly
        U_MAKE_PAIR(@"tax payer"             , U_UNBOX(values[ 5])), // And   YES Employee is Regular Tax payer
        U_MAKE_PAIR(@"health payer"          , U_UNBOX(values[ 6])), // And   YES Employee is Regular Health insurance payer
        U_MAKE_PAIR(@"health minim"          , U_UNBOX(values[ 7])),
        U_MAKE_PAIR(@"social payer"          , U_UNBOX(values[ 8])), // And   YES Employee is Regular Social insurance payer
        U_MAKE_PAIR(@"pension payer"         , U_UNBOX(values[ 9])), // And   NO Employee is Regular Pension savings payer
        U_MAKE_PAIR(@"tax payer benefit"     , U_UNBOX(values[10])), // And   YES Employee claims tax benefit on tax payer
        U_MAKE_PAIR(@"tax child benefit"     , U_UNBOX(values[11])), // And   Employee claims tax benefit on 0 child
        U_MAKE_PAIR(@"tax disability benefit", values3I),            // And   NO:NO:NO Employee claims tax benefit on disability
        U_MAKE_PAIR(@"tax studying benefit"  , U_UNBOX(values[15])), // And   NO Employee claims tax benefit on preparing by studying
        U_MAKE_PAIR(@"health employer"       , U_UNBOX(values[16])), // And   YES Employee is Employer contribution for Health insurance payer
        U_MAKE_PAIR(@"social employer"       , U_UNBOX(values[17]))  // And   YES Employee is Employer contribution for Social insurance payer
    }];
}

- (void)setUpTestResults:(NSArray *) values {
    _payrollResults = [NSMutableDictionary dictionaryWithDictionary:@{
        S_MAKE_PAIR(@"name"               , STRTYPE(values[ 0])),
        D_MAKE_PAIR(@"tax income"         , NUMTYPE(values[ 1])), // Then  Accounted tax income should be CZK 15000
        D_MAKE_PAIR(@"premium insurance"  , NUMTYPE(values[ 2])), // And   Premium insurance should be CZK 5100
        D_MAKE_PAIR(@"tax base"           , NUMTYPE(values[ 3])), // And   Tax base should be CZK 20100
        D_MAKE_PAIR(@"health base"        , NUMTYPE(values[ 4])), // And   Accounted income for Health insurance should be CZK 15000
        D_MAKE_PAIR(@"social base"        , NUMTYPE(values[ 5])), // And   Accounted income for Social insurance should be CZK 15000
        D_MAKE_PAIR(@"health ins"         , NUMTYPE(values[ 6])), // And   Contribution to Health insurance should be CZK 675
        D_MAKE_PAIR(@"social ins"         , NUMTYPE(values[ 7])), // And   Contribution to Social insurance should be CZK 975
        D_MAKE_PAIR(@"tax before"         , NUMTYPE(values[ 8])), // And   Tax advance before tax relief on payer should be CZK 3015
        D_MAKE_PAIR(@"payer relief"       , NUMTYPE(values[ 9])), // And   Tax relief on payer should be CZK 2070
        D_MAKE_PAIR(@"tax after A relief" , NUMTYPE(values[10])), // And   Tax advance after relief on payer should be CZK 945
        D_MAKE_PAIR(@"child relief"       , NUMTYPE(values[11])), // And   Tax relief on child should be CZK 0
        D_MAKE_PAIR(@"tax after C relief" , NUMTYPE(values[12])), // And   Tax advance after relief on child should be CZK 945
        D_MAKE_PAIR(@"tax advance"        , NUMTYPE(values[13])), // And   Tax advance should be CZK 945
        D_MAKE_PAIR(@"tax bonus"          , NUMTYPE(values[14])), // And   Tax bonus should be CZK 0
        D_MAKE_PAIR(@"gross income"       , NUMTYPE(values[15])), // And   Gross income should be CZK 15000
        D_MAKE_PAIR(@"netto income"       , NUMTYPE(values[16]))  // And   Netto income should be CZK 12405
    }];

}

- (void)testPayrollProcessWithSpec:(NSDictionary *)specs andResults:(NSDictionary *)results {
    NSDictionary * testSpec = specs;
    NSString * testSpecName = S_GET_FROM(testSpec, @"name");
    NSDictionary * schedule_work_value = I_MAKE_HASH(@"hours_weekly", I_GET_FROM(testSpec, @"schedule"));
    NSDictionary * schedule_term_value = @{/*@"date_from" : nil, @"date_end" : nil*/};

    [self.payProcess addTermTagRef:REF_SCHEDULE_WORK andValues:schedule_work_value];
    [self.payProcess addTermTagRef:REF_SCHEDULE_TERM  andValues:schedule_term_value];
    NSDictionary * absence_hours_value = I_MAKE_HASH(@"hours", I_GET_FROM(testSpec, @"absence"));
    [self.payProcess addTermTagRef:REF_HOURS_ABSENCE andValues:absence_hours_value];
    NSDictionary * salary_amount_value = D_MAKE_HASH(@"amount_monthly", D_GET_FROM(testSpec, @"salary"));
    [self.payProcess addTermTagRef:REF_SALARY_BASE andValues:salary_amount_value];
    NSUInteger yes_no1 = U_GET_FROM(testSpec, @"tax payer");
    NSUInteger tax_interest = yes_no1!=0 ? 1 : 0;
    NSUInteger tax_declare  = yes_no1==3 ? 1 : 0;
    NSDictionary * interest_value1 = @{
        U_MAKE_PAIR(@"interest_code", tax_interest),
        U_MAKE_PAIR(@"declare_code", tax_declare)
    };
    [self.payProcess addTermTagRef:REF_TAX_INCOME_BASE andValues:interest_value1];
    NSUInteger yes_no2 = U_GET_FROM(testSpec, @"health payer");
    NSUInteger minim  = U_GET_FROM(testSpec, @"health minim");
    NSDictionary * interest_value2 = @{
            U_MAKE_PAIR(@"interest_code", yes_no2),
            U_MAKE_PAIR(@"minimum_asses", minim)
    };
    [self.payProcess addTermTagRef:REF_INSURANCE_HEALTH_BASE andValues:interest_value2];
    [self.payProcess addTermTagRef:REF_INSURANCE_HEALTH andValues:interest_value2];
    NSUInteger yes_no3 = U_GET_FROM(testSpec, @"social payer");
    NSDictionary * interest_value3 = U_MAKE_HASH(@"interest_code", yes_no3);
    [self.payProcess addTermTagRef:REF_INSURANCE_SOCIAL_BASE andValues:interest_value3];
    [self.payProcess addTermTagRef:REF_INSURANCE_SOCIAL andValues:interest_value3];
    NSUInteger yes_no4 = U_GET_FROM(testSpec, @"pension payer");
    NSDictionary * interest_value4 = I_MAKE_HASH(@"interest_code", yes_no4);
    [self.payProcess addTermTagRef:REF_SAVINGS_PENSIONS andValues:interest_value4];
    NSUInteger yes_no5 = U_GET_FROM(testSpec, @"tax payer benefit");
    NSDictionary * relief_value1 = U_MAKE_HASH(@"relief_code", yes_no5);
    [self.payProcess addTermTagRef:REF_TAX_CLAIM_PAYER andValues:relief_value1];
    NSUInteger count = U_GET_FROM(testSpec, @"tax child benefit");
    NSDictionary * relief_value2 = U_MAKE_HASH(@"relief_code", 1);
    for (int i = 0; i < count; i++) {
        [self.payProcess addTermTagRef:REF_TAX_CLAIM_CHILD andValues:relief_value2];
    }
    NSUInteger yes_no6 = U_GET_FROM(testSpec, @"tax disability benefit");
    NSDictionary * relief_value3 = @{
            U_MAKE_PAIR(@"relief_code_1", (yes_no6 % 10)),
            U_MAKE_PAIR(@"relief_code_2", ((yes_no6/10) % 10)),
            U_MAKE_PAIR(@"relief_code_3", ((yes_no6/100) % 10))
    };
    [self.payProcess addTermTagRef:REF_TAX_CLAIM_DISABILITY andValues:relief_value3];
    NSUInteger yes_no7 = U_GET_FROM(testSpec, @"tax studying benefit");
    NSDictionary * relief_value4 = U_MAKE_HASH(@"relief_code", yes_no7);
    [self.payProcess addTermTagRef:REF_TAX_CLAIM_STUDYING andValues:relief_value4];
    NSUInteger yes_no8 = U_GET_FROM(testSpec, @"health employer");
    NSDictionary * interest_value5 = U_MAKE_HASH(@"interest_code", yes_no8);
    [self.payProcess addTermTagRef:REF_TAX_EMPLOYERS_HEALTH andValues:interest_value5];
    NSUInteger yes_no9 = U_GET_FROM(testSpec, @"social employer");
    NSDictionary * interest_value6 = U_MAKE_HASH(@"interest_code", yes_no9);
    [self.payProcess addTermTagRef:REF_TAX_EMPLOYERS_SOCIAL andValues:interest_value6];

    [self.payProcess addTermTagRef:REF_INCOME_GROSS andValues:EMPTY_VALUES];
    PYGTagRefer  * evResultTermTag = [self.payProcess addTermTagRef:REF_INCOME_NETTO andValues:EMPTY_VALUES];
    NSDictionary * evResultDictVal = [self.payProcess evaluate:evResultTermTag];

    NSDictionary * testResults = results;
    PYGTagRefer * resultTag = [PYGTagRefer tagReferWithPeriodBase:PERIOD_NOW andCode:TAG_INCOME_NETTO andCodeOrder:1];
    NSDecimalNumber * result01 = D_GET_FROM(testResults, @"tax income");
    NSDecimalNumber * result02 = D_GET_FROM(testResults, @"premium insurance");
    NSDecimalNumber * result03 = D_GET_FROM(testResults, @"tax base");
    NSDecimalNumber * result04 = D_GET_FROM(testResults, @"health base");
    NSDecimalNumber * result05 = D_GET_FROM(testResults, @"social base");
    NSDecimalNumber * result06 = D_GET_FROM(testResults, @"health ins");
    NSDecimalNumber * result07 = D_GET_FROM(testResults, @"social ins");
    NSDecimalNumber * result08 = D_GET_FROM(testResults, @"tax before");
    NSDecimalNumber * result09 = D_GET_FROM(testResults, @"payer relief");
    NSDecimalNumber * result10 = D_GET_FROM(testResults, @"tax after A relief");
    NSDecimalNumber * result11 = D_GET_FROM(testResults, @"child relief");
    NSDecimalNumber * result12 = D_GET_FROM(testResults, @"tax after C relief");
    NSDecimalNumber * result13 = D_GET_FROM(testResults, @"tax advance");
    NSDecimalNumber * result14 = D_GET_FROM(testResults, @"tax bonus");
    NSDecimalNumber * result15 = D_GET_FROM(testResults, @"gross income");
    NSDecimalNumber * result16 = D_GET_FROM(testResults, @"netto income");

    NSDecimalNumber * testVal01 =  [self get_result_income_base:REF_TAX_INCOME_BASE];
    NSDecimalNumber * testVal02a = [self get_result_payment:REF_TAX_EMPLOYERS_HEALTH];
    NSDecimalNumber * testVal02b = [self get_result_payment:REF_TAX_EMPLOYERS_SOCIAL];
    NSDecimalNumber * testVal02 =  [testVal02a decimalNumberByAdding:testVal02b];
    NSDecimalNumber * testVal03 =  [self get_result_income_base:REF_TAX_ADVANCE_BASE];
    NSDecimalNumber * testVal03w = [self get_result_income_base:REF_TAX_WITHHOLD_BASE];
    NSDecimalNumber * testVal04 =  [self get_result_employee_base:REF_INSURANCE_HEALTH_BASE];
    NSDecimalNumber * testVal05 =  [self get_result_employee_base:REF_INSURANCE_SOCIAL_BASE];
    NSDecimalNumber * testVal06 =  [self get_result_payment:REF_INSURANCE_HEALTH];
    NSDecimalNumber * testVal07 =  [self get_result_payment:REF_INSURANCE_SOCIAL];
    NSDecimalNumber * testVal08 =  [self get_result_payment:REF_TAX_ADVANCE];
    NSDecimalNumber * testVal09 =  [self get_result_tax_relief:REF_TAX_RELIEF_PAYER];
    NSDecimalNumber * testVal10 =  [self get_result_after_reliefA:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * testVal11 =  [self get_result_tax_relief:REF_TAX_RELIEF_CHILD];
    NSDecimalNumber * testVal12 =  [self get_result_after_reliefC:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * testVal13 =  [self get_result_payment:REF_TAX_ADVANCE_FINAL];
    NSDecimalNumber * testVal14 =  [self get_result_payment:REF_TAX_BONUS_CHILD];
    NSDecimalNumber * testVal15 =  [self get_result_amount:REF_INCOME_GROSS];
    NSDecimalNumber * testVal16 =  [self get_result_amount:REF_INCOME_NETTO];

    STAssertTrue([testVal01 isEqual:result01], @"tax income         should be %@ CZK, NOT %@!", result01, testVal01);
    STAssertTrue([testVal02 isEqual:result02], @"premium insurance  should be %@ CZK, NOT %@!", result02, testVal02);
    STAssertTrue([testVal03 isEqual:result03], @"tax base           should be %@ CZK, NOT %@!", result03, testVal03);
    STAssertTrue([testVal04 isEqual:result04], @"health base        should be %@ CZK, NOT %@!", result04, testVal04);
    STAssertTrue([testVal05 isEqual:result05], @"social base        should be %@ CZK, NOT %@!", result05, testVal05);
    STAssertTrue([testVal06 isEqual:result06], @"health ins         should be %@ CZK, NOT %@!", result06, testVal06);
    STAssertTrue([testVal07 isEqual:result07], @"social ins         should be %@ CZK, NOT %@!", result07, testVal07);
    STAssertTrue([testVal08 isEqual:result08], @"tax before         should be %@ CZK, NOT %@!", result08, testVal08);
    STAssertTrue([testVal09 isEqual:result09], @"payer relief       should be %@ CZK, NOT %@!", result09, testVal09);
    STAssertTrue([testVal10 isEqual:result10], @"tax after A relief should be %@ CZK, NOT %@!", result10, testVal10);
    STAssertTrue([testVal11 isEqual:result11], @"child relief       should be %@ CZK, NOT %@!", result11, testVal11);
    STAssertTrue([testVal12 isEqual:result12], @"tax after C relief should be %@ CZK, NOT %@!", result12, testVal12);
    STAssertTrue([testVal13 isEqual:result13], @"tax advance        should be %@ CZK, NOT %@!", result13, testVal13);
    STAssertTrue([testVal14 isEqual:result14], @"tax bonus          should be %@ CZK, NOT %@!", result14, testVal14);
    STAssertTrue([testVal15 isEqual:result15], @"gross income       should be %@ CZK, NOT %@!", result15, testVal15);
    STAssertTrue([testVal16 isEqual:result16], @"netto income       should be %@ CZK, NOT %@!", result16, testVal16);
}

//Examples: Employment with Tax Advance
- (void)test01_PP_Mzda_DanPoj_SlevyZaklad
{
    NSArray * testSpecValues = @[
        @"01-PP-Mzda-DanPoj-SlevyZaklad",// name 01-PP
        @201301 ,// period                  201301
        @40     ,// schedule                40
        @0      ,// absence                 0
        @15000  ,// salary                  CZK 15000
        @(TAX_DECLARED),// tax payer               DECLARE
        @1      ,// health payer            YES
        @1      ,// health minim            YES
        @1      ,// social payer            YES
        @0      ,// pension payer           NO
        @1      ,// tax payer benefit       YES
        @0      ,// tax child benefit       0
        @0      ,// tax disability benefit1 NO:NO:NO
        @0      ,// tax disability benefit2 NO:NO:NO
        @0      ,// tax disability benefit3 NO:NO:NO
        @0      ,// tax studying benefit    NO
        @1      ,// health employer         YES
        @1       // social employer         YES
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
        @"01-PP-Mzda-DanPoj-SlevyZaklad",// name 01-PP
        @15000 ,// tax income              CZK 15000
        @5100  ,// premium insurance       CZK 5100
        @20100 ,// tax base                CZK 20100
        @15000 ,// health base             CZK 15000
        @15000 ,// social base             CZK 15000
        @675   ,// health ins              CZK 675
        @975   ,// social ins              CZK 975
        @3015  ,// tax before              CZK 3015
        @2070  ,// payer relief            CZK 2070
        @945   ,// tax after A relief      CZK 945
        @0     ,// child relief            CZK 0
        @945   ,// tax after C relief      CZK 945
        @945   ,// tax advance             CZK 945
        @0     ,// tax bonus               CZK 0
        @15000 ,// gross income            CZK 15000
        @12405  // netto income            CZK 12405
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test02_PP_Mzda_DanPoj_SlevyDite1
{
    NSArray * testSpecValues = @[
            @"02-PP-Mzda-DanPoj-SlevyDite1",@201301,@40,@0,@15600,@(TAX_DECLARED),@1,@1,@1,@0,@1,@1,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"02-PP-Mzda-DanPoj-SlevyDite1",@15600,@5304,@21000,@15600,@15600,@702,@1014,@3150,@2070,@1080,@1080,@0,@0,@0,@15600,@13884
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test03_PP_Mzda_DanPoj_SlevyDite1_Bonus
{
    NSArray * testSpecValues = @[
            @"03-PP-Mzda-DanPoj-SlevyDite1-Bonus",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@1,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"03-PP-Mzda-DanPoj-SlevyDite1-Bonus",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2070,@945,@945,@0,@0,@172,@15000,@13522
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test04_PP_Mzda_DanPoj_SlevyDite2_Bonus
{
    NSArray * testSpecValues = @[
            @"04-PP-Mzda-DanPoj-SlevyDite2-Bonus",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@2,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"04-PP-Mzda-DanPoj-SlevyDite2-Bonus",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2070,@945,@945,@0,@0,@1289,@15000,@14639
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test05_PP_Mzda_DanPoj_MaxBonus
{
    NSArray * testSpecValues = @[
            @"05-PP-Mzda-DanPoj-MaxBonus",@201301,@40,@0,@10000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@7,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"05-PP-Mzda-DanPoj-MaxBonus",@10000,@3400,@13400,@10000,@10000,@450,@650,@2010,@2010,@0,@0,@0,@0,@5025,@10000,@13925
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test06_PP_Mzda_DanPoj_MinZdrav
{
    NSArray * testSpecValues = @[
            @"06-PP-Mzda-DanPoj-MinZdrav",@201301,@40,@0,@7800,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"06-PP-Mzda-DanPoj-MinZdrav",@7800,@2652,@10500,@8000,@7800,@378,@507,@1575,@1575,@0,@0,@0,@0,@0,@7800,@6915
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test07_PP_Mzda_DanPoj_MaxZdrav12
{
    NSArray * testSpecValues = @[
            @"07-PP-Mzda-DanPoj-MaxZdrav12",@201301,@40,@0,@1809964,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"07-PP-Mzda-DanPoj-MaxZdrav12",@1809964,@473505,@2283500,@1809964,@1242432,@81449,@80759,@461975,@2070,@459905,@0,@459905,@459905,@0,@1809964,@1187851
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test08_PP_Mzda_DanPoj_MaxSocial12
{
    NSArray * testSpecValues = @[
            @"08-PP-Mzda-DanPoj-MaxSocial12",@201301,@40,@0,@1206676,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"08-PP-Mzda-DanPoj-MaxSocial12",@1206676,@410270,@1617000,@1206676,@1206676,@54301,@78434,@319770,@2070,@317700,@0,@317700,@317700,@0,@1206676,@756241
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test09_PP_Mzda_DanPoj_MaxSocial13
{
    NSArray * testSpecValues = @[
            @"09-PP-Mzda-DanPoj-MaxSocial13",@201301,@40,@0,@1242532,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"09-PP-Mzda-DanPoj-MaxSocial13",@1242532,@422436,@1665000,@1242532,@1242432,@55914,@80759,@329480,@2070,@327410,@0,@327410,@327410,@0,@1242532,@778449
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test10_PP_Mzda_DanPoj_Neodpr064
{
    NSArray * testSpecValues = @[
            @"10-PP-Mzda-DanPoj-Neodpr064",@201301,@40,@46,@20000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"10-PP-Mzda-DanPoj-Neodpr064",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2070,@945,@0,@945,@945,@0,@15000,@12405
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test22_PP_Mzda_DanPoj_SolidarDan
{
    NSArray * testSpecValues = @[
            @"22-PP-Mzda-DanPoj-SolidarDan",@201301,@40,@0,@104536,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"22-PP-Mzda-DanPoj-SolidarDan",@104536,@35542,@140100,@104536,@104536,@4705,@6795,@21085,@2070,@19015,@0,@19015,@19015,@0,@104536,@74021
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test23_PP_Mzda_DanPoj_DuchSpor
{
    NSArray * testSpecValues = @[
            @"23-PP-Mzda-DanPoj-DuchSpor",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"23-PP-Mzda-DanPoj-DuchSpor",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2070,@945,@0,@945,@945,@0,@15000,@12405
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test27_PP_Mzda_DanPoj_SlevyInv1
{
    NSArray * testSpecValues = @[
            @"27-PP-Mzda-DanPoj-SlevyInv1",@201301,@40,@0,@20000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@1,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"27-PP-Mzda-DanPoj-SlevyInv1",@20000,@6800,@26800,@20000,@20000,@900,@1300,@4020,@2280,@1740,@0,@1740,@1740,@0,@20000,@16060
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test28_PP_Mzda_DanPoj_SlevyInv2
{
    NSArray * testSpecValues = @[
            @"28-PP-Mzda-DanPoj-SlevyInv2",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@1,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"28-PP-Mzda-DanPoj-SlevyInv2",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2490,@525,@0,@525,@525,@0,@15000,@12825
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test29_PP_Mzda_DanPoj_SlevyInv3
{
    NSArray * testSpecValues = @[
            @"29-PP-Mzda-DanPoj-SlevyInv3",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@1,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"29-PP-Mzda-DanPoj-SlevyInv3",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2490,@525,@0,@525,@525,@0,@15000,@12825
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test30_PP_Mzda_DanPoj_SlevyStud
{
    NSArray * testSpecValues = @[
            @"30-PP-Mzda-DanPoj-SlevyStud",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@1,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"30-PP-Mzda-DanPoj-SlevyStud",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2405,@610,@0,@610,@610,@0,@15000,@12740
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test31_PP_Mzda_DanPoj_SlevyZaklad15
{
    NSArray * testSpecValues = @[
            @"31-PP-Mzda-DanPoj-SlevyZaklad15",@201301,@40,@0,@15000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"31-PP-Mzda-DanPoj-SlevyZaklad15",@15000,@5100,@20100,@15000,@15000,@675,@975,@3015,@2070,@945,@0,@945,@945,@0,@15000,@12405
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test32_PP_Mzda_DanPoj_SlevyZaklad20
{
    NSArray * testSpecValues = @[
            @"32-PP-Mzda-DanPoj-SlevyZaklad20",@201301,@40,@0,@20000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"32-PP-Mzda-DanPoj-SlevyZaklad20",@20000,@6800,@26800,@20000,@20000,@900,@1300,@4020,@2070,@1950,@0,@1950,@1950,@0,@20000,@15850
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test33_PP_Mzda_DanPoj_SlevyZaklad25
{
    NSArray * testSpecValues = @[
            @"33-PP-Mzda-DanPoj-SlevyZaklad25",@201301,@40,@0,@25000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"33-PP-Mzda-DanPoj-SlevyZaklad25",@25000,@8500,@33500,@25000,@25000,@1125,@1625,@5025,@2070,@2955,@0,@2955,@2955,@0,@25000,@19295
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test34_PP_Mzda_DanPoj_SlevyZaklad30
{
    NSArray * testSpecValues = @[
            @"34-PP-Mzda-DanPoj-SlevyZaklad30",@201301,@40,@0,@30000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"34-PP-Mzda-DanPoj-SlevyZaklad30",@30000,@10200,@40200,@30000,@30000,@1350,@1950,@6030,@2070,@3960,@0,@3960,@3960,@0,@30000,@22740
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test35_PP_Mzda_DanPoj_SlevyZaklad35
{
    NSArray * testSpecValues = @[
            @"35-PP-Mzda-DanPoj-SlevyZaklad35",@201301,@40,@0,@35000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"35-PP-Mzda-DanPoj-SlevyZaklad35",@35000,@11900,@46900,@35000,@35000,@1575,@2275,@7035,@2070,@4965,@0,@4965,@4965,@0,@35000,@26185
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test36_PP_Mzda_DanPoj_SlevyZaklad40
{
    NSArray * testSpecValues = @[
            @"36-PP-Mzda-DanPoj-SlevyZaklad40",@201301,@40,@0,@40000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"36-PP-Mzda-DanPoj-SlevyZaklad40",@40000,@13600,@53600,@40000,@40000,@1800,@2600,@8040,@2070,@5970,@0,@5970,@5970,@0,@40000,@29630
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test37_PP_Mzda_DanPoj_SlevyZaklad45
{
    NSArray * testSpecValues = @[
            @"37-PP-Mzda-DanPoj-SlevyZaklad45",@201301,@40,@0,@45000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"37-PP-Mzda-DanPoj-SlevyZaklad45",@45000,@15300,@60300,@45000,@45000,@2025,@2925,@9045,@2070,@6975,@0,@6975,@6975,@0,@45000,@33075
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test38_PP_Mzda_DanPoj_SlevyZaklad50
{
    NSArray * testSpecValues = @[
            @"38-PP-Mzda-DanPoj-SlevyZaklad50",@201301,@40,@0,@50000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"38-PP-Mzda-DanPoj-SlevyZaklad50",@50000,@17000,@67000,@50000,@50000,@2250,@3250,@10050,@2070,@7980,@0,@7980,@7980,@0,@50000,@36520
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test39_PP_Mzda_DanPoj_SlevyZaklad55
{
    NSArray * testSpecValues = @[
            @"39-PP-Mzda-DanPoj-SlevyZaklad55",@201301,@40,@0,@55000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"39-PP-Mzda-DanPoj-SlevyZaklad55",@55000,@18700,@73700,@55000,@55000,@2475,@3575,@11055,@2070,@8985,@0,@8985,@8985,@0,@55000,@39965
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test40_PP_Mzda_DanPoj_SlevyZaklad60
{
    NSArray * testSpecValues = @[
            @"40-PP-Mzda-DanPoj-SlevyZaklad60",@201301,@40,@0,@60000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"40-PP-Mzda-DanPoj-SlevyZaklad60",@60000,@20400,@80400,@60000,@60000,@2700,@3900,@12060,@2070,@9990,@0,@9990,@9990,@0,@60000,@43410
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test41_PP_Mzda_DanPoj_SlevyZaklad65
{
    NSArray * testSpecValues = @[
            @"41-PP-Mzda-DanPoj-SlevyZaklad65",@201301,@40,@0,@65000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"41-PP-Mzda-DanPoj-SlevyZaklad65",@65000,@22100,@87100,@65000,@65000,@2925,@4225,@13065,@2070,@10995,@0,@10995,@10995,@0,@65000,@46855
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test42_PP_Mzda_DanPoj_SlevyZaklad70
{
    NSArray * testSpecValues = @[
            @"42-PP-Mzda-DanPoj-SlevyZaklad70",@201301,@40,@0,@70000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"42-PP-Mzda-DanPoj-SlevyZaklad70",@70000,@23800,@93800,@70000,@70000,@3150,@4550,@14070,@2070,@12000,@0,@12000,@12000,@0,@70000,@50300
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test43_PP_Mzda_DanPoj_SlevyZaklad75
{
    NSArray * testSpecValues = @[
            @"43-PP-Mzda-DanPoj-SlevyZaklad75",@201301,@40,@0,@75000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"43-PP-Mzda-DanPoj-SlevyZaklad75",@75000,@25500,@100500,@75000,@75000,@3375,@4875,@15075,@2070,@13005,@0,@13005,@13005,@0,@75000,@53745
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test44_PP_Mzda_DanPoj_SlevyZaklad80
{
    NSArray * testSpecValues = @[
            @"44-PP-Mzda-DanPoj-SlevyZaklad80",@201301,@40,@0,@80000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"44-PP-Mzda-DanPoj-SlevyZaklad80",@80000,@27200,@107200,@80000,@80000,@3600,@5200,@16080,@2070,@14010,@0,@14010,@14010,@0,@80000,@57190
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test45_PP_Mzda_DanPoj_SlevyZaklad85
{
    NSArray * testSpecValues = @[
            @"45-PP-Mzda-DanPoj-SlevyZaklad85",@201301,@40,@0,@85000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"45-PP-Mzda-DanPoj-SlevyZaklad85",@85000,@28900,@113900,@85000,@85000,@3825,@5525,@17085,@2070,@15015,@0,@15015,@15015,@0,@85000,@60635
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test46_PP_Mzda_DanPoj_SlevyZaklad90
{
    NSArray * testSpecValues = @[
            @"46-PP-Mzda-DanPoj-SlevyZaklad90",@201301,@40,@0,@90000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"46-PP-Mzda-DanPoj-SlevyZaklad90",@90000,@30600,@120600,@90000,@90000,@4050,@5850,@18090,@2070,@16020,@0,@16020,@16020,@0,@90000,@64080
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test47_PP_Mzda_DanPoj_SlevyZaklad95
{
    NSArray * testSpecValues = @[
            @"47-PP-Mzda-DanPoj-SlevyZaklad95",@201301,@40,@0,@95000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"47-PP-Mzda-DanPoj-SlevyZaklad95",@95000,@32300,@127300,@95000,@95000,@4275,@6175,@19095,@2070,@17025,@0,@17025,@17025,@0,@95000,@67525
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test48_PP_Mzda_DanPoj_SlevyZaklad100
{
    NSArray * testSpecValues = @[
            @"48-PP-Mzda-DanPoj-SlevyZaklad100",@201301,@40,@0,@100000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"48-PP-Mzda-DanPoj-SlevyZaklad100",@100000,@34000,@134000,@100000,@100000,@4500,@6500,@20100,@2070,@18030,@0,@18030,@18030,@0,@100000,@70970
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test49_PP_Mzda_DanPoj_SlevyZaklad105
{
    NSArray * testSpecValues = @[
            @"49-PP-Mzda-DanPoj-SlevyZaklad105",@201301,@40,@0,@105000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"49-PP-Mzda-DanPoj-SlevyZaklad105",@105000,@35700,@140700,@105000,@105000,@4725,@6825,@21208,@2070,@19138,@0,@19138,@19138,@0,@105000,@74312
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test50_PP_Mzda_DanPoj_SlevyZaklad110
{
    NSArray * testSpecValues = @[
            @"50-PP-Mzda-DanPoj-SlevyZaklad110",@201301,@40,@0,@110000,@(TAX_DECLARED),@1,@1,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"50-PP-Mzda-DanPoj-SlevyZaklad110",@110000,@37400,@147400,@110000,@110000,@4950,@7150,@22563,@2070,@20493,@0,@20493,@20493,@0,@110000,@77407
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

//Examples: Employment with Withholding tax
- (void)test12_PP_Mzda_NepodPoj_5000
{
    NSArray * testSpecValues = @[
            @"12-PP-Mzda-NepodPoj-5000",@201301,@40,@0,@5000,@(TAX_PAYER),@1,@1,@1,@0,@0,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"12-PP-Mzda-NepodPoj-5000",@5000,@1700,@0,@8000,@5000,@630,@325,@0,@0,@0,@0,@0,@0,@0,@5000,@3040
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test13_PP_Mzda_NepodPoj_5001
{
    NSArray * testSpecValues = @[
            @"13-PP-Mzda-NepodPoj-5001",@201301,@40,@0,@5001,@(TAX_PAYER),@1,@1,@1,@0,@0,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"13-PP-Mzda-NepodPoj-5001",@5001,@1701,@6800,@8000,@5001,@630,@326,@1020,@0,@1020,@0,@1020,@1020,@0,@5001,@3025
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

//Examples: Employment without Minimum Assessment base for Health Insurance
- (void)test24_PP_Mzda_DanPoj_Dan099
{
    NSArray * testSpecValues = @[
            @"24-PP-Mzda-DanPoj-Dan099",@201301,@40,@0,@74,@(TAX_DECLARED),@1,@0,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"24-PP-Mzda-DanPoj-Dan099",@74,@25,@99,@74,@74,@4,@5,@15,@15,@0,@0,@0,@0,@0,@74,@65
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test25_PP_Mzda_DanPoj_Dan100
{
    NSArray * testSpecValues = @[
            @"25-PP-Mzda-DanPoj-Dan100",@201301,@40,@0,@75,@(TAX_DECLARED),@1,@0,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"25-PP-Mzda-DanPoj-Dan100",@75,@26,@200,@75,@75,@4,@5,@30,@30,@0,@0,@0,@0,@0,@75,@66
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

- (void)test26_PP_Mzda_DanPoj_Dan101
{
    NSArray * testSpecValues = @[
            @"26-PP-Mzda-DanPoj-Dan101",@201301,@40,@0,@100,@(TAX_DECLARED),@1,@0,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"26-PP-Mzda-DanPoj-Dan101",@100,@34,@200,@100,@100,@5,@7,@30,@30,@0,@0,@0,@0,@0,@100,@88
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

//Examples: Employment with Absence hours
//TODO: MINIMUM BASE FOR HEALTH INSURANCE, AS ADDED RECORD
- (void)test11_PP_Mzda_DanPoj_Neodpr184
{
// period                  201301
// schedule                40
// absence                 0
// salary                  CZK 15000
// tax payer               DECLARE
// health payer            YES
// health minim            YES
// social payer            YES
// pension payer           NO
// tax payer benefit       YES
// tax child benefit       0
// tax disability benefit1 NO:NO:NO
// tax disability benefit2 NO:NO:NO
// tax disability benefit3 NO:NO:NO
// tax studying benefit    NO
// health employer         YES
// social employer         YES

    NSArray * testSpecValues = @[
            @"11-PP-Mzda-DanPoj-Neodpr184",@201301,@40,@184,@20000,@(TAX_DECLARED),@1,@0/*health minim SHOULD BE 1*/,@1,@0,@1,@0,@0,@0,@0,@0,@1,@1
    ];
    [self setUpTestSpecs:testSpecValues];

    NSArray * testResultValues = @[
            @"11-PP-Mzda-DanPoj-Neodpr184",@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0,@0
    ];
    [self setUpTestResults:testResultValues];

    [self testPayrollProcessWithSpec:self.payrollSpecs andResults:self.payrollResults];
}

@end
