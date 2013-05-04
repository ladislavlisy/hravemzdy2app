//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGUnknownConcept.h"
#import "PYGSymbolConcepts.h"
#import "PYGSymbolTags.h"


@implementation PYGUnknownConcept {

}
- (id)initWithTagCode:(NSUInteger)tagCode {
    if (!(self=[super initWithCodeName:[PYGSymbolConcepts codeRef:CONCEPT_UNKNOWN] andTagCode:tagCode])) return nil;
    return self;
}

+ (PYGUnknownConcept *)conceptWithWithTagCode:(NSUInteger)tagCode {
    return [[self alloc] initWithTagCode:tagCode];
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

- (PYGUnknownConcept*)newConceptWithCode:(NSUInteger)tagCode {
    PYGUnknownConcept *concept = [PYGUnknownConcept conceptWithWithTagCode:tagCode];
    [concept  setPendingCodes:self.tagPendingCodes];
    return concept;
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
}

+ (PYGUnknownConcept *)concept {
    return [[self alloc] initWithTagCode:TAG_UNKNOWN];
}

@end