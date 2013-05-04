//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceFinalName.h"
#import "PYGSymbolTags.h"

@implementation PYGTaxAdvanceFinalName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL]
                               andTitle:@"Tax advance after relief" andDescription:@"Tax advance after relief"
                           andVertGroup:VPAYGRP_TAX_RESULT andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxAdvanceFinalName *)name {
    return [[self alloc] init];
}

@end
