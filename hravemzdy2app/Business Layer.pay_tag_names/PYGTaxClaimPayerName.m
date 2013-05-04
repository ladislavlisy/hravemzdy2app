//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimPayerName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxClaimPayerName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER]
                               andTitle:@"Tax benefit claim - payer" andDescription:@"Tax benefit claim - payer"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimPayerName *)name {
    return [[self alloc] init];
}

@end
