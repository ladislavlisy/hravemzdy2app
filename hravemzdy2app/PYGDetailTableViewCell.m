//
// Created by Ladislav Lisy on 27.04.13.
// Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PYGDetailTableViewCell.h"


@implementation PYGDetailTableViewCell {

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
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

@end