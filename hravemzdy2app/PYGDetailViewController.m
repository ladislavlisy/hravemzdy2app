//
//  PYGDetailViewController.m
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "PYGDetailViewController.h"
#import "PdfRenderer.h"
#import "PdfPaycheckGenerator.h"
#import "PYGPayrollProcess.h"
#import "PYGPayConceptGateway.h"
#import "PYGPayTagGateway.h"
#import "PYGSymbolTags.h"
#import "PYGResultExporter.h"
#import "PYGPayrollPeriod.h"
#import "NSDate+PYGDateOnly.h"
#import "PYGPeriodPickerViewController.h"
#import "PYGTagRefer.h"

typedef enum {
    DetailTitleCell = 1,
    DetailValueCell = 2
} allDetailCells;

#define RESULT_TITLE @"title"
#define RESULT_VALUE @"value"

@interface PYGDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIPopoverController *periodPopoverController;
@property (strong, nonatomic) NSArray* sections;

@property (strong, nonatomic) NSString* pdfFileName;
@property (strong, nonatomic) PdfPaycheckGenerator* generator;
@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@property (strong, nonatomic) PYGPayrollPeriod * period;
@property (strong, nonatomic) PYGPayrollProcess* payroll;

@property (strong, nonatomic) NSDictionary * schedule_work_value;
@property (strong, nonatomic) NSDictionary * schedule_term_value;
@property (strong, nonatomic) NSDictionary * absence_hours_value;
@property (strong, nonatomic) NSDictionary * salary_amount_value;
@property (strong, nonatomic) NSDictionary *interest_taxes;
@property (strong, nonatomic) NSDictionary *interest_ins_health;
@property (strong, nonatomic) NSDictionary *interest_ins_social;
@property (strong, nonatomic) NSDictionary *interest_pension;
@property (strong, nonatomic) NSDictionary *relief_payer;
@property (strong, nonatomic) NSDictionary * relief_child;
@property (strong, nonatomic) NSDictionary *relief_disability;
@property (strong, nonatomic) NSDictionary *relief_studying;
@property (strong, nonatomic) NSDictionary *interest_emp_health;
@property (strong, nonatomic) NSDictionary *interest_emp_social;
// Set-up code here.
@property (strong, nonatomic) PYGPayTagGateway* payrollTags;
@property (strong, nonatomic) PYGPayConceptGateway* payConcepts;

@property (strong, nonatomic) PYGCodeNameRefer * REF_SCHEDULE_WORK         ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_SCHEDULE_TERM         ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_HOURS_ABSENCE         ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_SALARY_BASE           ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_INCOME_BASE       ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INSURANCE_HEALTH_BASE ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INSURANCE_HEALTH      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INSURANCE_SOCIAL_BASE ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INSURANCE_SOCIAL      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_SAVINGS_PENSIONS      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_CLAIM_PAYER       ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_CLAIM_CHILD       ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_CLAIM_DISABILITY  ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_CLAIM_STUDYING    ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_EMPLOYERS_HEALTH  ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_EMPLOYERS_SOCIAL  ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_ADVANCE_BASE      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_ADVANCE           ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_WITHHOLD_BASE     ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_WITHHOLD          ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_RELIEF_PAYER      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_ADVANCE_FINAL     ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_RELIEF_CHILD      ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_TAX_BONUS_CHILD       ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INCOME_GROSS          ;
@property (strong, nonatomic) PYGCodeNameRefer * REF_INCOME_NETTO          ;

@property (strong, nonatomic) NSArray * resultSection1;
@property (strong, nonatomic) NSArray * resultSection2;
@property (strong, nonatomic) NSArray * resultSection3;
@property (strong, nonatomic) NSArray * resultSection4;
@property (strong, nonatomic) NSArray * resultSection5;
@property (strong, nonatomic) NSArray * resultSection6;

- (void)configureView;
@end

@implementation PYGDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"Payroll results", @"Payroll results");
    self.sections = @[
            @"Schedule details",
            @"Payments",
            @"Tax declaration",
            @"Tax and Insurance income",
            @"Tax and insurance",
            @"Summary results"
    ];
    // Set-up code here.
    self.payrollTags = [[PYGPayTagGateway alloc] init];
    self.payConcepts = [[PYGPayConceptGateway alloc] init];

    NSDate * currentDate = [NSDate date];
    self.period = [PYGPayrollPeriod payrollPeriodWithYear:currentDate.year andMonth:currentDate.month];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setLocale:[NSLocale currentLocale]];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setDateFormat:@"MMM yyyy"];

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

    self.payroll = nil;
    self.resultSection1 = [self normalizeResult:nil];
    self.resultSection2 = [self normalizeResult:nil];
    self.resultSection3 = [self normalizeResult:nil];
    self.resultSection4 = [self normalizeResult:nil];
    self.resultSection5 = [self normalizeResult:nil];
    self.resultSection6 = [self normalizeResult:nil];

    self.pdfFileName = [self getPdfFileName:@"invoice.pdf"];
    self.generator = [PdfPaycheckGenerator pdfPaycheckGeneratorWithFileName:self.pdfFileName];

    return self;
}

- (void)setPayrollTitles:(NSDictionary *)values {
    //descriptionField.text = description;
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

    [self computePayroll];

}

- (void)computePayroll {
    self.payroll = [PYGPayrollProcess payrollProcessWithPeriodCode:self.period.code
                                                           andTags:[self payrollTags]
                                                       andConcepts:[self payConcepts]];

    [self.payroll addTermTagRef:self.REF_SCHEDULE_WORK andValues:self.schedule_work_value];
    [self.payroll addTermTagRef:self.REF_SCHEDULE_TERM andValues:self.schedule_term_value];
    [self.payroll addTermTagRef:self.REF_HOURS_ABSENCE andValues:self.absence_hours_value];
    [self.payroll addTermTagRef:self.REF_SALARY_BASE andValues:self.salary_amount_value];
    [self.payroll addTermTagRef:self.REF_TAX_INCOME_BASE andValues:self.interest_taxes];
    [self.payroll addTermTagRef:self.REF_INSURANCE_HEALTH_BASE andValues:self.interest_ins_health];
    [self.payroll addTermTagRef:self.REF_INSURANCE_HEALTH andValues:self.interest_ins_health];
    [self.payroll addTermTagRef:self.REF_INSURANCE_SOCIAL_BASE andValues:self.interest_ins_social];
    [self.payroll addTermTagRef:self.REF_INSURANCE_SOCIAL andValues:self.interest_ins_social];
    [self.payroll addTermTagRef:self.REF_SAVINGS_PENSIONS andValues:self.interest_pension];
    [self.payroll addTermTagRef:self.REF_TAX_CLAIM_PAYER andValues:self.relief_payer];
    NSUInteger count = U_GET_FROM(self.relief_child, @"relief_code");
    NSDictionary * relief_claim = U_MAKE_HASH(@"relief_code", 1);
    for (int i = 0; i < count; i++) {
        [self.payroll addTermTagRef:self.REF_TAX_CLAIM_CHILD andValues:relief_claim];
    }
    [self.payroll addTermTagRef:self.REF_TAX_CLAIM_DISABILITY andValues:self.relief_disability];
    [self.payroll addTermTagRef:self.REF_TAX_CLAIM_STUDYING andValues:self.relief_studying];
    [self.payroll addTermTagRef:self.REF_TAX_EMPLOYERS_HEALTH andValues:self.interest_emp_health];
    [self.payroll addTermTagRef:self.REF_TAX_EMPLOYERS_SOCIAL andValues:self.interest_emp_social];

    [self.payroll addTermTagRef:self.REF_INCOME_GROSS andValues:EMPTY_VALUES];
    PYGTagRefer  * evResultTermTag = [self.payroll addTermTagRef:self.REF_INCOME_NETTO andValues:EMPTY_VALUES];
    NSDictionary * evResultDictVal = [self.payroll evaluate:evResultTermTag];

    PYGResultExporter * exporter = [PYGResultExporter resultExporterWithPayrollConfig:self.payroll];

    self.resultSection1 = [exporter getSourceScheduleExport];
    self.resultSection2 = [exporter getSourcePaymentsExport];
    self.resultSection3 = [exporter getSourceTaxSourceExport];
    self.resultSection4 = [exporter getSourceTaxInsIncomeExport];
    self.resultSection5 = [exporter getSourceTaxInsResultExport];
    self.resultSection6 = [exporter getSourceSummaryExport];

    exporter = nil;
    self.payroll = nil;

    self.resultSection1 = [self normalizeResult:self.resultSection1];
    self.resultSection2 = [self normalizeResult:self.resultSection2];
    self.resultSection3 = [self normalizeResult:self.resultSection3];
    self.resultSection4 = [self normalizeResult:self.resultSection4];
    self.resultSection5 = [self normalizeResult:self.resultSection5];
    self.resultSection6 = [self normalizeResult:self.resultSection6];

    [self.payrollResultView reloadData];
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

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *periodNavigationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    periodNavigationButton.frame = CGRectMake(0, 0, 200, 30);

    NSDate *periodDate= [self getPeriodDate];
    NSString * periodText = [self.dateFormatter stringFromDate:periodDate];
    [periodNavigationButton setTitle:periodText forState:UIControlStateNormal];

    [periodNavigationButton addTarget:self action:@selector(pickPayrollPeriod) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:periodNavigationButton];
    UIBarButtonItem * sharePaychekButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                         target:self action:@selector(paycheckMenu)];
    [self.navigationItem setRightBarButtonItem:sharePaychekButton];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self computePayroll];
}

- (NSDate *)getPeriodDate {
    NSDate * periodDate = [NSDate dateWithYear:self.period.year month:self.period.month day:1];
    return periodDate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pick Payroll Period
- (void)pickPayrollPeriod {
    PYGPeriodPickerViewController *pickerViewController = [[PYGPeriodPickerViewController alloc] init];
    NSDate * selectedPeriod = self.getPeriodDate;
    [pickerViewController setSelectedDate:selectedPeriod];
    self.periodPopoverController = [[UIPopoverController alloc] initWithContentViewController:pickerViewController];

    [self.periodPopoverController setDelegate:self];

    [self.periodPopoverController setPopoverContentSize:CGSizeMake(300, 216)];

    UIButton* senderButton = (UIButton*)[self.navigationItem titleView];

    [self.periodPopoverController presentPopoverFromRect:senderButton.bounds inView:senderButton
                                permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    UIViewController * contentController = [self.periodPopoverController contentViewController];
    PYGPeriodPickerViewController *pickerController = (PYGPeriodPickerViewController*)contentController;
    NSInteger selectedYear = (NSInteger)pickerController.selectedDate.year;
    NSInteger selectedMonth = (NSInteger)pickerController.selectedDate.month;
    self.period = [PYGPayrollPeriod payrollPeriodWithYear:selectedYear andMonth:(NSInteger)selectedMonth];

    UIButton* periodNavigationButton = (UIButton*)[self.navigationItem titleView];
    NSDate *periodDate= [self getPeriodDate];
    NSString * periodText = [self.dateFormatter stringFromDate:periodDate];
    [periodNavigationButton setTitle:periodText forState:UIControlStateNormal];

    [self computePayroll];
    self.periodPopoverController = nil;
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Payroll specs", @"Payroll specs");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.resultSection1.count; break;
        case 1: return self.resultSection2.count; break;
        case 2: return self.resultSection3.count; break;
        case 3: return self.resultSection4.count; break;
        case 4: return self.resultSection5.count; break;
        case 5: return self.resultSection6.count; break;
        default: break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)self.sections[section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DetailCellIdentifier = @"DetailTableCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];

    if (cell == nil) {
        NSArray *cellObjects = [[NSBundle mainBundle] loadNibNamed:@"PYGDetailTableViewCell" owner:self options:nil];
        cell = (UITableViewCell*) [cellObjects objectAtIndex:0];
    }
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // portrait  = 728.000000 - 710.000000
    // landscape = 663.000000 - 645.000000
    UILabel * labelTitle = (UILabel *)[cell viewWithTag:DetailTitleCell];
    UILabel * labelValue = (UILabel *)[cell viewWithTag:DetailValueCell];
    labelTitle.text = [self getTitleResultForSection:indexPath.section andRow:indexPath.row];
    labelValue.text = [self getValueResultForSection:indexPath.section andRow:indexPath.row];

    return cell;
}

- (NSString *)getTitleResultForSection:(NSInteger)section andRow:(NSInteger)row {
    NSUInteger indexRow = (NSUInteger)row;
    switch (section) {
        case 0: return self.resultSection1[indexRow][RESULT_TITLE]; break;
        case 1: return self.resultSection2[indexRow][RESULT_TITLE]; break;
        case 2: return self.resultSection3[indexRow][RESULT_TITLE]; break;
        case 3: return self.resultSection4[indexRow][RESULT_TITLE]; break;
        case 4: return self.resultSection5[indexRow][RESULT_TITLE]; break;
        case 5: return self.resultSection6[indexRow][RESULT_TITLE]; break;
        default: break;
    }
    return @"";
}

- (NSString *)getValueResultForSection:(NSInteger)section andRow:(NSInteger)row {
    NSUInteger indexRow = (NSUInteger)row;
    switch (section) {
        case 0: return self.resultSection1[indexRow][RESULT_VALUE]; break;
        case 1: return self.resultSection2[indexRow][RESULT_VALUE]; break;
        case 2: return self.resultSection3[indexRow][RESULT_VALUE]; break;
        case 3: return self.resultSection4[indexRow][RESULT_VALUE]; break;
        case 4: return self.resultSection5[indexRow][RESULT_VALUE]; break;
        case 5: return self.resultSection6[indexRow][RESULT_VALUE]; break;
        default: break;
    }
    return @"";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)paycheckMenu {
    UIActionSheet * paycheckActions = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:nil
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:@"Export PDF", @"Export XML", nil];
    UIBarButtonItem * paycheckButton = [self.navigationItem rightBarButtonItem];
    [paycheckActions showFromBarButtonItem:paycheckButton animated:YES];
}

#pragma mark - Pdf file renderer
- (IBAction)showEmployeePayslip:(id)sender {
    //[self drawPDF:self.pdfFileName];
    [self drawInvoicePDF:self.pdfFileName];
    [self showPdfFile:self.pdfFileName];
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

- (void)drawInvoicePDF:(NSString*)fileNameWithPath
{
    [self.generator generateReport];
}

- (void)drawPDF:(NSString*)fileNameWithPath
{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(fileNameWithPath, CGRectZero, nil);
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
}

-(void)showPdfFile:(NSString *)fileNameWithPath
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];

    NSURL *url = [NSURL fileURLWithPath:fileNameWithPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //[self drawPDF:self.pdfFileName];
        [self drawInvoicePDF:self.pdfFileName];
        [self showPdfFile:self.pdfFileName];
    }
    else if (buttonIndex == 1) {
        NSLog(@"Button XML");
    }
}


@end