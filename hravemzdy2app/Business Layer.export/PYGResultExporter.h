//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollProcess;

@interface PYGResultExporter : NSObject

-(id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;
+(id)exporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;

-(NSArray *)getSourceScheduleExport;
-(NSArray *)getSourcePaymentsExport;
-(NSArray *)getSourceTaxSourceExport;
-(NSArray *)getSourceTaxIncomeExport;
-(NSArray *)getSourceInsIncomeExport;
-(NSArray *)getSourceTaxResultExport;
-(NSArray *)getSourceInsResultExport;
-(NSArray *)getSourceSummaryExport;

@end