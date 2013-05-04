//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefChildTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxReliefChildTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_RELIEF_CHILD]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_RELIEF_CHILD]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxReliefChildTag *)tag {
    return [[self alloc] init];
}

@end