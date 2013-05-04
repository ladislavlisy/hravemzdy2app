//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxWithholdName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_WITHHOLD]
                               andTitle:@"Withholding Tax" andDescription:@"Withholding Tax"
                           andVertGroup:VPAYGRP_TAX_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxWithholdName *)name {
    return [[self alloc] init];
}

@end
