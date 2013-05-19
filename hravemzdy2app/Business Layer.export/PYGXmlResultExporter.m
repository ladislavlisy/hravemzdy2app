//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGXmlResultExporter.h"
#import "PYGPayrollProcess.h"
#import "PYGXmlBuilder.h"
#import "PYGPayrollResult.h"
#import "PYGPayNameGateway.h"
#import "PYGTagRefer.h"
#import "PYGPayrollPeriod.h"
#import "NSDictionary+Func.h"
#include <libxml/encoding.h>
#include <libxml/xmlwriter.h>

#define MY_ENCODING @"ISO-8859-2"
//#define MY_ENCODING @"windows-1250"

@implementation PYGXmlResultExporter {

}
- (id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    if (!(self = [super initWithPayrollConfig:pPayrollConfig])) return nil;
    return self;
}

+ (id)xmlResultExporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    return [[self alloc] initWithPayrollConfig:pPayrollConfig];
}

- (BOOL)exportXml:(NSString *)fileName forCompany:(NSString *)company andDepartment:(NSString *)department
    andPersonName:(NSString *)personName andPersonNumber:(NSString *)personNumber {

    PYGXmlBuilder *xmlBuilder = [PYGXmlBuilder xmlBuilder];

    BOOL done = NO;

    if ([xmlBuilder startDocument:fileName withEncoding:MY_ENCODING]) {

        if ([xmlBuilder openXmlElement:@"payslips"]) {
            if ([xmlBuilder openXmlElement:@"payslip"]) {
                if ([xmlBuilder openXmlElement:@"employee"]) {
                    [xmlBuilder writeXmlElement:@"personnel_number" withValue:personNumber];
                    [xmlBuilder writeXmlElement:@"common_name" withValue:personName];
                    [xmlBuilder writeXmlElement:@"department" withValue:department];
                    [xmlBuilder closeXmlElement];
                }
                if ([xmlBuilder openXmlElement:@"employer"]) {
                    [xmlBuilder writeXmlElement:@"common_name" withValue:company];
                    [xmlBuilder closeXmlElement];
                }
                if ([xmlBuilder openXmlElement:@"results"]) {
                    NSString * periodTitle = [self getPeriodTitle];
                    [xmlBuilder writeXmlElement:@"period" withValue:periodTitle];

                    [self exportResultsXml:xmlBuilder];

                    [xmlBuilder closeXmlElement];
                }

                [xmlBuilder closeXmlElement];
            }
            [xmlBuilder closeXmlElement];
        }
        [xmlBuilder closeDocument];
    }
    done = YES;

    return done;
}

- (BOOL)exportResultsXml:(PYGXmlBuilder*)xmlBuilder {
    [self.results enumerateSorted:@selector(compare:) with:^(id key, id object, BOOL *stop) {
        PYGTagRefer * tagResult = (PYGTagRefer *)key;
        PYGPayrollResult * valResult = (PYGPayrollResult *)object;

        if ([xmlBuilder openXmlElement:@"result"]) {
            [self itemExportXml:xmlBuilder forTag:tagResult andValue:valResult];

            [xmlBuilder closeXmlElement];
        }
    }];
    return YES;
}

- (BOOL)itemExportXml:(PYGXmlBuilder*)xmlBuilder forTag:(PYGTagRefer *)tagResult andValue:(PYGPayrollResult *)valResult {
    PYGPayrollTag *tagItem = [self.payrollConfig findTag:valResult.tagCode];
    PYGPayrollConcept *tagConcept = [self.payrollConfig findConcept:valResult.conceptCode];
    PYGPayrollName *tagName = [self.payrollNames findName:tagResult.code];

    return [valResult exportXml:xmlBuilder forTag:tagResult andName:tagName withItem:tagItem andConcept:tagConcept];
}

@end