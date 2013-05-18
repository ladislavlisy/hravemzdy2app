//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"

@class PRKGenerator;


@interface PdfPaycheckGenerator : NSObject<PRKGeneratorDataSource, PRKGeneratorDelegate>

- (id)initWithFileName:(NSString *)pdfFileName;
+ (id)pdfPaycheckGeneratorWithFileName:(NSString *)pdfFileName;

- (void)generateReportFor:(NSArray *)results andPeriod:(NSString *)periodName;
- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber;
- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data;

@end