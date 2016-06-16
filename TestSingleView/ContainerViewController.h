//
//  ContainerViewController.h
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CommonViewController.h"
#import "LeftMenuView.h"

@interface ContainerViewController : CommonViewController <LeftMenuDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *containerScrollView;

@property (strong, nonatomic) NSMutableArray* myContentViews;
@end
