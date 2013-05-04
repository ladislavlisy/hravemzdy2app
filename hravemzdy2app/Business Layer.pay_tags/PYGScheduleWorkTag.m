//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleWorkTag.h"
#import "PYGSymbolConcepts.h"
#import "PYGSymbolTags.h"


@implementation PYGScheduleWorkTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_SCHEDULE_WORK]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_SCHEDULE_WEEKLY]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGScheduleWorkTag *)tag {
    return [[self alloc] init];
}

@end