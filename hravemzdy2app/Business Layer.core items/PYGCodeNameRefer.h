//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PYGCodeNameRefer : NSObject <NSCopying>

@property(nonatomic, readonly) NSUInteger code;
@property(nonatomic, readonly) NSString * name;

-(id)initWithCode:(NSUInteger)code andName:(NSString *)name;
+(PYGCodeNameRefer*)CodeNameReferWithCode:(NSUInteger)code andName:(NSString *)name;

//TODO: PYGCodeNameRefer - equal, hash, compare
-(id)copyWithZone:(NSZone*) zone;
-(NSComparisonResult) compare:(PYGCodeNameRefer*) other;
-(BOOL)isEqual:object;
-(unsigned)hash;

@end