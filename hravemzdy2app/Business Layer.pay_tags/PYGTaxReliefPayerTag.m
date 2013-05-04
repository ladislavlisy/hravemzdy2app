//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxReliefPayerTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxReliefPayerTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_RELIEF_PAYER]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_RELIEF_PAYER]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxReliefPayerTag *)tag {
    return [[self alloc] init];
}

@end