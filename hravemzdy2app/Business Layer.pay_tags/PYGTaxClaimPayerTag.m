//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxClaimPayerTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxClaimPayerTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_CLAIM_PAYER]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_CLAIM_PAYER]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxClaimPayerTag *)tag {
    return [[self alloc] init];
}

@end