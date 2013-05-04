//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetPeriodName.h"
#import "PYGSymbolTags.h"

@implementation PYGTimesheetPeriodName {

}
- (id)init {
    if (!(self=[super initWithCodeRefer:[PYGSymbolTags codeRef:TAG_TIMESHEET_PERIOD]
                               andTitle:@"Job Timesheet hours" andDescription:@"Job Timesheet hours"
                           andVertGroup:VPAYGRP_SCHEDULE andHorizGroup:HPAYGRP_UNKNOWN])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTimesheetPeriodName *)name {
    return [[self alloc] init];
}

@end
