//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollResult.h"
#import "PYGIncomeBaseResult.h"
#import "PYGPayrollConcept.h"
#import "PYGXmlBuilder.h"


@implementation PYGIncomeBaseResult {
}

@synthesize incomeBase = _incomeBase;
@synthesize employeeBase = _employeeBase;
@synthesize employerBase = _employerBase;
@synthesize interestCode = _interestCode;
@synthesize declareCode = _declareCode;
@synthesize minimumAsses = _minimumAsses;

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
    _incomeBase   = D_SAFE_VALUES(@"income_base");
    _employeeBase = D_SAFE_VALUES(@"employee_base");
    _employerBase = D_SAFE_VALUES(@"employer_base");
    _interestCode = U_SAFE_VALUES(@"interest_code");
    _declareCode  = U_SAFE_VALUES(@"declare_code");
    _minimumAsses = U_SAFE_VALUES(@"minimum_asses");
}

- (BOOL)isInterest {
    return self.interestCode!=0;
}

- (BOOL)isDeclared {
    return self.declareCode!=0;
}

- (BOOL)isMinimumAssessment {
    return self.minimumAsses!=0;
}

- (BOOL)exportResultXml:(PYGXmlBuilder*)xmlBuilder {
    NSDictionary *attributes = @{
        @"income_base"   : [self.incomeBase stringValue],
        @"employee_base" : [self.employeeBase stringValue],
        @"employer_base" : [self.employerBase stringValue],
        @"declare_code"  : [@(self.declareCode) stringValue],
        @"interest_code" : [@(self.interestCode) stringValue],
        @"minimum_asses" : [@(self.minimumAsses) stringValue]
    };
    BOOL done = [xmlBuilder writeXmlElement:@"value" withValue:[self xmlValue] withAttributes:attributes];
    return done;
}

- (NSString *)xmlValue {
    NSString * amountString = [self.incomeBase stringValue];
    return [amountString stringByAppendingString:@" CZK"];
}

- (NSString *)exportValueResult {
    NSError *error = NULL;
    //Create the regular expression to match against
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d)(?=(\\d\\d\\d)+(?!\\d))" options:NSRegularExpressionCaseInsensitive error:&error];
    // create the new string by replacing the matching of the regex pattern with the template pattern(whitespace)
    NSString * amountString = [self.incomeBase stringValue];
    NSString * formatAmount = [regex stringByReplacingMatchesInString:amountString options:0
                                                                range:NSMakeRange(0, [amountString length])
                                                         withTemplate:@"$1 "];
    return [formatAmount stringByAppendingString:@" CZK"];
}

@end