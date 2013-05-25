//
//  PYGDetailViewController.m
//  hravemzdyapp
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "PYGDetailViewController.h"
#import "PdfPaycheckGenerator.h"
#import "PYGPayrollPeriod.h"
#import "NSDate+PYGDateOnly.h"
#import "PYGPayrollModel.h"
#import "PYGDetailTableViewCell.h"

#define SECTION_0 @0
#define SECTION_1 @1
#define SECTION_2 @2
#define SECTION_3 @3
#define SECTION_4 @4
#define SECTION_5 @5
#define SECTION_6 @6

#define RESULT_TITLE @"title"
#define RESULT_VALUE @"value"
#define RESULT_IMAGE @"image"

@interface PYGDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIPopoverController *periodPopoverController;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSArray* sections;

@property (strong, nonatomic) NSDateFormatter* dateFormatter;

@property (strong, nonatomic) PYGPayrollPeriod * period;

@property (strong, nonatomic) PYGPayrollModel* model;

@property (strong, nonatomic) NSArray * resultSection0;
@property (strong, nonatomic) NSArray * resultSection1;
@property (strong, nonatomic) NSArray * resultSection2;
@property (strong, nonatomic) NSArray * resultSection3;
@property (strong, nonatomic) NSArray * resultSection4;
@property (strong, nonatomic) NSArray * resultSection5;
@property (strong, nonatomic) NSArray * resultSection6;

@property (strong, nonatomic) NSString* pdfFileName;
@property (strong, nonatomic) NSString* bundlePdfName;
@property (strong, nonatomic) PdfPaycheckGenerator* generator;
@property (strong, nonatomic) NSString* xmlFileName;
@property (strong, nonatomic) NSString* bundleXmlName;

@property (strong, nonatomic) UIImage * cellImageI;
@property (strong, nonatomic) UIImage * cellImageD;
@property (strong, nonatomic) UIImage * cellImageS;
@property (strong, nonatomic) UIImage * cellImageT;


- (void)configureView;
@end

@implementation PYGDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"VIEW_RESULTS", @"Payroll results");

    self.sections = [self createTableSections];
    self.period = [self setUpPayrollPeriod];
    self.dateFormatter = [self setUpDateFormatter];

    // Set-up code here.
    self.model = [PYGPayrollModel payrollModel];

    self.bundlePdfName = NSLocalizedString(@"EMAIL_PAYCHECK_PDF", @"PaycheckPdf");
    self.pdfFileName = [self.model getPdfFileName:self.bundlePdfName];
    self.bundleXmlName = NSLocalizedString(@"EMAIL_PAYCHECK_XML", @"PaycheckXml");
    self.xmlFileName = [self.model getXmlFileName:self.bundleXmlName];
    self.generator = [PdfPaycheckGenerator pdfPaycheckGeneratorWithFileName:self.pdfFileName andDelegate:self];

    self.cellImageI = [UIImage imageNamed:[self getImageNameForTypeOfResult:TYPE_RESULT_INCOME]];
    self.cellImageD = [UIImage imageNamed:[self getImageNameForTypeOfResult:TYPE_RESULT_DEDUCTION]];
    self.cellImageS = [UIImage imageNamed:[self getImageNameForTypeOfResult:TYPE_RESULT_SUMMARY]];
    self.cellImageT = [UIImage imageNamed:[self getImageNameForTypeOfResult:TYPE_RESULT_SCHEDULE]];

    self.resultSection0 = [self.model normalizeResult:nil];
    self.resultSection1 = [self.model normalizeResult:nil];
    self.resultSection2 = [self.model normalizeResult:nil];
    self.resultSection3 = [self.model normalizeResult:nil];
    self.resultSection4 = [self.model normalizeResult:nil];
    self.resultSection5 = [self.model normalizeResult:nil];
    self.resultSection6 = [self.model normalizeResult:nil];

    return self;
}

- (PYGPayrollPeriod *)setUpPayrollPeriod {
    NSDate * currentDate = [NSDate date];
    return [PYGPayrollPeriod payrollPeriodWithYear:(NSUInteger)currentDate.year andMonth:(Byte)currentDate.month];

}

- (NSDateFormatter *)setUpDateFormatter {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [formatter setDateFormat:@"LLLL yyyy"];
    return formatter;
}

- (void)setPayrollTitles:(NSDictionary *)values {
    [self.model setPayrollTitles:values];
}

- (void)setPayrollValues:(NSDictionary *)values {
    [self.model setPayrollValues:values];

    NSDictionary *result = [self.model computePayrollForPeriod:self.period];

    self.resultSection0 = [self.model normalizeResult:result[SECTION_0]];
    self.resultSection1 = [self.model normalizeResult:result[SECTION_1]];
    self.resultSection2 = [self.model normalizeResult:result[SECTION_2]];
    self.resultSection3 = [self.model normalizeResult:result[SECTION_3]];
    self.resultSection4 = [self.model normalizeResult:result[SECTION_4]];
    self.resultSection5 = [self.model normalizeResult:result[SECTION_5]];
    self.resultSection6 = [self.model normalizeResult:result[SECTION_6]];

    [self.payrollResultView reloadData];
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

    NSString * periodText = [self getPeriodTitle];
    [periodNavigationButton setTitle:periodText forState:UIControlStateNormal];

    [periodNavigationButton addTarget:self action:@selector(pickPayrollPeriod) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setTitleView:periodNavigationButton];
    UIBarButtonItem *sharePaycheckButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(paycheckMenu)];
    [self.navigationItem setRightBarButtonItem:sharePaycheckButton];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [self.model computePayrollForPeriod:self.period];
}

- (NSDate *)getPeriodDate {
    NSDate * periodDate = [NSDate dateWithYear:self.period.year month:self.period.month day:1];
    return periodDate;
}

- (NSString *)getPeriodTitle {
    NSDate *periodDate= [self getPeriodDate];
    return [self.dateFormatter stringFromDate:periodDate];
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
    pickerViewController.delegate = self;
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

    self.periodPopoverController = nil;
}

- (void)dismissPeriodPopoverCanceled {
    [self.periodPopoverController dismissPopoverAnimated:YES];
}

- (void)dismissPeriodPopoverFinished {
    UIViewController * contentController = [self.periodPopoverController contentViewController];
    PYGPeriodPickerViewController *pickerController = (PYGPeriodPickerViewController*)contentController;

    NSInteger selectedYear = (NSInteger)pickerController.selectedDate.year;
    NSInteger selectedMonth = (NSInteger)pickerController.selectedDate.month;
    self.period = [PYGPayrollPeriod payrollPeriodWithYear:(NSUInteger) selectedYear andMonth:(Byte)selectedMonth];

    [self.periodPopoverController dismissPopoverAnimated:YES];

    UIButton* periodNavigationButton = (UIButton*)[self.navigationItem titleView];

    NSString * periodText = [self getPeriodTitle];
    [periodNavigationButton setTitle:periodText forState:UIControlStateNormal];

    NSDictionary *result = [self.model computePayrollForPeriod:self.period];

    self.resultSection0 = [self.model normalizeResult:result[SECTION_0]];
    self.resultSection1 = [self.model normalizeResult:result[SECTION_1]];
    self.resultSection2 = [self.model normalizeResult:result[SECTION_2]];
    self.resultSection3 = [self.model normalizeResult:result[SECTION_3]];
    self.resultSection4 = [self.model normalizeResult:result[SECTION_4]];
    self.resultSection5 = [self.model normalizeResult:result[SECTION_5]];
    self.resultSection6 = [self.model normalizeResult:result[SECTION_6]];

    [self.payrollResultView reloadData];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"VIEW_OPTIONS", @"Payroll specs");
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

- (NSArray *)createTableSections {
    return @[
            NSLocalizedString(@"SECTION_SUMMARY", @"Summary results"),
            NSLocalizedString(@"SECTION_SCHEDULE",@"Schedule details"),
            NSLocalizedString(@"SECTION_PAYMENTS",@"Payments"),
            NSLocalizedString(@"SECTION_TAX_PAYMENT",@"Tax and insurance"),
            NSLocalizedString(@"SECTION_TAX_DECL",@"Tax declaration"),
            NSLocalizedString(@"SECTION_TAX_INCOME", @"Tax and Insurance income")
    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: return self.resultSection6.count;
        case 1: return self.resultSection1.count;
        case 2: return self.resultSection2.count;
        case 3: return self.resultSection5.count;
        case 4: return self.resultSection3.count;
        case 5: return self.resultSection4.count;
        default: break;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)self.sections[(NSUInteger)section];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *DetailCellIdentifier = @"DetailTableCell";

    PYGDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];

    if (cell == nil) {
        NSArray *cellObjects = [[NSBundle mainBundle] loadNibNamed:@"PYGDetailTableViewCell" owner:self options:nil];
        cell = (PYGDetailTableViewCell*) [cellObjects objectAtIndex:0];
    }
    // Make cell unselectable
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    // portrait  = 728.000000 - 710.000000
    // landscape = 663.000000 - 645.000000
//    UILabel * labelTitle = (UILabel *)[cell viewWithTag:DetailTitleCell];
//    UILabel * labelValue = (UILabel *)[cell viewWithTag:DetailValueCell];
//    UIImageView * labelImage = (UIImageView *)[cell viewWithTag:DetailImageCell];
    cell.labelTitle.text = [self getTitleResultForSection:indexPath.section andRow:indexPath.row];
    cell.labelValue.text = [self getValueResultForSection:indexPath.section andRow:indexPath.row];
    cell.labelImage.image = [self getImageResultForSection:indexPath.section andRow:indexPath.row];

    return cell;
}

- (NSString *)getTitleResultForSection:(NSInteger)section andRow:(NSInteger)row {
    NSUInteger indexRow = (NSUInteger)row;
    switch (section) {
        case 0: return self.resultSection6[indexRow][RESULT_TITLE];
        case 1: return self.resultSection1[indexRow][RESULT_TITLE];
        case 2: return self.resultSection2[indexRow][RESULT_TITLE];
        case 3: return self.resultSection5[indexRow][RESULT_TITLE];
        case 4: return self.resultSection3[indexRow][RESULT_TITLE];
        case 5: return self.resultSection4[indexRow][RESULT_TITLE];
        default: break;
    }
    return @"";
}

- (NSString *)getValueResultForSection:(NSInteger)section andRow:(NSInteger)row {
    NSUInteger indexRow = (NSUInteger)row;
    switch (section) {
        case 0: return self.resultSection6[indexRow][RESULT_VALUE];
        case 1: return self.resultSection1[indexRow][RESULT_VALUE];
        case 2: return self.resultSection2[indexRow][RESULT_VALUE];
        case 3: return self.resultSection5[indexRow][RESULT_VALUE];
        case 4: return self.resultSection3[indexRow][RESULT_VALUE];
        case 5: return self.resultSection4[indexRow][RESULT_VALUE];
        default: break;
    }
    return @"";
}

- (NSString *)getImageNameForTypeOfResult:(NSUInteger)typeOfResult {
    switch (typeOfResult) {
        case TYPE_RESULT_SUMMARY:
            return @"summaryG";
        case TYPE_RESULT_SCHEDULE:
            return @"schedule";
        case TYPE_RESULT_INCOME:
            return @"income";
        case TYPE_RESULT_DEDUCTION:
            return @"deduction";
    }
    return @"";
}

- (UIImage *)getImageResultForTypeOfResult:(NSUInteger)typeOfResult {
    switch (typeOfResult) {
        case TYPE_RESULT_SUMMARY:
            return self.cellImageS;
        case TYPE_RESULT_SCHEDULE:
            return self.cellImageT;
        case TYPE_RESULT_INCOME:
            return self.cellImageI;
        case TYPE_RESULT_DEDUCTION:
            return self.cellImageD;
    }
    return nil;
}


- (UIImage *)getImageResultForSection:(NSInteger)section andRow:(NSInteger)row {
    NSUInteger indexRow = (NSUInteger)row;
    NSNumber * typeOfResult = nil;
    switch (section) {
        case 0: typeOfResult = self.resultSection6[indexRow][RESULT_IMAGE]; break;
        case 1: typeOfResult = self.resultSection1[indexRow][RESULT_IMAGE]; break;
        case 2: typeOfResult = self.resultSection2[indexRow][RESULT_IMAGE]; break;
        case 3: typeOfResult = self.resultSection5[indexRow][RESULT_IMAGE]; break;
        case 4: typeOfResult = self.resultSection3[indexRow][RESULT_IMAGE]; break;
        case 5: typeOfResult = self.resultSection4[indexRow][RESULT_IMAGE]; break;
        default: break;
    }
    return [self getImageResultForTypeOfResult:typeOfResult.unsignedIntegerValue];
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
- (void)exportPaycheckPDF:(NSString*)fileNameWithPath
{
    NSString * periodText = [self getPeriodTitle];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    self.spinner.hidesWhenStopped = YES;
    [self.view addSubview:self.spinner];
    [self.spinner startAnimating];

    [self.generator generateReportFor:@[
            self.resultSection0, self.resultSection3,
            self.resultSection4, self.resultSection5,
            self.resultSection6]
    andPeriod:periodText];
}

- (void)exportPaycheckXML:(NSString*)fileNameWithPath
{
    [self.model exportPayrollForPeriod:self.period toXml:self.xmlFileName];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //[self drawPDF:self.pdfFileName];
        [self exportPaycheckPDF:self.pdfFileName];
    }
    else if (buttonIndex == 1) {
        [self exportPaycheckXML:self.xmlFileName];
        [self sendExportedPaycheck:self.xmlFileName asFileName:self.bundleXmlName asType:@"application/xml"];
    }
}

- (void)sendExportedPaycheck:(NSString *)fileNameWithPath asFileName:(NSString *)fileName asType:(NSString *)typeOfAttachment{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];

        [self composeEmail:fileNameWithPath  asFileName:fileName asType:typeOfAttachment controller:controller];

        if (controller) {
            [self presentViewController:controller animated:YES completion:NULL];
        }
    } else {
        // Handle the error
    }
}

- (void)composeEmail:(NSString *)fileNameWithPath asFileName:(NSString *)fileName asType:(NSString *)typeOfAttachment controller:(MFMailComposeViewController *)controller {
    controller.mailComposeDelegate = self;

    [controller setSubject:NSLocalizedString(@"EMAIL_SUBJECT_PAYCHECK", @"Your Paycheck")];
    [controller setMessageBody:NSLocalizedString(@"EMAIL_BODY_PAYCHECK",@"Hello, there is file with your paycheck.") isHTML:NO];


    NSData *fileData = [NSData dataWithContentsOfFile:fileNameWithPath];
    [controller addAttachmentData:fileData mimeType:typeOfAttachment fileName:fileName];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)showPdfFile:(NSString *)fileNameWithPath
{
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];

    NSURL *url = [NSURL fileURLWithPath:fileNameWithPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];

    [self.view addSubview:webView];
}

- (void)generatorFinishedCanceled {
    [self.spinner stopAnimating];
}

- (void)generatorFinishedSuccess {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    self.spinner = nil;

    [self sendExportedPaycheck:self.pdfFileName asFileName:self.bundlePdfName asType:@"application/pdf"];
    //[self showPdfFile:self.pdfFileName];
}
@end