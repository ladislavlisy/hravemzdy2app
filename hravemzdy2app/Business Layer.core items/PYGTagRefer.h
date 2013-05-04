//
// Created by lisy on 31.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PYGTagRefer : NSObject <NSCopying>

@property(nonatomic, readonly) NSUInteger periodBase;
@property(nonatomic, readonly) NSUInteger code;
@property(nonatomic, readonly) NSUInteger codeOrder;

-(id)initWithPeriodBase:(NSUInteger)periodBase andCode:(NSUInteger)code andCodeOrder:(NSUInteger)codeOrder;
+(id)tagReferWithPeriodBase:(NSUInteger)periodBase andCode:(NSUInteger)code andCodeOrder:(NSUInteger)codeOrder;

-(NSComparisonResult) compare:(PYGTagRefer*) other;
-(BOOL)isEqual:object;
-(unsigned)hash;

@end