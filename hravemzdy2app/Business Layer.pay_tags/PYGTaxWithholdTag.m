//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxWithholdTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxWithholdTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_WITHHOLD]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_WITHHOLD]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxWithholdTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isDeductionNetto {
    return YES;
}

@end