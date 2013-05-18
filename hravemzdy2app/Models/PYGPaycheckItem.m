//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGPaycheckItem.h"

#define RESULT_TITLE @"title"
#define RESULT_VALUE @"value"

@implementation PYGPaycheckItem {

}
- (id)initWithTitle:(NSString *)title andValue:(NSString *)value {
    if (!(self = [super init])) return nil;
    self.title = title;
    self.value = value;
    return self;
}

- (id)initWithValues:(NSDictionary *)values {
    return [self initWithTitle:S_GET_FROM(values, RESULT_TITLE) andValue:S_GET_FROM(values, RESULT_VALUE)];
}

+ (id)paycheckItemWithValues:(NSDictionary *)values {
    return [[self alloc] initWithValues:values];
}

+ (id)paycheckItemWithTitle:(NSString *)title andValue:(NSString *)value {
    return [[self alloc] initWithTitle:title andValue:value];
}

@end