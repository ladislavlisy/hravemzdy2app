//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimChildName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxClaimChildName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_CHILD]
                               andTitle:@"Tax benefit claim - child" andDescription:@"Tax benefit claim - child"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimChildName *)name {
    return [[self alloc] init];
}

@end
