//
// Created by lisy on 12.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef void(^NSDictionaryEnumerateBlock)(id key, id obj, BOOL *stop);
typedef BOOL(^NSDictionaryLogicalBlock)(id key, id obj);
typedef NSArray *(^NSArrayDictionaryInjectionBlock)(NSArray * agr, id key, id item);
typedef NSDictionary *(^NSDictionaryInjectionBlock)(NSDictionary * agr, id key, id item);
typedef NSDecimalNumber *(^NSDecimalDictionaryInjectionBlock)(NSDecimalNumber * agr, id key, id item);
typedef id(^NSDictionaryMergeBlock)(id key, id itemLft, id itemRht);

@interface NSDictionary (Func)
-(NSDictionary *)selectWithBlock:(NSDictionaryLogicalBlock)block;
-(NSDictionary *)sort:(SEL)comparator;

-(NSDictionary *)merge:(NSDictionary *)other;
-(NSDictionary *)merge:(NSDictionary *)other withBlock:(NSDictionaryMergeBlock)block;

-(NSDictionary *) injectForDict:(NSDictionary *)memo with:(NSDictionaryInjectionBlock)block;
-(NSDictionary *) injectForDict:(NSDictionary *)memo sorted:(SEL)comparator with:(NSDictionaryInjectionBlock)block;
-(NSArray *) injectForArray:(NSArray *)memo with:(NSArrayDictionaryInjectionBlock)block;
-(NSArray *) injectForArray:(NSArray *)memo sorted:(SEL)comparator with:(NSArrayDictionaryInjectionBlock)block;
-(NSDecimalNumber *)injectForDecimal:(NSDecimalNumber *)memo with:(NSDecimalDictionaryInjectionBlock)block;

- (void)enumerateSorted:(SEL)comparator with:(NSDictionaryEnumerateBlock)block;
@end