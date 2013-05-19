//
// Created by Ladislav Lisy on 18.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#include <libxml/encoding.h>
#include <libxml/xmlwriter.h>
#import "PYGXmlBuilder.h"

@interface PYGXmlBuilder ()

@property (nonatomic, readwrite) xmlTextWriterPtr writer;

@end

@implementation PYGXmlBuilder {
    NSDateFormatter *xmlFormatter;
}

- (id)init {
    if (!(self = [super init])) return nil;

    NSStringEncoding stringEncoding = NSISOLatin2StringEncoding;
    //NSStringEncoding stringEncoding = NSWindowsCP1250StringEncoding;
    xmlFormatter = [[NSDateFormatter alloc] init];
    [xmlFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];

    return self;
}

+ (id)xmlBuilder {
    return [[self alloc] init];
}

- (BOOL)startDocument:(NSString *)filePath withEncoding:(NSString *)encoding {
    int rc;

    NSStringEncoding stringEncoding = NSISOLatin2StringEncoding;
    //NSStringEncoding stringEncoding = NSWindowsCP1250StringEncoding;
    const char *filePathXml = [filePath cStringUsingEncoding:stringEncoding];
    /* Create a new XmlWriter for uri, with no compression. */
    self.writer = xmlNewTextWriterFilename(filePathXml, 0);
    if (self.writer == NULL) {
        NSLog(@"testXmlwriterFilename: Error creating the xml writer\n");
        return NO;
    }

    const char *encodingXml = [encoding cStringUsingEncoding:stringEncoding];
    /* Start the document with the xml default for the version,
     * encoding ISO 8859-1 and the default for the standalone
     * declaration. */
    rc = xmlTextWriterStartDocument(self.writer, NULL, encodingXml, NULL);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartDocument\n");
        return NO;
    }
    return YES;
}

- (BOOL)closeDocument {
    /* Here we could close the elements ORDER and EXAMPLE using the
     * function xmlTextWriterEndElement, but since we do not want to
     * write any other elements, we simply call xmlTextWriterEndDocument,
     * which will do all the work. */
    int rc = xmlTextWriterEndDocument(self.writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndDocument\n");
        return NO;
    }

    xmlFreeTextWriter(self.writer);
    return YES;
}

- (BOOL)openXmlElement:(NSString *)elementTitle {
    xmlChar *elementNameXml = (xmlChar*)[elementTitle UTF8String];
    int rc = xmlTextWriterStartElement(self.writer, elementNameXml);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return NO;
    }
    return YES;
}

- (BOOL)openXmlElement:(NSString *)elementTitle withAttributes:(NSDictionary *)attributes {
    if ([self openXmlElement:elementTitle]) {
        if ([self writeAttributes:attributes]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)writeXmlElement:(NSString *)elementTitle withValue:(NSString *)elementValue withAttributes:(NSDictionary *)attributes {
    if ([self openXmlElement:elementTitle]) {
        if ([self writeAttributes:attributes]) {
            if ([self writeXmlContent:elementValue]) {
                if ([self closeXmlElement]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (BOOL)writeXmlElement:(NSString *)elementTitle withAttributes:(NSDictionary *)attributes {
    if ([self openXmlElement:elementTitle]) {
        if ([self writeAttributes:attributes]) {
            if ([self closeXmlElement]) {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)writeXmlElement:(NSString *)elementTitle withValue:(NSString *)elementValue{
    xmlChar *elementTitleXml = (xmlChar*)[elementTitle UTF8String];
    xmlChar *elementValueXml = (xmlChar*)[elementValue UTF8String];
    int rc = xmlTextWriterWriteElement(self.writer, elementTitleXml, elementValueXml);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteElement\n");
        return NO;
    }
    return YES;
}

- (BOOL)writeXmlContent:(NSString *)elementValue{
    xmlChar *elementValueXml = (xmlChar*)[elementValue UTF8String];
    int rc = xmlTextWriterWriteString(self.writer, elementValueXml);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteString\n");
        return NO;
    }
    return YES;
}

- (BOOL)writeAttributes:(NSDictionary *)attributes {
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
        NSString * attributeTitle = (NSString *)key;
        NSString * attributeValue = (NSString *)object;
        xmlChar *attributeTitleXml = (xmlChar*)[attributeTitle UTF8String];
        xmlChar *attributeValueXml = (xmlChar*)[attributeValue UTF8String];
        /* Add an attribute with name "version" and value "1.0" to ORDER. */
        int rcAttribute = xmlTextWriterWriteAttribute(self.writer, attributeTitleXml, attributeValueXml);
        if (rcAttribute < 0) {
            NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteAttribute\n");
            (*stop)=TRUE;
        }
    }];
    return YES;
}

- (BOOL)closeXmlElement {
    /* Close the element. */
    int rc = xmlTextWriterEndElement(self.writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return NO;
    }
    return YES;
}

- (NSString *)stringFromDate:(NSDate *)date {
    if (date == nil) {
        return @"";
    }
    return [xmlFormatter stringFromDate:date];
}

@end