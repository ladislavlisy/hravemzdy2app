//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleWorkName.h"
#import "PYGSymbolTags.h"

@implementation PYGScheduleWorkName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_SCHEDULE_WORK]
                               andTitle:@"Working schedule" andDescription:@"Working schedule"
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGScheduleWorkName *)name {
    return [[self alloc] init];
}

@end
