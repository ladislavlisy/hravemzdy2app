//
// Created by lisy on 11.04.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

typedef id(^MapBlock)(id);
typedef id(^MapIndexBlock)(id, NSUInteger idx);
typedef id(^NSArrayInjectionBlock)(id memo, id obj, NSUInteger idx);
typedef NSInteger(^NSIntegerArrayInjectionBlock)(NSInteger memo, NSInteger obj, NSUInteger idx);
typedef NSUInteger(^NSUIntegerArrayInjectionBlock)(NSUInteger memo, NSUInteger obj, NSUInteger idx);
typedef NSArray *(^NSArrArrayInjectionBlock)(NSArray * memo, id obj, NSUInteger idx);
typedef NSDictionary *(^NSDictArrayInjectionBlock)(NSDictionary * memo, id obj, NSUInteger idx);

@interface NSArray (Func)
- (NSMutableArray *)map:(MapBlock)block;
- (NSMutableArray *)mapWithIndex:(MapIndexBlock)block;
- (id)inject:(id)memo with:(NSArrayInjectionBlock)block;
- (NSArray *)injectForArray:(NSArray *)memo with:(NSArrArrayInjectionBlock)block;
- (NSDictionary *)injectForDict:(NSDictionary *)memo with:(NSDictArrayInjectionBlock)block;
- (NSInteger)injectForInteger:(NSInteger)memo with:(NSIntegerArrayInjectionBlock)block;
- (NSUInteger)injectForUInteger:(NSUInteger)memo with:(NSUIntegerArrayInjectionBlock)block;
- (id)inject:(NSArrayInjectionBlock)block;
@end