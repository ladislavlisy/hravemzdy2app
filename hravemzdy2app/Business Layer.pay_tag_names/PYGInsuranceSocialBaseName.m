//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceSocialBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGInsuranceSocialBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INSURANCE_SOCIAL_BASE]
                               andTitle:@"Social insurance base" andDescription:@"Assessment base for Social insurance"
                           andVertGroup:VPAYGRP_INS_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceSocialBaseName *)name {
    return [[self alloc] init];
}

@end
