//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefPayerName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxReliefPayerName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_RELIEF_PAYER]
                               andTitle:@"Tax relief - payer" andDescription:@"Tax relief - payer (§ 35ba)"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxReliefPayerName *)name {
    return [[self alloc] init];
}

@end
