//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PdfPaycheckGenerator.h"
#import "PRKGenerator.h"
#import "NSArray+Func.h"
#import "PYGPaycheckItem.h"

@interface PdfPaycheckGenerator ()

    @property (assign, nonatomic) id <PdfPaycheckGeneratorDelegate> delegate;

@end

@implementation PdfPaycheckGenerator {
    NSDictionary * defaultValues;
    NSArray * resultValues1;
    NSArray * resultValues2;
    NSArray * resultValues3;
    NSArray * resultValues4;
    NSArray * resultValues5;
    NSString * reportFileName;
}
- (id)initWithFileName:(NSString*)pdfFileName andDelegate:(id<PdfPaycheckGeneratorDelegate>)delegate {
    if (!(self = [super init])) return nil;
    self.delegate = delegate;
    reportFileName = pdfFileName;
    return self;
}

+ (id)pdfPaycheckGeneratorWithFileName:(NSString*)pdfFileName andDelegate:(id<PdfPaycheckGeneratorDelegate>)delegate {
    return [[self alloc] initWithFileName:pdfFileName andDelegate:delegate];
}

- (void)generateReportFor:(NSArray *)results andPeriod:(NSString *)periodName {
    NSString *bundleName = [[NSBundle mainBundle] bundlePath];
    NSString *bundleFURL = [[NSURL fileURLWithPath:bundleName] absoluteString];
    resultValues1 = [results[0] map:^id (id tag) {
        NSDictionary * dictionaryValues = (NSDictionary *)tag;
        return [PYGPaycheckItem paycheckItemWithValues:dictionaryValues];
    }];
    resultValues2 = [results[1] map:^id (id tag) {
        NSDictionary * dictionaryValues = (NSDictionary *)tag;
        return [PYGPaycheckItem paycheckItemWithValues:dictionaryValues];
    }];
    resultValues3 = [results[2] map:^id (id tag) {
        NSDictionary * dictionaryValues = (NSDictionary *)tag;
        return [PYGPaycheckItem paycheckItemWithValues:dictionaryValues];
    }];
    resultValues4 = [results[3] map:^id (id tag) {
        NSDictionary * dictionaryValues = (NSDictionary *)tag;
        return [PYGPaycheckItem paycheckItemWithValues:dictionaryValues];
    }];
    resultValues5 = [results[4] map:^id (id tag) {
        NSDictionary * dictionaryValues = (NSDictionary *)tag;
        return [PYGPaycheckItem paycheckItemWithValues:dictionaryValues];
    }];
    defaultValues = @{
            @"bundle_folder"  : [NSString stringWithString:bundleFURL],
            @"payrollee_name" : @"Payroll Happiness",
            @"employee_name"  : @"Ladislav Lisy",
            @"period_name"    : [NSString stringWithString:periodName],
            @"employee_numb"  : @"00010",
            @"employee_dept"  : @"IT Crowd",
            @"employer_name"  : @"Hrave Mzdy s.r.o."
    };

    NSError * error;
    NSString * templatePath = [[NSBundle mainBundle] pathForResource:@"paycheck" ofType:@"mustache"];
    [[PRKGenerator sharedGenerator] createReportWithName:@"paycheck" templateURLString:templatePath baseURLString:bundleFURL
                                            itemsPerPage:1 totalItems:1 pageOrientation:PRKPortraitPage
                                              dataSource:self delegate:self error:&error];
}

- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber
{
    if ([tagName isEqualToString:@"result_details_gross"]) {
        if ([resultValues5 count] == 2) {
            return [resultValues5 subarrayWithRange:NSMakeRange(0, 1)];
        }
        else
        {
            return @[[PYGPaycheckItem paycheckItemWithTitle:@"" andValue:@""]];
        }
    }
    else if ([tagName isEqualToString:@"result_details_netto"]) {
        if ([resultValues5 count] == 2) {
            return [resultValues5 subarrayWithRange:NSMakeRange(1, 1)];
        }
        else
        {
            return @[[PYGPaycheckItem paycheckItemWithTitle:@"" andValue:@""]];
        }
    }
    else if ([tagName isEqualToString:@"result_details_1"]) {
        return resultValues1;
    }
    else if ([tagName isEqualToString:@"result_details_2"]) {
        return resultValues2;
    }
    else if ([tagName isEqualToString:@"result_details_3"]) {
        return resultValues3;
    }
    else if ([tagName isEqualToString:@"result_details_4"]) {
        return resultValues4;
    }
    else if ([tagName isEqualToString:@"bundle_folder"]) {
        NSString *tagValue = [defaultValues valueForKey:tagName];
        return tagValue;
    }

    return [defaultValues valueForKey:tagName];
}

- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data
{
    [data writeToFile:reportFileName atomically:YES];

    [self.delegate generatorFinishedSuccess];
}

- (void)dealloc {
    NSLog(@"PdfPaycheckGenerator dealloc");
}

@end