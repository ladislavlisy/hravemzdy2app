//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeNettoName.h"
#import "PYGSymbolTags.h"

@implementation PYGIncomeNettoName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INCOME_NETTO]
                               andTitle:NSLocalizedString(@"TAG_TITLE_INCOME_NETTO", @"Net income")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_INCOME_NETTO", @"Net income")
                           andVertGroup:VPAYGRP_SUMMARY andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGIncomeNettoName *)name {
    return [[self alloc] init];
}

@end
