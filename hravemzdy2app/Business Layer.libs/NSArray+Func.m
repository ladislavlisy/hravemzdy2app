//
// Created by lisy on 11.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSArray+Func.h"


@implementation NSArray (Func)
- (NSMutableArray *)map:(MapBlock)block {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (id object in self) {
        [resultArray addObject:block(object)];
    }
    return resultArray;
}

- (NSMutableArray *)mapWithIndex:(MapIndexBlock)block {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    NSUInteger i = 0;
    for (id object in self) {
        [resultArray addObject:block(object, i++)];
    }
    return resultArray;
}

- (id) inject:(id)memo with:(NSArrayInjectionBlock)block {
    NSUInteger i = 0;
    for (id obj in self) {
        memo = block(memo, obj, i++);
    }
    return memo;
}

- (NSInteger) injectForInteger:(NSInteger)memo with:(NSIntegerArrayInjectionBlock)block {
    NSParameterAssert(block != nil);

    NSUInteger i = 0;
    for (id obj in self) {
        memo = block(memo, [(NSNumber *) obj unsignedIntegerValue], i++);
    }
    return memo;
}

- (NSUInteger) injectForUInteger:(NSUInteger)memo with:(NSUIntegerArrayInjectionBlock)block {
    NSParameterAssert(block != nil);

    NSUInteger i = 0;
    for (id obj in self) {
        memo = block(memo, [(NSNumber *) obj integerValue], i++);
    }
    return memo;
}

- (NSArray *)injectForArray:(NSArray *)memo with:(NSArrArrayInjectionBlock)block {
    NSParameterAssert(block != nil);

    NSUInteger i = 0;
    for (id obj in self) {
        memo = block(memo, obj, i++);
    }
    return memo;
}

- (NSDictionary *)injectForDict:(NSDictionary *)memo with:(NSDictArrayInjectionBlock)block {
    NSParameterAssert(block != nil);

    NSUInteger i = 0;
    for (id obj in self) {
        memo = block(memo, obj, i++);
    }
    return memo;
}

- (id) inject:(NSArrayInjectionBlock)block {
    if ([self count]) {
        return [self inject:[self objectAtIndex:0] with:block];
    }
    return nil;
}
@end