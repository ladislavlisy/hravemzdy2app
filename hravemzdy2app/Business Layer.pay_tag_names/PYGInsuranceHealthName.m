//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthName.h"
#import "PYGSymbolTags.h"

@implementation PYGInsuranceHealthName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH]
                               andTitle:@"Health insurance" andDescription:@"Health insurance contribution"
                           andVertGroup:VPAYGRP_INS_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceHealthName *)name {
    return [[self alloc] init];
}

@end
