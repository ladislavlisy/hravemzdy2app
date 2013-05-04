//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeGrossTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGIncomeGrossTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INCOME_GROSS]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INCOME_GROSS]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGIncomeGrossTag *)tag {
    return [[self alloc] init];
}

@end