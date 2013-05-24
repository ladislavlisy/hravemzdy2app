//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxWithholdName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_WITHHOLD]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TAX_WITHHOLD", @"Withholding Tax")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TAX_WITHHOLD", @"Withholding Tax")
                           andVertGroup:VPAYGRP_TAX_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxWithholdName *)name {
    return [[self alloc] init];
}

@end
