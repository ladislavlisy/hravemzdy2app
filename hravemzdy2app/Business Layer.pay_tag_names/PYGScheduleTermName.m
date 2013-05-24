//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleTermName.h"
#import "PYGSymbolTags.h"

@implementation PYGScheduleTermName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_SCHEDULE_TERM]
                               andTitle:NSLocalizedString(@"TAG_TITLE_SCHEDULE_TERM", @"Working Schedule Terms")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_SCHEDULE_TERM", @"Working Schedule Terms")
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGScheduleTermName *)name {
    return [[self alloc] init];
}

@end
