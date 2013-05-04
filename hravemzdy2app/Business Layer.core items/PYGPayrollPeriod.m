//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayrollPeriod.h"


@implementation PYGPayrollPeriod {

}
@synthesize code = _code;

- (NSUInteger)year {
    return _code/100;
}

- (Byte)month {
    return (Byte)(_code%100);
}

- (id)initWithCode:(NSUInteger)code {
    if (!(self=[super init])) return nil;
    _code = code;
    return self;
}

- (id)initWithYear:(NSUInteger)year andMonth:(Byte)month {
    return [self initWithCode:year*100 + month];
}

- (id)copyWithZone:(NSZone*) zone {
    id copiedPeriod = [[[self class] alloc] initWithCode:_code];
    return copiedPeriod;
}

+ (PYGPayrollPeriod *)payrollPeriodWithCode:(NSUInteger)code {
    return [[self alloc] initWithCode:code];
}

+ (PYGPayrollPeriod *)payrollPeriodWithYear:(NSUInteger)year andMonth:(Byte)month {
    return [[self alloc] initWithYear:year andMonth:month];
}

@end