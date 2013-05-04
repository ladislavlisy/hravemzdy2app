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
                               andTitle:@"Working Schedule Terms" andDescription:@"Working Schedule Terms"
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
