//
// Created by Ladislav Lisy on 24.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGMoneyCzech.h"

static NSString * const kPYGMoneyCzechAmountKey = @"amount";
static NSString * const kPYGMoneyCzechLocaleKey = @"locale";

@interface PYGMoneyCzech ()

@property (nonatomic, readwrite, strong) NSDecimalNumber *amount;
@property (nonatomic, readwrite, assign) NSLocale *locale;

@end

@implementation PYGMoneyCzech {

}
- (PYGMoneyCzech *)initWithAmount:(NSDecimalNumber *)anAmount andLocale:(NSLocale *)aLocale {
    if (!(self = [super init])) return nil;
    if (!isnan(anAmount.doubleValue)) {
        self.amount = [NSDecimalNumber decimalNumberWithDecimal:[anAmount decimalValue]];
    }
    else
    {
        self.amount = [NSDecimalNumber decimalNumberWithDecimal:[DECIMAL_ZERO decimalValue]];
    }
    self.locale = aLocale;
    return self;
}

- (PYGMoneyCzech *)initWithIntegerAmount:(NSInteger)anAmount andLocale:(NSLocale *)aLocale {
    return [self initWithAmount:[NSDecimalNumber decimalNumberWithDecimal:[@(anAmount) decimalValue]] andLocale:aLocale];
}

- (PYGMoneyCzech *)initWithStringAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale {
    NSDecimalNumber * decimalAmount = [NSDecimalNumber decimalNumberWithDecimal:[[self generalValue:anAmount] decimalValue]];

    return [self initWithAmount:decimalAmount andLocale:aLocale];
}

- (PYGMoneyCzech *)initWithLocalAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale {

    NSString * localizedAmount = [NSString stringWithString:[self convertNoBreakingSpaceInString:anAmount]];

    NSDecimalNumber *localizedDecimal = [self localizedValue:localizedAmount withLocale:aLocale];

    NSDecimalNumber *decimalAmount = [NSDecimalNumber decimalNumberWithDecimal:[localizedDecimal decimalValue]];

    return [self initWithAmount:decimalAmount andLocale:aLocale];
}

+ (PYGMoneyCzech *)moneyCzechWithAmount:(NSDecimalNumber *)anAmount andLocale:(NSLocale *)aLocale {
    return [[self alloc] initWithAmount:anAmount andLocale:aLocale];
}

+ (PYGMoneyCzech *)moneyCzechWithIntegerAmount:(NSInteger)anAmount andLocale:(NSLocale *)aLocale {
    return [[self alloc] initWithIntegerAmount:anAmount andLocale:aLocale];
}

+ (PYGMoneyCzech *)moneyCzechWithStringAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale {
    return [[self alloc] initWithStringAmount:anAmount andLocale:aLocale];
}

+ (PYGMoneyCzech *)moneyCzechWithLocalAmount:(NSString *)anAmount andLocale:(NSLocale *)aLocale {
    return [[self alloc] initWithLocalAmount:anAmount andLocale:aLocale];
}

- (NSString *)localizedString {
    return [self localizedStringWithLocale:self.locale];
}

- (NSDecimalNumber *)localizedValue:(NSString *)localizedString {
    return [self localizedValue:localizedString withLocale:self.locale];
}

- (NSString *)localizedStringWithLocale:(NSLocale *)aLocale {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [self setupCurrencyFormatter:formatter withLocale:aLocale];

    __autoreleasing NSString * stringValue = [formatter stringFromNumber:self.amount];
    return stringValue;
}

- (NSDecimalNumber *)localizedValue:(NSString *)localizedString withLocale:(NSLocale *)aLocale{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    [self setupCurrencyFormatter:formatter withLocale:aLocale];

    NSNumber *numberValue = [formatter numberFromString:localizedString];

    __autoreleasing NSDecimalNumber * decimalValue = [NSDecimalNumber decimalNumberWithDecimal:[numberValue decimalValue]];
    return decimalValue;
}

- (NSString *)generalString {
    if (isnan(self.amount.doubleValue) || [self.amount isEqual:DECIMAL_ZERO]) {
        return  @"";
    }
    __autoreleasing NSString * stringValue = [self.amount stringValue];
    return stringValue;
}

- (NSDecimalNumber *)generalValue:(NSString *)generalString {
    __autoreleasing NSDecimalNumber * decimalValue = [NSDecimalNumber decimalNumberWithString:generalString];
    return decimalValue;
}

- (void)setupCurrencyFormatter:(NSNumberFormatter *)currencyFormatter {
    [self setupCurrencyFormatter:currencyFormatter withLocale:self.locale];
}

- (void)setupCurrencyFormatter:(NSNumberFormatter *)currencyFormatter withLocale:(NSLocale *)aLocale{
    [currencyFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [currencyFormatter setMaximumFractionDigits:2];
    [currencyFormatter setGeneratesDecimalNumbers:YES];
    [currencyFormatter setLocale:aLocale];
}

- (NSString *)convertNoBreakingSpaceInString:(NSString *)convertedValue {
    NSError *error = NULL;
    NSRegularExpression *regex =
            [NSRegularExpression regularExpressionWithPattern:@"(CZK )"
                                                      options:NSRegularExpressionCaseInsensitive
                                                        error:&error];

    NSRange convertedRange = NSMakeRange(0, [convertedValue length]);

    __autoreleasing NSString * formattedValue =
            [regex stringByReplacingMatchesInString:convertedValue options:0
                                              range:convertedRange
                                       withTemplate:@"CZK\u00A0"];
    return formattedValue;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.amount forKey:kPYGMoneyCzechAmountKey];
    [coder encodeObject:self.locale forKey:kPYGMoneyCzechLocaleKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    NSDecimalNumber *amount = [coder decodeObjectForKey:kPYGMoneyCzechAmountKey];
    NSLocale * locale = [coder decodeObjectForKey:kPYGMoneyCzechLocaleKey];
    return [self initWithAmount:amount andLocale:locale];
}

- (NSString *)description {
    return [self localizedString];
}

@end