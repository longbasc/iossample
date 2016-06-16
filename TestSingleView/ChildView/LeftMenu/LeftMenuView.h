//
//  LeftMenuView.h
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CommonChildView.h"


@protocol LeftMenuDelegate

// define protocol functions that can be used in any class using this delegate
-(void)selectMenuAtIndex:(NSIndexPath*)indexPath;
-(void)touchCloseLeftMenu;


@end

@interface LeftMenuView : CommonChildView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *Tbl_LeftMenu;

@end
