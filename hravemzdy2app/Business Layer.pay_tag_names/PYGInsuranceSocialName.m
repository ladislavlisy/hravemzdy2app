//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceSocialName.h"
#import "PYGSymbolTags.h"

@implementation PYGInsuranceSocialName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL]
                               andTitle:@"Social insurance" andDescription:@"Social insurance contribution"
                           andVertGroup:VPAYGRP_INS_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceSocialName *)name {
    return [[self alloc] init];
}

@end
