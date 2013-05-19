//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGPaymentDeductionResult.h"
#import "PYGPayrollConcept.h"
#import "PYGXmlBuilder.h"


@implementation PYGPaymentDeductionResult {

}

// tag_code, concept_code, concept_item, values
- (id)initWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    if (!(self=[super initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept andValues:values])) return nil;
    return self;
}

+ (id)newWithTagCode:(NSUInteger)tagCode andConceptCode:(NSUInteger)conceptCode andConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:tagCode andConceptCode:conceptCode andConcept:concept andValues:values];
}

+ (id)newWithConcept:(PYGPayrollConcept *)concept andValues:(NSDictionary *)values{
    return [[self alloc] initWithTagCode:concept.tagCode andConceptCode:concept.code andConcept:concept andValues:values];
}

- (NSDecimalNumber *)getDeduction {
    return self.payment;
}

- (NSDecimalNumber *)getPayment {
    return self.payment;
}

- (BOOL)exportResultXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
            @"payment" : [self.payment stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"value" withValue:[self xmlValue] withAttributes:attributes];
    return done;
}

- (NSString *)xmlValue {
    NSString * amountString = [self.payment stringValue];
    return [amountString stringByAppendingString:@" CZK"];
}

- (NSString *)exportValueResult {
    NSError *error = NULL;
    //Create the regular expression to match against
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d)(?=(\\d\\d\\d)+(?!\\d))" options:NSRegularExpressionCaseInsensitive error:&error];
    // create the new string by replacing the matching of the regex pattern with the template pattern(whitespace)
    NSString * amountString = [self.payment stringValue];
    NSString * formatAmount = [regex stringByReplacingMatchesInString:amountString options:0
                                                                range:NSMakeRange(0, [amountString length])
                                                         withTemplate:@"$1 "];
    return [formatAmount stringByAppendingString:@" CZK"];
}

@end