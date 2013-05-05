//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PdfPaycheckGenerator.h"
#import "InvoiceItem.h"
#import "PRKGenerator.h"


@implementation PdfPaycheckGenerator {
    NSDictionary * defaultValues;
    NSString * reportFileName;
}
- (id)initWithFileName:(NSString*)pdfFileName {
    if (!(self = [super init])) return nil;
    reportFileName = pdfFileName;
    return self;
}

+ (id)pdfPaycheckGeneratorWithFileName:(NSString*)pdfFileName {
    return [[self alloc] initWithFileName:pdfFileName];
}

- (void)generateReport {
    double total = 0;
    NSMutableArray * articles = [NSMutableArray array];
    for (int i = 0; i < 200; i++) {
        int element = i + 123456;
        InvoiceItem * item = [[InvoiceItem alloc] init];
        item.number = element;
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd/MM/yyyy";

        item.date = [formatter stringFromDate:[NSDate date]];
        item.due = [formatter stringFromDate:[[NSDate date] dateByAddingTimeInterval:30 * 24 * 60 * 60]];
        item.notes = @"";
        item.originalTotal = element;
        item.effectiveTotal = element;
        item.receivedTotal = element * 0.8;

        total += item.receivedTotal;
        [articles addObject:item];
    }

    defaultValues = @{
            @"articles"         : articles,
            @"companyName"      : @"Teseo s.r.l.",
            @"companyAddress"   : @"Via A. Carrante, 31",
            @"companyTelephone" : @"0802205198",
            @"companyEmail"     : @"info@teseo.it",
            @"otherCompanyName" : @"Rossi Paolo s.r.l.",
            @"total"            : [NSString stringWithFormat: @"%f", total]
    };

    NSError * error;
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"paycheck" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"paycheck" templateURLString:templatePath itemsPerPage:20 totalItems:articles.count
                                         pageOrientation:PRKLandscapePage dataSource:self delegate:self error:&error];
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
{
    if ([tagName isEqualToString:@"articles"])
        return [[defaultValues valueForKey:tagName] subarrayWithRange:NSMakeRange((pageNumber - 1) * 20, 20)];

    return [defaultValues valueForKey:tagName];
}

- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
{
    [data writeToFile:reportFileName atomically:YES];
}

@end