//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxBonusChildName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxBonusChildName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TAX_BONUS_CHILD", @"Tax bonus")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TAX_BONUS_CHILD", @"Tax bonus")
                           andVertGroup:VPAYGRP_TAX_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxBonusChildName *)name {
    return [[self alloc] init];
}

@end
