//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTimesheetWorkTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTimesheetWorkTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TIMESHEET_WORK]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TIMESHEET_WORK]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTimesheetWorkTag *)tag {
    return [[self alloc] init];
}

@end