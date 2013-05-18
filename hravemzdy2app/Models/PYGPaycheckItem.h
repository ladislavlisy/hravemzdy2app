//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PYGPaycheckItem : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *value;

- (id)initWithTitle:(NSString *)title andValue:(NSString *)value;
- (id)initWithValues:(NSDictionary *)values;
+ (id)paycheckItemWithValues:(NSDictionary *)values;
+ (id)paycheckItemWithTitle:(NSString *)title andValue:(NSString *)value;

@end