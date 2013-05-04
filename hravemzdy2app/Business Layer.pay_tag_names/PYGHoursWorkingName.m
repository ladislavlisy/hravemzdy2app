//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursWorkingName.h"
#import "PYGSymbolTags.h"

@implementation PYGHoursWorkingName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_HOURS_WORKING]
                               andTitle:@"Working hours" andDescription:@"Working hours"
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGHoursWorkingName *)name {
    return [[self alloc] init];
}

@end
