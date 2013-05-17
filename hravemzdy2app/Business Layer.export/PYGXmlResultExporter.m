//
// Created by Ladislav Lisy on 01.05.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGXmlResultExporter.h"
#import "PYGPayrollProcess.h"
#include <libxml/encoding.h>
#include <libxml/xmlwriter.h>

#define MY_ENCODING "ISO-8859-2"
//#define MY_ENCODING "windows-1250"

@implementation PYGXmlResultExporter {

}
- (id)initWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    self = [super initWithPayrollConfig:pPayrollConfig];
    if (self) {
    }
    return self;
}

+ (id)xmlResultExporterWithPayrollConfig:(PYGPayrollProcess *)pPayrollConfig {
    return [[self alloc] initWithPayrollConfig:pPayrollConfig];
}

- (bool)exportXml:(NSString *)fileName forCompany:(NSString *)company andDepartment:(NSString *)department
    andPersonName:(NSString *)personName andPersonNumber:(NSString *)personNumber {

    NSStringEncoding stringEncoding = NSISOLatin2StringEncoding;
    //NSStringEncoding stringEncoding = NSWindowsCP1250StringEncoding;
    const char *pdfFileNameCStr = [fileName cStringUsingEncoding:stringEncoding];
    xmlChar *companyCStr        = (xmlChar*)[company UTF8String];
    xmlChar *departmentCStr     = (xmlChar*)[department UTF8String];
    xmlChar *personNameCStr     = (xmlChar*)[personName UTF8String];
    xmlChar *personNumberCStr   = (xmlChar*)[personNumber UTF8String];
    BOOL done = NO;

    int rc;
    xmlTextWriterPtr writer;

    /* Create a new XmlWriter for uri, with no compression. */
    writer = xmlNewTextWriterFilename(pdfFileNameCStr, 0);
    if (writer == NULL) {
        NSLog(@"testXmlwriterFilename: Error creating the xml writer\n");
        return done;
    }

    /* Start the document with the xml default for the version,
     * encoding ISO 8859-1 and the default for the standalone
     * declaration. */
    rc = xmlTextWriterStartDocument(writer, NULL, MY_ENCODING, NULL);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartDocument\n");
        return done;
    }

    /* Start an element named "payslips". Since thist is the first
     * element, this will be the root element of the document. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "payslips");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Start an element named "payslip" as child of payslips. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "payslip");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Start an element named "employee" as child of payslip. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "employee");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Write an element named "personnel_number" as child of employee. */
    rc = xmlTextWriterWriteElement(writer, BAD_CAST "personnel_number", personNumberCStr);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteFormatElement\n");
        return done;
    }

    /* Write an element named "personnel_number" as child of employee. */
    rc = xmlTextWriterWriteElement(writer, BAD_CAST "common_name", personNameCStr);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteFormatElement\n");
        return done;
    }

    /* Write an element named "personnel_number" as child of employee. */
    rc = xmlTextWriterWriteElement(writer, BAD_CAST "department", departmentCStr);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteFormatElement\n");
        return done;
    }

    /* Close the element named employee. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Start an element named "employer" as child of payslip. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "employer");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Write an element named "common_name" as child of employer. */
    rc = xmlTextWriterWriteElement(writer, BAD_CAST "common_name", companyCStr);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteFormatElement\n");
        return done;
    }

    /* Close the element named employer. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Start an element named "results" as child of payslip. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "results");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Write an element named "period" as child of results. */
    rc = xmlTextWriterWriteElement(writer, BAD_CAST "period", personNumberCStr);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterWriteFormatElement\n");
        return done;
    }

    /* Start an element named "result" as child of results. */
    rc = xmlTextWriterStartElement(writer, BAD_CAST "result");
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterStartElement\n");
        return done;
    }

    /* Close the element named result. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Close the element named results. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Close the element named payslip. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Close the element named payslips. */
    rc = xmlTextWriterEndElement(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndElement\n");
        return done;
    }

    /* Here we could close the elements ORDER and EXAMPLE using the
     * function xmlTextWriterEndElement, but since we do not want to
     * write any other elements, we simply call xmlTextWriterEndDocument,
     * which will do all the work. */
    rc = xmlTextWriterEndDocument(writer);
    if (rc < 0) {
        NSLog(@"testXmlwriterFilename: Error at xmlTextWriterEndDocument\n");
        return done;
    }

    xmlFreeTextWriter(writer);

    done = YES;

    return done;
}

@end