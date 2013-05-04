//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTaxEmployersHealthTag.h"
#import "PYGSymbolTags.h"
#import "PYGSymbolConcepts.h"


@implementation PYGTaxEmployersHealthTag {

}
- (id)init {
    if (!(self=[super initWithCodeName:[PYGSymbolTags codeRef:TAG_TAX_EMPLOYERS_HEALTH]
                            andConcept:[PYGSymbolConcepts codeRef:CONCEPT_TAX_EMPLOYERS_HEALTH]])) return nil;
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGTaxEmployersHealthTag *)tag {
    return [[self alloc] init];
}

@end