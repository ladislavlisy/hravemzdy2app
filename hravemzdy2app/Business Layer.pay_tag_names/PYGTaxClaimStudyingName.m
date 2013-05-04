//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimStudyingName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxClaimStudyingName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_STUDYING]
                               andTitle:@"Tax benefit claim - studying" andDescription:@"Tax benefit claim - studying"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimStudyingName *)name {
    return [[self alloc] init];
}

@end
