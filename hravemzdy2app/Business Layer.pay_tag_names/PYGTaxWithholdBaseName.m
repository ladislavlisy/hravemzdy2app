//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdBaseName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxWithholdBaseName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_WITHHOLD_BASE]
                               andTitle:@"Withholding Tax base" andDescription:@"Withholding Tax base"
                           andVertGroup:VPAYGRP_TAX_INCOME andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxWithholdBaseName *)name {
    return [[self alloc] init];
}

@end
