//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGSavingsPensionsTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGSavingsPensionsTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_SAVINGS_PENSIONS]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_SAVINGS_PENSIONS]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGSavingsPensionsTag *)tag {
    return [[self alloc] init];
}

-(BOOL)isDeductionNetto {
    return YES;
}

@end