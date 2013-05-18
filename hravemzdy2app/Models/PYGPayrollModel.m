//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollModel.h"
#import "PYGCodeNameRefer.h"
#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGSymbolTags.h"
#import "PYGPayrollProcess.h"
#import "PYGPayrollPeriod.h"
#import "PYGResultExporter.h"
#import "PYGXmlResultExporter.h"
#import "PdfRenderer.h"

#define SECTION_0 @0
#define SECTION_1 @1
#define SECTION_2 @2
#define SECTION_3 @3
#define SECTION_4 @4
#define SECTION_5 @5
#define SECTION_6 @6

#define RESULT_TITLE @"title"
#define RESULT_VALUE @"value"

@interface PYGPayrollModel ()

// Set-up code here.
@property (strong, nonatomic) PYGPayTagGateway *payrollTags;
@property (strong, nonatomic) PYGPayConceptGateway *payConcepts;

@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *payrollName;
@property (strong, nonatomic) NSString *payrollMail;
@property (strong, nonatomic) NSString *companyName;
@property (strong, nonatomic) NSString *companyDept;
@property (strong, nonatomic) NSString *employerName;
@property (strong, nonatomic) NSString *employeeName;
@property (strong, nonatomic) NSString *employeeNumb;

@property (strong, nonatomic) NSDictionary *schedule_work_value;
@property (strong, nonatomic) NSDictionary *schedule_term_value;
@property (strong, nonatomic) NSDictionary *absence_hours_value;
@property (strong, nonatomic) NSDictionary *salary_amount_value;
@property (strong, nonatomic) NSDictionary *interest_taxes;
@property (strong, nonatomic) NSDictionary *interest_ins_health;
@property (strong, nonatomic) NSDictionary *interest_ins_social;
@property (strong, nonatomic) NSDictionary *interest_pension;
@property (strong, nonatomic) NSDictionary *relief_payer;
@property (strong, nonatomic) NSDictionary *relief_child;
@property (strong, nonatomic) NSDictionary *relief_disability;
@property (strong, nonatomic) NSDictionary *relief_studying;
@property (strong, nonatomic) NSDictionary *interest_emp_health;
@property (strong, nonatomic) NSDictionary *interest_emp_social;

@property (strong, nonatomic) PYGCodeNameRefer *REF_SCHEDULE_WORK         ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_SCHEDULE_TERM         ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_HOURS_ABSENCE         ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_SALARY_BASE           ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_INCOME_BASE       ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INSURANCE_HEALTH_BASE ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INSURANCE_HEALTH      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INSURANCE_SOCIAL_BASE ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INSURANCE_SOCIAL      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_SAVINGS_PENSIONS      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_CLAIM_PAYER       ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_CLAIM_CHILD       ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_CLAIM_DISABILITY  ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_CLAIM_STUDYING    ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_EMPLOYERS_HEALTH  ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_EMPLOYERS_SOCIAL  ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_ADVANCE_BASE      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_ADVANCE           ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_WITHHOLD_BASE     ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_WITHHOLD          ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_RELIEF_PAYER      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_ADVANCE_FINAL     ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_RELIEF_CHILD      ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_TAX_BONUS_CHILD       ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INCOME_GROSS          ;
@property (strong, nonatomic) PYGCodeNameRefer *REF_INCOME_NETTO          ;
@end

@implementation PYGPayrollModel {

}

-(id)init {
    if (!(self = [super init])) return nil;

    [self createPayrollTags];
    [self createSpecsValues];

    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];

    return self;
}

+ (id)payrollModel {
    return [[self alloc] init];
}

- (void)createPayrollTags {
    self.REF_SCHEDULE_WORK          = TAGS_REF(TAG_SCHEDULE_WORK);
    self.REF_SCHEDULE_TERM          = TAGS_REF(TAG_SCHEDULE_TERM);
    self.REF_HOURS_ABSENCE          = TAGS_REF(TAG_HOURS_ABSENCE);
    self.REF_SALARY_BASE            = TAGS_REF(TAG_SALARY_BASE);
    self.REF_TAX_INCOME_BASE        = TAGS_REF(TAG_TAX_INCOME_BASE);
    self.REF_INSURANCE_HEALTH_BASE  = TAGS_REF(TAG_INSURANCE_HEALTH_BASE);
    self.REF_INSURANCE_HEALTH       = TAGS_REF(TAG_INSURANCE_HEALTH);
    self.REF_INSURANCE_SOCIAL_BASE  = TAGS_REF(TAG_INSURANCE_SOCIAL_BASE);
    self.REF_INSURANCE_SOCIAL       = TAGS_REF(TAG_INSURANCE_SOCIAL);
    self.REF_SAVINGS_PENSIONS       = TAGS_REF(TAG_SAVINGS_PENSIONS);
    self.REF_TAX_CLAIM_PAYER        = TAGS_REF(TAG_TAX_CLAIM_PAYER);
    self.REF_TAX_CLAIM_CHILD        = TAGS_REF(TAG_TAX_CLAIM_CHILD);
    self.REF_TAX_CLAIM_DISABILITY   = TAGS_REF(TAG_TAX_CLAIM_DISABILITY);
    self.REF_TAX_CLAIM_STUDYING     = TAGS_REF(TAG_TAX_CLAIM_STUDYING);
    self.REF_TAX_EMPLOYERS_HEALTH   = TAGS_REF(TAG_TAX_EMPLOYERS_HEALTH);
    self.REF_TAX_EMPLOYERS_SOCIAL   = TAGS_REF(TAG_TAX_EMPLOYERS_SOCIAL);
    self.REF_TAX_ADVANCE_BASE       = TAGS_REF(TAG_TAX_ADVANCE_BASE);
    self.REF_TAX_ADVANCE            = TAGS_REF(TAG_TAX_ADVANCE);
    self.REF_TAX_WITHHOLD_BASE      = TAGS_REF(TAG_TAX_WITHHOLD_BASE);
    self.REF_TAX_WITHHOLD           = TAGS_REF(TAG_TAX_WITHHOLD);
    self.REF_TAX_RELIEF_PAYER       = TAGS_REF(TAG_TAX_RELIEF_PAYER);
    self.REF_TAX_ADVANCE_FINAL      = TAGS_REF(TAG_TAX_ADVANCE_FINAL);
    self.REF_TAX_RELIEF_CHILD       = TAGS_REF(TAG_TAX_RELIEF_CHILD);
    self.REF_TAX_BONUS_CHILD        = TAGS_REF(TAG_TAX_BONUS_CHILD);
    self.REF_INCOME_GROSS           = TAGS_REF(TAG_INCOME_GROSS);
    self.REF_INCOME_NETTO           = TAGS_REF(TAG_INCOME_NETTO);
}

- (void)createSpecsValues {
    self.schedule_work_value = EMPTY_VALUES;
    self.schedule_term_value = EMPTY_VALUES;
    self.absence_hours_value = EMPTY_VALUES;
    self.salary_amount_value = EMPTY_VALUES;
    self.interest_taxes      = EMPTY_VALUES;
    self.interest_ins_health = EMPTY_VALUES;
    self.interest_ins_social = EMPTY_VALUES;
    self.interest_pension    = EMPTY_VALUES;
    self.relief_payer        = EMPTY_VALUES;
    self.relief_child        = EMPTY_VALUES;
    self.relief_disability   = EMPTY_VALUES;
    self.relief_studying     = EMPTY_VALUES;
    self.interest_emp_health = EMPTY_VALUES;
    self.interest_emp_social = EMPTY_VALUES;
}

- (void)setPayrollTitles:(NSDictionary *)values {
    self.description  = values[@"description"];
    self.payrollName  = values[@"payrollee"];
    self.payrollMail  = values[@"email"];
    self.companyName  = values[@"company"];
    self.companyDept  = values[@"department"];
    self.employerName = values[@"employer"];
    self.employeeName = values[@"employee"];
    self.employeeNumb = values[@"personnel"];

    [self setDefaultPayrollTitles];
}

- (void)setDefaultPayrollTitles {
    [self makeTitleDefault:self.employerName withDefault:@"employer name"];
    [self makeTitleDefault:self.employeeName withDefault:@"employee name"];
    [self makeTitleDefault:self.employeeNumb withDefault:@"0010"];

    [self makeTitleDefault:self.description withDefault:@"description"];
    [self makeTitleDefault:self.companyName withDefault:@"company name"];
    [self makeTitleDefault:self.companyDept withDefault:@"department name"];
    [self makeTitleDefault:self.payrollName withDefault:@"payrollee name"];
    [self makeTitleDefault:self.payrollMail withDefault:@"payrollee email"];
}

- (NSString *)makeTitleDefault:(NSString *)title withDefault:(NSString *)defaultTitle {
    if (title == nil || [title isEqualToString:@""]) {
        return [NSString stringWithString:defaultTitle];
    }
    return [NSString stringWithString:title];
}

- (void)setPayrollValues:(NSDictionary *)values {
    self.schedule_work_value = values[self.REF_SCHEDULE_WORK];
    self.schedule_term_value = values[self.REF_SCHEDULE_TERM];
    self.absence_hours_value = values[self.REF_HOURS_ABSENCE];
    self.salary_amount_value = values[self.REF_SALARY_BASE];
    self.interest_taxes      = values[self.REF_TAX_INCOME_BASE];
    self.interest_ins_health = values[self.REF_INSURANCE_HEALTH_BASE];
    self.interest_ins_social = values[self.REF_INSURANCE_SOCIAL_BASE];
    self.interest_pension    = values[self.REF_SAVINGS_PENSIONS];
    self.relief_payer        = values[self.REF_TAX_CLAIM_PAYER];
    self.relief_child        = values[self.REF_TAX_CLAIM_CHILD];
    self.relief_disability   = values[self.REF_TAX_CLAIM_DISABILITY];
    self.relief_studying     = values[self.REF_TAX_CLAIM_STUDYING];
    self.interest_emp_health = values[self.REF_TAX_EMPLOYERS_HEALTH];
    self.interest_emp_social = values[self.REF_TAX_EMPLOYERS_SOCIAL];
}

- (PYGPayrollProcess *)createPayrollProcessForPeriod:(PYGPayrollPeriod *)period {
    PYGPayrollProcess *payroll = [PYGPayrollProcess payrollProcessWithPeriodCode:period.code
                                                                         andTags:[self payrollTags]
                                                                     andConcepts:[self payConcepts]];

    [payroll addTermTagRef:self.REF_SCHEDULE_WORK andValues:self.schedule_work_value];
    [payroll addTermTagRef:self.REF_SCHEDULE_TERM andValues:self.schedule_term_value];
    [payroll addTermTagRef:self.REF_HOURS_ABSENCE andValues:self.absence_hours_value];
    [payroll addTermTagRef:self.REF_SALARY_BASE andValues:self.salary_amount_value];
    [payroll addTermTagRef:self.REF_TAX_INCOME_BASE andValues:self.interest_taxes];
    [payroll addTermTagRef:self.REF_INSURANCE_HEALTH_BASE andValues:self.interest_ins_health];
    [payroll addTermTagRef:self.REF_INSURANCE_HEALTH andValues:self.interest_ins_health];
    [payroll addTermTagRef:self.REF_INSURANCE_SOCIAL_BASE andValues:self.interest_ins_social];
    [payroll addTermTagRef:self.REF_INSURANCE_SOCIAL andValues:self.interest_ins_social];
    [payroll addTermTagRef:self.REF_SAVINGS_PENSIONS andValues:self.interest_pension];
    [payroll addTermTagRef:self.REF_TAX_CLAIM_PAYER andValues:self.relief_payer];

    NSUInteger count = [self getChildCount:self.relief_child];
    NSDictionary * relief_claim = U_MAKE_HASH(@"relief_code", 1);
    [payroll addTermTagRef:self.REF_TAX_CLAIM_CHILD andValues:relief_claim asTimes:count];

    [payroll addTermTagRef:self.REF_TAX_CLAIM_DISABILITY andValues:self.relief_disability];
    [payroll addTermTagRef:self.REF_TAX_CLAIM_STUDYING andValues:self.relief_studying];
    [payroll addTermTagRef:self.REF_TAX_EMPLOYERS_HEALTH andValues:self.interest_emp_health];
    [payroll addTermTagRef:self.REF_TAX_EMPLOYERS_SOCIAL andValues:self.interest_emp_social];

    [payroll addTermTagRef:self.REF_INCOME_GROSS andValues:EMPTY_VALUES];
    PYGTagRefer  * evResultTermTag = [payroll addTermTagRef:self.REF_INCOME_NETTO andValues:EMPTY_VALUES];
    NSDictionary * evResultDictVal = [payroll evaluate:evResultTermTag];
    return payroll;
}

- (NSUInteger)getChildCount:(NSDictionary *)specs {
    return U_GET_FROM(specs, @"relief_code");
}

- (NSDictionary *)computePayrollForPeriod:(PYGPayrollPeriod *)period {
    PYGPayrollProcess *payroll = [self createPayrollProcessForPeriod:period];

    PYGResultExporter *payroll_export = [PYGResultExporter resultExporterWithPayrollConfig:payroll];

    NSArray * resultSection0 = [payroll_export getSourceEarningsExport];
    NSArray * resultSection1 = [payroll_export getSourceScheduleExport];
    NSArray * resultSection2 = [payroll_export getSourcePaymentsExport];
    NSArray * resultSection3 = [payroll_export getSourceTaxSourceExport];
    NSArray * resultSection4 = [payroll_export getSourceTaxInsIncomeExport];
    NSArray * resultSection5 = [payroll_export getSourceTaxInsResultExport];
    NSArray * resultSection6 = [payroll_export getSourceSummaryExport];

    return @{
            SECTION_0 : [self normalizeResult:resultSection0],
            SECTION_1 : [self normalizeResult:resultSection1],
            SECTION_2 : [self normalizeResult:resultSection2],
            SECTION_3 : [self normalizeResult:resultSection3],
            SECTION_4 : [self normalizeResult:resultSection4],
            SECTION_5 : [self normalizeResult:resultSection5],
            SECTION_6 : [self normalizeResult:resultSection6]
    };
}

- (NSArray *)normalizeResult:(NSArray *)result {
    if (result == nil || result.count == 0)
    {
        return @[@{RESULT_TITLE : @"", RESULT_VALUE : @""}];
    }
    else
    {
        return result;
    }
}

- (bool)exportPayrollForPeriod:(PYGPayrollPeriod *)period toXml:(NSString *)xmlFilePath {
    PYGPayrollProcess *payroll = [self createPayrollProcessForPeriod:period];

    PYGXmlResultExporter * exporter = [PYGXmlResultExporter resultExporterWithPayrollConfig:payroll];

    [exporter exportXml:xmlFilePath
             forCompany:self.companyName
          andDepartment:self.companyDept
          andPersonName:self.employeeName
        andPersonNumber:self.employeeNumb];
    return YES;
}

- (bool)exportPayrollForPeriod:(PYGPayrollPeriod *)period toPdf:(NSString *)pdfFilePath {
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFilePath, CGRectZero, nil);
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

    PdfRenderer * pdfEngine = [PdfRenderer pdfRenderer];

    int xOrigin = 50;
    int yOrigin = 300;

    int rowHeight = 50;
    int titleColumnWidth = 240;
    int valueColumnWidth = 120;

    int numberOfRows = 7;

    CGPoint originNil = CGPointMake(50, -300);
    [pdfEngine drawTableDataAt:originNil withRowHeight:rowHeight
                 andTitleWidth:titleColumnWidth andValueWidth:valueColumnWidth andRowCount:numberOfRows];

    CGPoint origin = CGPointMake(xOrigin, yOrigin);
    [pdfEngine drawTableAt:origin withRowHeight:rowHeight
             andTitleWidth:titleColumnWidth andValueWidth:valueColumnWidth andRowCount:numberOfRows];

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
    return YES;
}

- (NSString*)getPdfFileName:(NSString *)pdfName
{
    NSString* fileName = pdfName;

    NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(
                    NSDocumentDirectory,
                    NSUserDomainMask,
                    YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];

    return pdfFileName;
}

- (NSString*)getXmlFileName:(NSString *)xmlName
{
    NSString* fileName = xmlName;

    NSArray *arrayPaths =
            NSSearchPathForDirectoriesInDomains(
                    NSDocumentDirectory,
                    NSUserDomainMask,
                    YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* xmlFileName = [path stringByAppendingPathComponent:fileName];

    return xmlFileName;
}

@end