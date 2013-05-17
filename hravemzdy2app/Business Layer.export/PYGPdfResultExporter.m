//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPdfResultExporter.h"
#import "PYGPayrollProcess.h"


@implementation PYGPdfResultExporter {

}
- (id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    self = [super initWithPayrollConfig:pPayrollConfig];
    if (self) {
    }
    return self;
}

+ (id)pdfResultExporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    return [[self alloc] initWithPayrollConfig:pPayrollConfig];
}

- (bool)exportPdf:(NSString *)fileName forCompany:(NSString *)company andDepartment:(NSString *)department
    andPersonName:(NSString *)personName andPersonNumber:(NSString *)personNumber {

    NSString *pdfFileName = fileName;
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);

    CFRange currentRange = CFRangeMake(0, 0);
    NSInteger currentPage = 0;
    BOOL done = NO;

    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);

    // Draw a page number at the bottom of each page.
    currentPage++;
    done = [self drawPageNumber:currentPage];

    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();

    return done;
}

- (bool)drawPageNumber:(NSInteger)pageNum
{
    NSString *pageString = [NSString stringWithFormat:@"Page %d", pageNum];
    UIFont *theFont = [UIFont systemFontOfSize:12];
    CGSize maxSize = CGSizeMake(612, 72);

    CGSize pageStringSize = [pageString sizeWithFont:theFont
                                   constrainedToSize:maxSize
                                       lineBreakMode:NSLineBreakByClipping];
    CGRect stringRect = CGRectMake(((612.0 - pageStringSize.width) / 2.0),
            720.0 + ((72.0 - pageStringSize.height) / 2.0),
            pageStringSize.width,
            pageStringSize.height);

    [pageString drawInRect:stringRect withFont:theFont];
    return YES;
}

@end