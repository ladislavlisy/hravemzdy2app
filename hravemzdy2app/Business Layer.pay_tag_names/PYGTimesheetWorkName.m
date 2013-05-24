//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetWorkName.h"
#import "PYGSymbolTags.h"

@implementation PYGTimesheetWorkName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TIMESHEET_WORK]
                               andTitle:NSLocalizedString(@"TAG_TITLE_TIMESHEET_WORK", @"Working Timesheet hours")
                         andDescription:NSLocalizedString(@"TAG_DESCRIPT_TIMESHEET_WORK", @"Working Timesheet hours")
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTimesheetWorkName *)name {
    return [[self alloc] init];
}

@end
