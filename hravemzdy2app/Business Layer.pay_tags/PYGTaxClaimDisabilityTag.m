//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimDisabilityTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxClaimDisabilityTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_DISABILITY]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_CLAIM_DISABILITY]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimDisabilityTag *)tag {
    return [[self alloc] init];
}

@end