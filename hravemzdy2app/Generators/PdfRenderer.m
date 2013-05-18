//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PdfRenderer.h"
#import <CoreText/CoreText.h>

typedef enum {
    DetailLabelPayCheck  = 1,
    DetailLabelCompany   = 2,
    DetailValuePeriod    = 3,
    DetailValueEmployee  = 4,
    DetailValuePersonnel = 5,
    DetailImageBrandText = 6,
    DetailImageBrandLogo = 7
} allDetailCells;

@implementation PdfRenderer {

}

- (id)init {
    if (!(self = [super init])) return nil;
    return self;
}

+ (PdfRenderer *)pdfRenderer {
    return [[self alloc] init];
}

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, 2.0);

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    CGFloat components[] = {0.2, 0.2, 0.2, 0.3};

    CGColorRef color = CGColorCreate(colorSpace, components);

    CGContextSetStrokeColorWithColor(context, color);

    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context, to.x, to.y);

    CGContextStrokePath(context);
    CGColorSpaceRelease(colorSpace);
    CGColorRelease(color);
}

- (void)drawVerticalColumnDividerAt:(CGPoint)origin forWidthAt:(float)columnWidth andHeight:(float)tableHeight
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    float x_startPoint = origin.x + columnWidth;
    float y_startPoint = origin.y;
    float y_endPoint   = origin.y + tableHeight;
    CGPoint verticalLineDivider[2] = {CGPointMake(x_startPoint, y_startPoint), CGPointMake(x_startPoint, y_endPoint)};
    CGContextStrokeLineSegments(context, verticalLineDivider, 2);
}

- (void)drawHorizontalRowDividerAt:(CGPoint)origin forHeight:(float)rowHeight andRowCount:(int)count andWidth:(float)tableWidth
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    float x_startPoint = origin.x;
    float y_startPoint = origin.y + (rowHeight*count);
    float x_endPoint   = origin.x + tableWidth;
    CGPoint horizontalLineDivider[2] = {CGPointMake(x_startPoint, y_startPoint), CGPointMake(x_endPoint, y_startPoint)};
    CGContextStrokeLineSegments(context, horizontalLineDivider, 2);
}


- (void)drawVerticalLineAt:(CGPoint)origin forWidth:(float)columnWidth andHeight:(float)tableHeight
{
    float newOrigin = origin.x + (columnWidth);

    CGPoint from = CGPointMake(newOrigin, origin.y);
    CGPoint to = CGPointMake(newOrigin, origin.y + (tableHeight));

    [self drawLineFromPoint:from toPoint:to];
}

- (void)drawHorizontalLineAt:(CGPoint)origin forHeight:(float)rowHeight andRowCount:(int)count andWidth:(float)tableWidth
{
    float newOrigin = origin.y + (rowHeight*count);

    CGPoint from = CGPointMake(origin.x, newOrigin);
    CGPoint to = CGPointMake(origin.x + (tableWidth), newOrigin);

    [self drawLineFromPoint:from toPoint:to];
}

- (void)drawCellText:(NSString *)cellText atTableOrigin:(CGPoint)origin
     andColumnOrigin:(float)columnOrigin andColumnWidth:(float)columnWidth
      andRowHeight:(float)rowHeight atRowNumber:(int)rowNumber
{
    int padding = 10;

    float newOriginX = origin.x + (columnOrigin);
    float newOriginY = origin.y + ((rowNumber+1)*rowHeight);
    CGRect frame = CGRectMake(newOriginX + padding, newOriginY + padding, columnWidth, rowHeight);
    [self drawText:cellText inRect:frame];
}

- (void)drawText:(NSString *)textToDraw inRect:(CGRect)frameRect
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
// Prepare the text using a Core Text FrameSetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(currentText);

    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

// Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

// Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

// Put the text matrix into a known state. This ensures
// that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);

// Core Text draws from the bottom-left corner up, so flip
// the current transform prior to drawing.
// Modify this to take into consideration the origin.
    CGContextTranslateCTM(currentContext, 0, 100/*frameRect.origin.y*2*/);
    CGContextScaleCTM(currentContext, 1.0, -1.0);

// Draw the frame.
    CTFrameDraw(frameRef, currentContext);

// Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*100/*frameRect.origin.y*2*/);

    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(frameSetter);
}

- (void)drawLabelText:(NSString *)textToDraw inRect:(CGRect)frameRect
{
    CFStringRef stringRef = (__bridge CFStringRef)textToDraw;
// Prepare the text using a Core Text FrameSetter
    CFAttributedStringRef currentText = CFAttributedStringCreate(NULL, stringRef, NULL);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(currentText);

    CGMutablePathRef framePath = CGPathCreateMutable();
    CGPathAddRect(framePath, NULL, frameRect);

// Get the frame that will do the rendering.
    CFRange currentRange = CFRangeMake(0, 0);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, currentRange, framePath, NULL);
    CGPathRelease(framePath);

// Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();

// Put the text matrix into a known state. This ensures
// that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);

// Core Text draws from the bottom-left corner up, so flip
// the current transform prior to drawing.
// Modify this to take into consideration the origin.
    CGContextTranslateCTM(currentContext, 0, frameRect.origin.y*2);
    CGContextScaleCTM(currentContext, 1.0, -1.0);

// Draw the frame.
    CTFrameDraw(frameRef, currentContext);

// Add these two lines to reverse the earlier transformation.
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    CGContextTranslateCTM(currentContext, 0, (-1)*frameRect.origin.y*2);

    CFRelease(frameRef);
    CFRelease(stringRef);
    CFRelease(frameSetter);
}

- (void)drawImage:(UIImage *)image inRect:(CGRect)frameRect {
    [image drawInRect:frameRect];
}

- (void)drawLabels
{
    NSArray* objects = [[NSBundle mainBundle] loadNibNamed:@"PaycheckView" owner:nil options:nil];

    UIView* mainView = [objects objectAtIndex:0];

    UILabel* labelPayCheck  = (UILabel*)[mainView viewWithTag:DetailLabelPayCheck];
    UILabel* labelCompany   = (UILabel*)[mainView viewWithTag:DetailLabelCompany];
    UILabel* labelPeriod    = (UILabel*)[mainView viewWithTag:DetailValuePeriod];
    UILabel* labelEmployee  = (UILabel*)[mainView viewWithTag:DetailValueEmployee];
    UILabel* labelPersonnel = (UILabel*)[mainView viewWithTag:DetailValuePersonnel];

    UIImageView* imageBrandText = (UIImageView*)[mainView viewWithTag:DetailImageBrandText];
    UIImageView* imageBrandLogo = (UIImageView*)[mainView viewWithTag:DetailImageBrandLogo];

    [self drawLabelText:labelPayCheck.text inRect:labelPayCheck.frame];
    [self drawLabelText:labelCompany.text inRect:labelCompany.frame];
    [self drawLabelText:labelPeriod.text inRect:labelPeriod.frame];
    [self drawLabelText:labelEmployee.text inRect:labelEmployee.frame];
    [self drawLabelText:labelPersonnel.text inRect:labelPersonnel.frame];

    UIImage* brandText = [UIImage imageNamed:@"paycheck_text.png"];
    [self drawImage:brandText inRect:imageBrandText.frame];
    UIImage* brandLogo = [UIImage imageNamed:@"paycheck_logo.png"];
    [self drawImage:brandLogo inRect:imageBrandLogo.frame];
}

- (void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andTitleWidth:(int)titleColumnWidth
      andValueWidth:(int)valueColumnWidth andRowCount:(int)numberOfRows
{
    for (int i = 0; i <= numberOfRows; i++)
    {
        [self drawHorizontalRowDividerAt:origin forHeight:rowHeight andRowCount:i andWidth:(titleColumnWidth + valueColumnWidth)];
    }
    [self drawVerticalColumnDividerAt:origin forWidthAt:0 andHeight:numberOfRows*rowHeight];
    [self drawVerticalColumnDividerAt:origin forWidthAt:titleColumnWidth andHeight:numberOfRows*rowHeight];
    [self drawVerticalColumnDividerAt:origin forWidthAt:(titleColumnWidth + valueColumnWidth) andHeight:numberOfRows*rowHeight];
}

- (void)drawTableDataAt:(CGPoint)origin withRowHeight:(int)rowHeight andTitleWidth:(int)titleColumnWidth
         andValueWidth:(int)valueColumnWidth andRowCount:(int)numberOfRows
{
    NSArray* headers = [NSArray arrayWithObjects:@"Title description", @"Value CZK", nil];
    NSArray* invoiceInfo1 = [NSArray arrayWithObjects:@"1. Development", @"1000", nil];
    NSArray* invoiceInfo2 = [NSArray arrayWithObjects:@"2. Development", @"2000", nil];
    NSArray* invoiceInfo3 = [NSArray arrayWithObjects:@"3. Development", @"3000", nil];
    NSArray* invoiceInfo4 = [NSArray arrayWithObjects:@"4. Development", @"4000", nil];

    NSArray* allInfo = [NSArray arrayWithObjects:headers, invoiceInfo1, invoiceInfo2, invoiceInfo3, invoiceInfo4, nil];

    for(int i = 0; i < [allInfo count]; i++)
    {
        NSArray* infoToDraw = [allInfo objectAtIndex:i];

        NSString * cellTitleText = (NSString *)[infoToDraw objectAtIndex:0];

        [self drawCellText:cellTitleText atTableOrigin:origin andColumnOrigin:0
            andColumnWidth:titleColumnWidth andRowHeight:rowHeight atRowNumber:i];

        NSString * cellValueText = (NSString *)[infoToDraw objectAtIndex:1];

        [self drawCellText:cellValueText atTableOrigin:origin andColumnOrigin:titleColumnWidth
            andColumnWidth:valueColumnWidth andRowHeight:rowHeight atRowNumber:i];
    }
}

@end