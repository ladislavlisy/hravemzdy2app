//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxIncomeBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxIncomeBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TAX_INCOME_BASE", @"Taxable income")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TAX_INCOME_BASE", @"Taxable income")
                           andVertGroup:VPAYGRP_TAX_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxIncomeBaseName *)name {
    return [[self alloc] init];
}

@end
