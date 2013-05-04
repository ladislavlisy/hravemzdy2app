//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGHoursAbsenceTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGHoursAbsenceTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_HOURS_ABSENCE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_HOURS_ABSENCE]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGHoursAbsenceTag *)tag {
    return [[self alloc] init];
}

@end