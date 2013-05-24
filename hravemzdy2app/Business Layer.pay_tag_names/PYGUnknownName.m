//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGUnknownName.h"
#import "PYGSymbolTags.h"

@implementation PYGUnknownName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_UNKNOWN]
                               andTitle:NSLocalizedString(@"TAG_TITLE_UNKNOWN", @"Unknown")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_UNKNOWN", @"Unknown")
                           andVertGroup:VPAYGRP_UNKNOWN andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGUnknownName *)name {
    return [[self alloc] init];
}

@end
