//
// Created by lisy on 01.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPayTagGateway.h"
#import "PYGUnknownTag.h"
#import "PYGSymbolTags.h"
#import "NSString+RubyCocoaString.h"
#import "PYGCodeNameRefer.h"
#import "PYGPayrollTag.h"

#define PYGTagClassAssert(condition, className, codeName) NSCAssert((condition), @"Tag Class not implemented: %s for: %s", className, codeName)

@implementation PYGPayTagGateway {

}

- (id)init {
    if (!(self=[super init])) return nil;
    models = [NSMutableDictionary dictionaryWithObjectsAndKeys:[PYGUnknownTag tag], @(TAG_UNKNOWN), nil];
    return self;
}

- (PYGPayrollTag *)tagFor:(NSString *)tagCodeName {
    NSString * tagClass = [self classNameFor:tagCodeName];
    PYGPayrollTag * tagInstance = [[NSClassFromString(tagClass) alloc] init];
    PYGTagClassAssert(tagInstance != nil, [tagClass UTF8String], [tagCodeName UTF8String]);
    return tagInstance;
}

- (NSString *)classNameFor:(NSString *)tagCodeName {
    NSRegularExpression * conceptRegex = [NSRegularExpression regularExpressionWithPattern:@"TAG_(.*)" options:0 error:NULL];
    NSTextCheckingResult * regexMatch = [conceptRegex firstMatchInString:tagCodeName options:0 range:NSMakeRange(0, [tagCodeName length])];
    NSString * tagClass = [tagCodeName substringWithRange:[regexMatch rangeAtIndex:1]];
    NSString * className = [[[tagClass underscore] camelize] concat:@"Tag"];
    return [@"PYG" concat:className];
}

- (PYGPayrollTag *)tagFromModels:(PYGCodeNameRefer *)termTag {
    PYGPayrollTag * baseTag = nil;
    if ((baseTag=[models objectForKey:@([termTag code])])==nil)
    {
        baseTag = [self emptyTagFor:termTag];
        [models setObject:baseTag forKey:@(termTag.code)];
    }
    return baseTag;
}

- (PYGPayrollTag *)findTag:(NSUInteger)tagCode {
    PYGPayrollTag * baseTag = nil;
    if ((baseTag=[models objectForKey:@(tagCode)])==nil)
    {
        baseTag = [models objectForKey:@(TAG_UNKNOWN)];
    }
    return baseTag;

}

- (PYGPayrollTag *)emptyTagFor:(PYGCodeNameRefer *)termTag {
    PYGPayrollTag * emptyTag = [self tagFor:[termTag name]];
    return emptyTag;
}
@end