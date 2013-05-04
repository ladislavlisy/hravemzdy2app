//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimDisabilityName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxClaimDisabilityName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY]
                               andTitle:@"Tax benefit claim - disability" andDescription:@"Tax benefit claim - disability"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimDisabilityName *)name {
    return [[self alloc] init];
}

@end
