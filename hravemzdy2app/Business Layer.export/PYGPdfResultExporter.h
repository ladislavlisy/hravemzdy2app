//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "PYGResultExporter.h"


@interface PYGPdfResultExporter : PYGResultExporter

-(id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;
+(id)exporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig;

- (bool)exportPdf:(NSString *)fileName forCompany:(NSString *)company andDepartment:(NSString *)department
    andPersonName:(NSString *)personName andPersonNumber:(NSString *)personNumber;

@end