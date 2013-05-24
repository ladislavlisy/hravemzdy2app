//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxAdvanceName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_ADVANCE]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TAX_ADVANCE", @"Tax advance")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TAX_ADVANCE", @"Tax advance")
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxAdvanceName *)name {
    return [[self alloc] init];
}

@end
