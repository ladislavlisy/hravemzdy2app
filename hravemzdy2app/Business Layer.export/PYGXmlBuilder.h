//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PYGXmlBuilder : NSObject

+ (id)xmlBuilder;

- (BOOL)startDocument:(NSString *)filePath withEncoding:(NSString *)encoding;
- (BOOL)closeDocument;

- (BOOL)openXmlElement:(NSString *)elementTitle;

- (BOOL)writeXmlElement:(NSString *)elementTitle withValue:(NSString *)elementValue withAttributes:(NSDictionary *)attributes;
- (BOOL)writeXmlElement:(NSString *)elementTitle withAttributes:(NSDictionary *)attributes;
- (BOOL)writeXmlElement:(NSString *)elementTitle withValue:(NSString *)elementValue;

- (BOOL)openXmlElement:(NSString *)elementName withAttributes:(NSDictionary *)attributes;
- (BOOL)closeXmlElement;

- (NSString *)stringFromDate:(NSDate *)date;

- (BOOL)writeXmlContent:(NSString *)elementValue;
- (BOOL)writeAttributes:(NSDictionary *)attributes;

@end