//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class PYGPayrollProcess;
@class PYGPayNameGateway;

@interface PYGResultExporter : NSObject

@property (nonatomic, strong, readonly) NSDictionary * results;
@property (nonatomic, strong, readonly) PYGPayNameGateway * payrollNames;
@property (nonatomic, strong, readonly) PYGPayrollProcess * payrollConfig;

-(id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;
+(id)resultExporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;

-(NSArray *)getSourceScheduleExport;
-(NSArray *)getSourcePaymentsExport;
-(NSArray *)getSourceEarningsExport;
-(NSArray *)getSourceTaxSourceExport;
-(NSArray *)getSourceTaxInsIncomeExport;
-(NSArray *)getSourceTaxIncomeExport;
-(NSArray *)getSourceInsIncomeExport;
-(NSArray *)getSourceTaxInsResultExport;
-(NSArray *)getSourceTaxResultExport;
-(NSArray *)getSourceInsResultExport;
-(NSArray *)getSourceSummaryExport;

- (NSString *)getPeriodTitle;
@end