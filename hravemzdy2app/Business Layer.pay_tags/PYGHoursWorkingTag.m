//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursWorkingTag.h"
#import "PYGSymbolConcepts.h"
#import "PYGSymbolTags.h"


@implementation PYGHoursWorkingTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_HOURS_WORKING]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_HOURS_WORKING]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGHoursWorkingTag *)tag {
    return [[self alloc] init];
}

@end