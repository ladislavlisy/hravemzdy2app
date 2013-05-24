//
// Created by Ladislav Lisy on 24.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PYGMoneyCzech : NSObject<NSCoding>

@property (nonatomic, readonly, strong) NSDecimalNumber *amount;
@property (nonatomic, readonly, assign) NSLocale *locale;

- (PYGMoneyCzech *)initWithAmount:(NSDecimalNumber *)anAmount andLocale:(NSLocale *)aLocale;
- (PYGMoneyCzech *)initWithIntegerAmount:(NSInteger)anAmount andLocale:(NSLocale *)aLocale;
- (PYGMoneyCzech *)initWithStringAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale;
- (PYGMoneyCzech *)initWithLocalAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale;

+ (PYGMoneyCzech *)moneyCzechWithAmount:(NSDecimalNumber *)anAmount andLocale:(NSLocale *)aLocale;
+ (PYGMoneyCzech *)moneyCzechWithIntegerAmount:(NSInteger)anAmount andLocale:(NSLocale *)aLocale;
+ (PYGMoneyCzech *)moneyCzechWithStringAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale;
+ (PYGMoneyCzech *)moneyCzechWithLocalAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale;

- (NSString *)localizedString;
- (NSString *)generalString;

@end