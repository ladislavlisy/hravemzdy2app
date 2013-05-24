//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGInsuranceHealthBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGInsuranceHealthBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INSURANCE_HEALTH_BASE]
                               andTitle:NSLocalizedString(@"TAG_TITLE_INSURANCE_HEALTH_BASE", @"Assessment base for Health insurance")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_INSURANCE_HEALTH_BASE", @"Assessment base for Health insurance")
                           andVertGroup:VPAYGRP_INS_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGInsuranceHealthBaseName *)name {
    return [[self alloc] init];
}

@end
