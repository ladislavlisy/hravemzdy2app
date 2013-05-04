//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeGrossName.h"
#import "PYGSymbolTags.h"

@implementation PYGIncomeGrossName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_INCOME_GROSS]
                               andTitle:@"Gross income" andDescription:@"Gross income"
                           andVertGroup:VPAYGRP_SUMMARY andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGIncomeGrossName *)name {
    return [[self alloc] init];
}

@end
