//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollPeriod;


@interface PYGPayrollModel : NSObject
- (id)init;

- (void)setPayrollTitles:(NSDictionary *)values;
- (void)setPayrollValues:(NSDictionary *)values;

- (NSDictionary *)computePayrollForPeriod:(PYGPayrollPeriod *)period;

- (NSArray *)normalizeResult:(NSArray *)result;

- (bool)exportPayrollForPeriod:(PYGPayrollPeriod *)period toXml:(NSString *)xmlFilePath;
- (bool)exportPayrollForPeriod:(PYGPayrollPeriod *)period toPdf:(NSString *)pdfFilePath;

- (NSString *)getPdfFileName:(NSString *)pdfName;
- (NSString *)getXmlFileName:(NSString *)xmlName;

+ (id)payrollModel;
@end