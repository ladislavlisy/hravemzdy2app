//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetPeriodTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTimesheetPeriodTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TIMESHEET_PERIOD]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TIMESHEET_PERIOD]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTimesheetPeriodTag *)tag {
    return [[self alloc] init];
}

@end