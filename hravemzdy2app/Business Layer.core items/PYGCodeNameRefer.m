//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGCodeNameRefer.h"

@implementation PYGCodeNameRefer {

}
@synthesize code = _code;
@synthesize name = _name;

- (id)initWithCode:(NSUInteger)code andName:(NSString *)name {
    if (!(self=[super init])) return nil;
    _code = code;
    _name = [NSString stringWithString: name];
    return self;
}

- (id)copyWithZone:(NSZone*) zone {
    return self;
}

+ (PYGCodeNameRefer*)CodeNameReferWithCode:(NSUInteger)code andName:(NSString *)name {
    return [[self alloc] initWithCode:code andName:name];
}

- (NSComparisonResult)compare:(PYGCodeNameRefer*)other {
    return [self compareInt:_code AndOtherInt:other.code];
}

- (NSComparisonResult)compareInt:(NSUInteger)selfProp AndOtherInt:(NSUInteger)otherProp {
    return ((selfProp < otherProp) ? NSOrderedAscending : ((selfProp > otherProp) ? NSOrderedDescending : NSOrderedSame));
}

- (BOOL)isEqualToTagRefer:(PYGCodeNameRefer*)other {
    if (_code == other.code)
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

    result += prime * result + _code;
    return result;
}

@end