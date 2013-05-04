//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxAdvanceBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_ADVANCE_BASE]
                               andTitle:@"Tax advance base" andDescription:@"Tax advance base"
                           andVertGroup:VPAYGRP_TAX_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxAdvanceBaseName *)name {
    return [[self alloc] init];
}

@end
