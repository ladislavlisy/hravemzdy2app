//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGResultExporter.h"
#import "PYGPayNameGateway.h"
#import "PYGPayrollProcess.h"
#import "NSDictionary+Func.h"
#import "PYGTagRefer.h"
#import "PYGPayrollResult.h"
#import "PYGPayrollName.h"
#import "PYGPayrollTag.h"

@implementation PYGResultExporter {
    PYGPayNameGateway * _payrollNames;
    PYGPayrollProcess * _payrollConfig;
    PYGPayrollPeriod  * _payrollPeriod;
    NSDictionary      * _payrollResult;
}
- (id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    self = [super init];
    if (self) {
        _payrollConfig = pPayrollConfig;
        _payrollNames = [[PYGPayNameGateway alloc] init];
        _payrollPeriod = [_payrollConfig period];
        _payrollResult = [_payrollConfig getResults];
    }
    return self;
}

+ (id)resultExporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    return [[self alloc] initWithPayrollConfig:pPayrollConfig];
}

// VPAYGRP_SCHEDULE   = 'VPAYGRP_SCHEDULE'
// VPAYGRP_PAYMENTS   = 'VPAYGRP_PAYMENTS'
// VPAYGRP_TAX_SOURCE = 'VPAYGRP_TAX_SOURCE'
// VPAYGRP_TAX_RESULT = 'VPAYGRP_TAX_RESULT'
// VPAYGRP_INS_RESULT = 'VPAYGRP_INS_RESULT'
// VPAYGRP_TAX_INCOME = 'VPAYGRP_TAX_INCOME'
// VPAYGRP_INS_INCOME = 'VPAYGRP_INS_INCOME'
// VPAYGRP_SUMMARY    = 'VPAYGRP_SUMMARY'

- (NSArray *)getSourceScheduleExport {
    return [self getResultExport:VPAYGRP_SCHEDULE];
}

- (NSArray *)getSourcePaymentsExport {
    return [self getResultExport:VPAYGRP_PAYMENTS];
}

- (NSArray *)getSourceTaxSourceExport {
    return [self getResultExport:VPAYGRP_TAX_SOURCE];
}

- (NSArray *)getSourceTaxInsIncomeExport {
    NSArray * partIns = [self getResultExport:VPAYGRP_INS_INCOME];
    NSArray * partTax = [self getResultExport:VPAYGRP_TAX_INCOME];
    return [partIns arrayByAddingObjectsFromArray:partTax];
}

- (NSArray *)getSourceTaxIncomeExport {
    return [self getResultExport:VPAYGRP_TAX_INCOME];
}

- (NSArray *)getSourceInsIncomeExport {
    return [self getResultExport:VPAYGRP_INS_INCOME];
}

- (NSArray *)getSourceTaxInsResultExport {
    NSArray * partIns = [self getResultExport:VPAYGRP_INS_RESULT];
    NSArray * partTax = [self getResultExport:VPAYGRP_TAX_RESULT];
    return [partIns arrayByAddingObjectsFromArray:partTax];
}

- (NSArray *)getSourceTaxResultExport {
    return [self getResultExport:VPAYGRP_TAX_RESULT];
}

- (NSArray *)getSourceInsResultExport {
    return [self getResultExport:VPAYGRP_INS_RESULT];
}

- (NSArray *)getSourceSummaryExport {
    return [self getResultExport:VPAYGRP_SUMMARY];
}

- (NSArray *)getResultExport:(NSString *)grpPosition {
    NSString * exportPosition = grpPosition;
    return [_payrollResult injectForArray:@[] sorted:@selector(compare:) with:^NSArray * (NSArray * agr, id key, id obj) {
        PYGTagRefer * tagResult = (PYGTagRefer *)key;
        PYGPayrollResult * valResult = (PYGPayrollResult *)obj;
        return [agr arrayByAddingObjectsFromArray:[self itemExport:exportPosition
                                               doWithPayrollConfig:_payrollConfig andPayrollNames:_payrollNames
                                                      andResultTag: tagResult andResultValue:valResult]];
    }];
}

- (NSArray *)itemExport:(NSString *)grpPosition doWithPayrollConfig:(PYGPayrollProcess *)payConfig
        andPayrollNames:(PYGPayNameGateway *)payNames andResultTag:(PYGTagRefer *)tagResult
         andResultValue:(PYGPayrollResult *)valResult {
    PYGTagRefer * tagRefer = tagResult;
    PYGPayrollTag * tagItem = [payConfig findTag:valResult.tagCode];
    PYGPayrollConcept * tagConcept = [payConfig findConcept:valResult.conceptCode];
    PYGPayrollName * tagName = [payNames findName:tagResult.code];

    if ([tagName isMatchVGroup:grpPosition]) {
        return @[[valResult exportTitleValueForTagRefer:tagRefer andTagName:tagName
                                             andTagItem:tagItem andConcept:tagConcept]];
    }
    else
    {
        return @[];
    }
}

@end