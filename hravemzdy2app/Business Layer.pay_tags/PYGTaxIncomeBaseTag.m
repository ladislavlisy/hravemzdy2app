//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxIncomeBaseTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxIncomeBaseTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_INCOME_BASE]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_INCOME_BASE]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxIncomeBaseTag *)tag {
    return [[self alloc] init];
}

@end