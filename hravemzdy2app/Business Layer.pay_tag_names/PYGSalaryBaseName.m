//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSalaryBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGSalaryBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_SALARY_BASE]
                               andTitle:NSLocalizedString(@"TAG_TITLE_SALARY_BASE", @"Base Salary")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_SALARY_BASE", @"Base Salary")
                           andVertGroup:VPAYGRP_PAYMENTS andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGSalaryBaseName *)name {
    return [[self alloc] init];
}

@end
