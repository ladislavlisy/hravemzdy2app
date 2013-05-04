//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersSocialName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxEmployersSocialName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_SOCIAL]
                               andTitle:@"Tax employer’s Social insurance" andDescription:@"Tax employer’s Social insurance"
                           andVertGroup:VPAYGRP_TAX_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxEmployersSocialName *)name {
    return [[self alloc] init];
}

@end
