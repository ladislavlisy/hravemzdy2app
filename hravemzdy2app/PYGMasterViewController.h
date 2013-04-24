//
//  PYGMasterViewController.h
//  hravemzdy2app
//
//  Created by Ladislav Lisy on 04/24/13.
//  Copyright (c) 2013 ___HRAVEMZDY___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYGDetailViewController;

@interface PYGMasterViewController : UITableViewController

@property (strong, nonatomic) PYGDetailViewController *detailViewController;

@end