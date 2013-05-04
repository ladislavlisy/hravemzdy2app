//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxAdvanceFinalTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxAdvanceFinalTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_ADVANCE_FINAL]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_ADVANCE_FINAL]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxAdvanceFinalTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isDeductionNetto {
    return YES;
}

@end