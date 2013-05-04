//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdBaseTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxWithholdBaseTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_WITHHOLD_BASE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_WITHHOLD_BASE]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxWithholdBaseTag *)tag {
    return [[self alloc] init];
}

@end