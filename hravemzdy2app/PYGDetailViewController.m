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

typedef enum {
    DetailTitleCell = 1,
    DetailValueCell = 2
} allDetailCells;

@interface PYGDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) PdfPaycheckGenerator* generator;
- (void)configureView;
@end

@implementation PYGDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) return nil;
    self.title = NSLocalizedString(@"Detail", @"Detail");

    NSString *pdfFileName = [self getPdfFileName:@"paycheck2.pdf"];
    self.generator = [PdfPaycheckGenerator pdfPaycheckGeneratorWithFileName:pdfFileName];

    return self;
}

- (void)setDescription:(NSString *)description {
    if (descriptionField != nil) {
        descriptionField.text = description;
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
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    return @"Payroll details";
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
    labelTitle.text = @"label c.1";
    labelValue.text = @"1 000";

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Pdf file renderer
- (IBAction)showEmployeePayslip:(id)sender {
    NSString *pdfFileName = [self getPdfFileName:@"paycheck2.pdf"];

    //[self drawPDF:pdfFileName];
    [self drawInvoicePDF:pdfFileName];
    [self showPdfFile:pdfFileName];
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

@end