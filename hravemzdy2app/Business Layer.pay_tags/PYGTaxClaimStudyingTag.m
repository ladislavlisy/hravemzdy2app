//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimStudyingTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxClaimStudyingTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_STUDYING]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_CLAIM_STUDYING]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimStudyingTag *)tag {
    return [[self alloc] init];
}

@end