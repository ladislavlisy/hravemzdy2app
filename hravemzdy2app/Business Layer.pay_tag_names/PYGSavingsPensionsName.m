//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSavingsPensionsName.h"
#import "PYGSymbolTags.h"

@implementation PYGSavingsPensionsName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_SAVINGS_PENSIONS]
                               andTitle:NSLocalizedString(@"TAG_TITLE_SAVINGS_PENSIONS", @"Pension savings contribution")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_SAVINGS_PENSIONS", @"Pension savings contribution")
                           andVertGroup:VPAYGRP_INS_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGSavingsPensionsName *)name {
    return [[self alloc] init];
}

@end
