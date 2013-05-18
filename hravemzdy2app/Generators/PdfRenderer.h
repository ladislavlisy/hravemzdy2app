//
// Created by Ladislav Lisy on 04.05.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PdfRenderer : NSObject

- (id)init;
+ (PdfRenderer *)pdfRenderer;

- (void)drawLineFromPoint:(CGPoint)from toPoint:(CGPoint)to;
- (void)drawText:(NSString *)textToDraw inRect:(CGRect)frameRect;
- (void)drawLabelText:(NSString *)textToDraw inRect:(CGRect)frameRect;
- (void)drawImage:(UIImage*)image inRect:(CGRect)frameRect;
- (void)drawLabels;
- (void)drawTableAt:(CGPoint)origin withRowHeight:(int)rowHeight andTitleWidth:(int)titleColumnWidth
      andValueWidth:(int)valueColumnWidth andRowCount:(int)numberOfRows;
- (void)drawTableDataAt:(CGPoint)origin withRowHeight:(int)rowHeight andTitleWidth:(int)titleColumnWidth
          andValueWidth:(int)valueColumnWidth andRowCount:(int)numberOfRows;

@end