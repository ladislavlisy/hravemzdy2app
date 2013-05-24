//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersHealthName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxEmployersHealthName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TAX_EMPLOYERS_HEALTH", @"Tax employer’s Health insurance")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TAX_EMPLOYERS_HEALTH", @"Tax employer’s Health insurance")
                           andVertGroup:VPAYGRP_TAX_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxEmployersHealthName *)name {
    return [[self alloc] init];
}

@end
