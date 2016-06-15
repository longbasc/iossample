//
//  LeftMenuView.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "LeftMenuView.h"

@implementation LeftMenuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


NSMutableArray* _leftMenuArr;
- (IBAction)touchUpBtCloseLeftMenu:(id)sender {
    [self removeFromSuperview];
}


- (void) setDefaultValue{
    
    _leftMenuArr = [[NSMutableArray alloc] init];
    [_leftMenuArr addObject:@"Menu 1"];
    [_leftMenuArr addObject:@"Menu 2"];
    [_leftMenuArr addObject:@"Menu 3"];
    
    self.Tbl_LeftMenu.delegate = self;
    self.Tbl_LeftMenu.dataSource = self;
    
    [self.Tbl_LeftMenu reloadData];
    
}


//==========================================================================
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeftMenuViewItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

     cell.textLabel.text = _leftMenuArr[indexPath.row];
    return cell;
}

//==============================================================================================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    long idx = indexPath.row;
    //int aaa = 0;
    
    [self removeFromSuperview];
    

    
}

//==========================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}


//==========================================================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 3;
    
    return 3;
    
}



@end
