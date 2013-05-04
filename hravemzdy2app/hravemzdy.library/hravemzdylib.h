#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

#define CODE_NAME_REF(tag, name) [PYGCodeNameRefer CodeNameReferWithCode:tag andName:name],[NSNumber numberWithUnsignedInt:tag]

#define DECIMAL_ZERO [NSDecimalNumber zero]

#define DECIMAL_NUMB(number) [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]]
#define DECIMAL_NEG(number) [number decimalNumberByMultiplyingBy:DECIMAL_NUMB(@(-1))]
#define DECIMAL_INT(number) [number integerValue]
#define DECIMAL_UINT(number) [number unsignedIntegerValue]

#define A_SAFE_VALUE(testValue) (testValue ? [NSArray arrayWithArray:testValue] : @[])
#define S_SAFE_VALUE(testValue) (testValue ? [NSString stringWithString:testValue] : @"")
#define D_SAFE_VALUE(testValue) (testValue ? [NSDecimalNumber decimalNumberWithDecimal:[testValue decimalValue]] : DECIMAL_ZERO)
#define I_SAFE_VALUE(testValue) (testValue ?: 0)
#define U_SAFE_VALUE(testValue) (testValue ?: 0)
#define B_SAFE_VALUE(testValue) (testValue ?: NO)
#define DT_SAFE_VALUE(testValue) (testValue ?: nil)

#define A_SAFE_VALUES(testSymbol) A_SAFE_VALUE((NSArray*) values[testSymbol])
#define S_SAFE_VALUES(testSymbol) S_SAFE_VALUE((NSString*) values[testSymbol])
#define D_SAFE_VALUES(testSymbol) D_SAFE_VALUE((NSDecimalNumber*) values[testSymbol])
#define I_SAFE_VALUES(testSymbol) I_SAFE_VALUE([(NSNumber*) values[testSymbol] integerValue])
#define U_SAFE_VALUES(testSymbol) U_SAFE_VALUE([(NSNumber*) values[testSymbol] unsignedIntegerValue])
#define B_SAFE_VALUES(testSymbol) B_SAFE_VALUE([(NSNumber*) values[testSymbol] boolValue])
#define DT_SAFE_VALUES(testSymbol) DT_SAFE_VALUE((NSDate*) values[testSymbol])

#define A_GET_FROM(valDict, valSymbol) (NSArray*)valDict[valSymbol]
#define S_GET_FROM(valDict, valSymbol) (NSString*)valDict[valSymbol]
#define D_GET_FROM(valDict, valSymbol) (NSDecimalNumber*) valDict[valSymbol]
#define I_GET_FROM(valDict, valSymbol) [(NSNumber*) valDict[valSymbol] integerValue]
#define U_GET_FROM(valDict, valSymbol) [(NSNumber*) valDict[valSymbol] unsignedIntegerValue]
#define B_GET_FROM(valDict, valSymbol) [(NSNumber*) valDict[valSymbol] boolValue]
#define DT_GET_FROM(valDict, valSymbol) (NSDate*) valDict[valSymbol]

#define A_MAKE_PAIR(symbol, value) symbol:[NSArray arrayWithArray:value]
#define S_MAKE_PAIR(symbol, value) symbol:[NSString stringWithString:value]
#define D_MAKE_PAIR(symbol, value) symbol:[NSDecimalNumber decimalNumberWithDecimal:[value decimalValue]]
#define I_MAKE_PAIR(symbol, value) symbol:[NSNumber numberWithInteger:value]
#define U_MAKE_PAIR(symbol, value) symbol:[NSNumber numberWithUnsignedInteger:value]
#define B_MAKE_PAIR(symbol, value) symbol:@(value)
#define DT_MAKE_PAIR(symbol, value) symbol:value

#define A_MAKE_HASH(symbol, value) @{A_MAKE_PAIR(symbol,value)}
#define S_MAKE_HASH(symbol, value) @{S_MAKE_PAIR(symbol,value)}
#define D_MAKE_HASH(symbol, value) @{D_MAKE_PAIR(symbol,value)}
#define I_MAKE_HASH(symbol, value) @{I_MAKE_PAIR(symbol,value)}
#define U_MAKE_HASH(symbol, value) @{U_MAKE_PAIR(symbol,value)}
#define B_MAKE_HASH(symbol, value) @{B_MAKE_PAIR(symbol,value)}

#define STRTYPE(value) ((NSString*)value)
#define DECTYPE(value) ((NSDecimalNumber*)value)
#define NUMTYPE(value) ((NSNumber*)value)
#define D_UNBOX(value) ((NSNumber*)value).decimalValue
#define I_UNBOX(value) ((NSNumber*)value).integerValue
#define U_UNBOX(value) ((NSNumber*)value).unsignedIntegerValue
#define B_UNBOX(value) ((NSNumber*)value).boolValue

#define TAG_NEW(payroll_tag)([payroll_tag tag])
#define EMPTY_VALUES @{}
