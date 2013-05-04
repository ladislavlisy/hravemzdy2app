//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGTagRefer.h"


@implementation PYGTagRefer {

}

@synthesize periodBase = _periodBase;
@synthesize codeOrder = _codeOrder;
@synthesize code = _code;

- (id)initWithPeriodBase:(NSUInteger)periodBase andCode:(NSUInteger)code andCodeOrder:(NSUInteger)codeOrder {
    if (!(self=[super init])) return nil;
    _periodBase = periodBase;
    _code = code;
    _codeOrder = codeOrder;
    return self;
}

+ (id)tagReferWithPeriodBase:(NSUInteger)periodBase andCode:(NSUInteger)code andCodeOrder:(NSUInteger)codeOrder {
    return [[self alloc] initWithPeriodBase:periodBase andCode:code andCodeOrder:codeOrder];
}


- (id)copyWithZone:(NSZone*) zone {
    id copiedTagRefer = [[[self class] allocWithZone:zone] initWithPeriodBase:[self periodBase] andCode:[self code] andCodeOrder:[self codeOrder]];
    return copiedTagRefer;
}

- (NSComparisonResult)compare:(PYGTagRefer*)other {
    if (_periodBase != other.periodBase)
    {
        return [self compareInt:_periodBase AndOtherInt:other.periodBase];
    }
    else if (_code != other.code)
    {
        return [self compareInt:_code AndOtherInt:other.code];
    }
    else if (_codeOrder != other.codeOrder)
    {
        return [self compareInt:_codeOrder AndOtherInt:other.codeOrder];
    }
    return NSOrderedSame;
}

- (NSComparisonResult)compareInt:(NSUInteger)selfProp AndOtherInt:(NSUInteger)otherProp {
    return ((selfProp < otherProp) ? NSOrderedAscending : ((selfProp > otherProp) ? NSOrderedDescending : NSOrderedSame));
}

- (BOOL)isEqualToTagRefer:(PYGTagRefer*)other {
    if (_periodBase == other.periodBase && _code == other.code && _codeOrder == other.codeOrder)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isEqual:(id) other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTagRefer:other];
}

- (unsigned int)hash {
    NSUInteger prime = 31;
    NSUInteger result = 1;

    result += prime * result + _periodBase;
    result += prime * result + _code;
    result += prime * result + _codeOrder;
    return result;
}

@end