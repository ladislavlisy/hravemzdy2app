//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxBonusChildTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxBonusChildTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_BONUS_CHILD]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_BONUS_CHILD]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxBonusChildTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isIncomeNetto {
    return YES;
}

@end