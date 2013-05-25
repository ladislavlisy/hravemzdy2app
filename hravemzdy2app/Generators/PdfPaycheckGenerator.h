//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PRKGeneratorDataSource.h"
#import "PRKGeneratorDelegate.h"

@protocol PdfPaycheckGeneratorDelegate

- (void)generatorFinishedCanceled;
- (void)generatorFinishedSuccess;

@end

@class PRKGenerator;

@interface PdfPaycheckGenerator : NSObject<PRKGeneratorDataSource, PRKGeneratorDelegate>

- (id)initWithFileName:(NSString *)pdfFileName andDelegate:(id<PdfPaycheckGeneratorDelegate>)delegate;
+ (id)pdfPaycheckGeneratorWithFileName:(NSString *)pdfFileName andDelegate:(id<PdfPaycheckGeneratorDelegate>)delegate;

- (void)generateReportFor:(NSArray *)results andPeriod:(NSString *)periodName;
- (id)reportsGenerator:(PRKGenerator *)generator dataForReport:(NSString *)reportName withTag:(NSString *)tagName forPage:(NSUInteger)pageNumber;
- (void)reportsGenerator:(PRKGenerator *)generator didFinishRenderingWithData:(NSData *)data;

@end