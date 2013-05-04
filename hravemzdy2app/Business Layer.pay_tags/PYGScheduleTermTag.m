//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGScheduleTermTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGScheduleTermTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_SCHEDULE_TERM]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_SCHEDULE_TERM]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGScheduleTermTag *)tag {
    return [[self alloc] init];
}

@end