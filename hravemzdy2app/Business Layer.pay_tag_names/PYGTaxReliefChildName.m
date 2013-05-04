//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefChildName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxReliefChildName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_RELIEF_CHILD]
                               andTitle:@"Tax relief - child" andDescription:@"Tax relief - child (§ 35c)"
                           andVertGroup:VPAYGRP_TAX_SOURCE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxReliefChildName *)name {
    return [[self alloc] init];
}

@end
