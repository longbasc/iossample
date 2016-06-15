//
//  LeftMenuView.h
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CommonChildView.h"

@interface LeftMenuView : CommonChildView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *Tbl_LeftMenu;

@end
