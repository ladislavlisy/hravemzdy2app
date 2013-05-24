//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursAbsenceName.h"
#import "PYGSymbolTags.h"
#import "PYGPayNameGateway.h"

@implementation PYGHoursAbsenceName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_HOURS_ABSENCE]
                               andTitle:NSLocalizedString(@"TAG_TITLE_HOURS_ABSENCE", @"Absence hours")
                               andDescription:NSLocalizedString(@"TAG_DESCRIPT_HOURS_ABSENCE", @"Absence hours")
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGHoursAbsenceName *)name {
    return [[self alloc] init];
}

@end
