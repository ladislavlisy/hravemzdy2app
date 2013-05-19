//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGTermEffectResult.h"
#import "PYGPayrollConcept.h"
#import "PYGXmlBuilder.h"


@implementation PYGTermEffectResult {

}

@synthesize dayOrdFrom = _dayOrdFrom;
@synthesize dayOrdEnd  = _dayOrdEnd;

// tag_code, concept_code, concept_item, values
- (id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    if (!(self=[super initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept])) return nil;
    [self setupValues:values];
    return self;
}

+ (id)newWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept andValues:values];
}

+ (id)newWithConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:concept.tagCode andConceptCode:concept.code andConcept:concept andValues:values];
}

- (void)setupValues:(NSDictionary *)values {
    NSParameterAssert(values != nil);
    _dayOrdFrom = I_SAFE_VALUES(@"day_ord_from");
    _dayOrdEnd  = I_SAFE_VALUES(@"day_ord_end");
}

- (BOOL)exportResultXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"day_ord_from" : [@(self.dayOrdFrom) stringValue],
            @"day_ord_to" : [@(self.dayOrdEnd) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"value" withValue:[self xmlValue] withAttributes:attributes];
    return done;
}

- (NSString *)xmlValue {
    NSString * fromString = [@(self.dayOrdFrom) stringValue];
    NSString * endString  = [@(self.dayOrdEnd) stringValue];
    if (self.dayOrdFrom!=0 && self.dayOrdEnd!=0)
    {
       return [NSString stringWithFormat:@"%@ - %@", fromString, endString];
    }
    else
    {
        return @"whole period";
    }
}

- (NSString *)exportValueResult {
    NSString * fromString = [@(self.dayOrdFrom) stringValue];
    NSString * endString  = [@(self.dayOrdEnd) stringValue];
    if (self.dayOrdFrom!=0 && self.dayOrdEnd!=0)
    {
        return [NSString stringWithFormat:@"%@ - %@", fromString, endString];
    }
    else
    {
        return @"whole period";
    }
}

@end