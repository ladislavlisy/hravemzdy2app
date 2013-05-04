//
// Created by lisy on 12.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSDictionary+Func.h"


@implementation NSDictionary (Func)

- (NSDictionary *)selectWithBlock:(NSDictionaryLogicalBlock)block {
    NSParameterAssert(block != nil);

    NSArray *keys = [[self keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^(id key, id obj, BOOL *stop) {
        return block(key, obj);
    }] allObjects];

    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];

    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)sort:(SEL)comparator {
    NSArray *keys = [self keysSortedByValueUsingSelector:comparator];

    NSArray *objects = [self objectsForKeys:keys notFoundMarker:[NSNull null]];

    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (NSDictionary *)merge:(NSDictionary *)other {
    NSArray *keys1 = [self allKeys];
    NSArray *keys2 = [other allKeys];

    NSArray *objects1 = [self objectsForKeys:keys1 notFoundMarker:[NSNull null]];
    NSArray *objects2 = [other objectsForKeys:keys2 notFoundMarker:[NSNull null]];

    return [NSDictionary dictionaryWithObjects:[objects1 arrayByAddingObjectsFromArray:objects2]
                                       forKeys:[keys1 arrayByAddingObjectsFromArray:keys2]];
}

- (NSDictionary *)merge:(NSDictionary *)other withBlock:(NSDictionaryMergeBlock)block {
    NSParameterAssert(block != nil);

    NSMutableDictionary * mergeDict = [self mutableCopy];

    [other enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        id valueRht = object;
        id valueLft = [mergeDict objectForKey:key];

        if (valueLft==nil) {
            [mergeDict setObject:valueRht forKey:key];
        }
        else
        {
            [mergeDict setObject:block(key, valueLft, valueRht) forKey:key];
        }
    }];
    return [NSDictionary dictionaryWithDictionary:mergeDict];
}

- (NSDictionary *)injectForDict:(NSDictionary *)memo with:(NSDictionaryInjectionBlock)block {
    NSParameterAssert(block != nil);

    for (id key in [self allKeys]) {
        memo = block(memo, key, [self objectForKey:key]);
    }

    return memo;
}

- (NSDictionary *)injectForDict:(NSDictionary *)memo sorted:(SEL)comparator with:(NSDictionaryInjectionBlock)block {
    NSParameterAssert(block != nil);

    for (id key in [self keysSortedByValueUsingSelector:comparator]) {
        memo = block(memo, key, [self objectForKey:key]);
    }

    return memo;
}

- (NSArray *)injectForArray:(NSArray *)memo with:(NSArrayDictionaryInjectionBlock)block {
    NSParameterAssert(block != nil);

    for (id key in [self allKeys]) {
        memo = block(memo, key, [self objectForKey:key]);
    }

    return memo;
}

- (NSDecimalNumber *)injectForDecimal:(NSDecimalNumber *)memo with:(NSDecimalDictionaryInjectionBlock)block {
    NSParameterAssert(block != nil);

    for (id key in [self allKeys]) {
        memo = block(memo, key, [self objectForKey:key]);
    }

    return memo;
}

@end