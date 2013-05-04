//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGIncomeNettoTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGIncomeNettoTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_INCOME_NETTO]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_INCOME_NETTO]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGIncomeNettoTag *)tag {
    return [[self alloc] init];
}

@end