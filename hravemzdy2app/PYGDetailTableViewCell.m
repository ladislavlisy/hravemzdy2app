//
// Created by Ladislav Lisy on 27.04.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <CoreGraphics/CoreGraphics.h>
#import "PYGDetailTableViewCell.h"


@implementation PYGDetailTableViewCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier])) return nil;
    // Initialization code
    return self;
}

-(void)setFrame:(CGRect)frame
{
    NSUInteger inset = 30;
    //Do your rotation stuffs here :)
//    frame.origin.x += inset;
//    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
//    CGRect b = [self bounds];
//    b.size.width += 30; // allow extra width to slide for editing
//    b.origin.x -= (self.editing) ? 0 : 30; // start 30px left unless editing
//    [contentView setFrame:b];
//    // then calculate (NSString sizeWithFont) and addSubView, the textField as appropriate...
//    //
    [super layoutSubviews];
    NSLog(@"layoutSubviews title.x %f value.x %f", self.labelTitle.frame.origin.x, self.labelValue.frame.origin.x);
    NSLog(@"layoutSubviews title.w %f value.w %f", self.labelTitle.frame.size.width, self.labelValue.frame.size.width);
    NSLog(@"layoutSubviews title.s %f value.s %f",
            self.labelTitle.frame.origin.x + self.labelTitle.frame.size.width,
            self.labelValue.frame.origin.x + self.labelValue.frame.size.width);
}

@end