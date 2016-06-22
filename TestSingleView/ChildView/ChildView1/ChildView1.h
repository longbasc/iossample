//
//  ChildView1.h
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "CommonChildView.h"
#import "Checkbox.h"

@interface ChildView1 : CommonChildView

@property (weak, nonatomic) IBOutlet UILabel *Txt_Content;
@property (weak, nonatomic) IBOutlet UITextField *Txt_Text1;
@property (weak, nonatomic) IBOutlet UITextField *Txt_Text2;
@property (weak, nonatomic) IBOutlet Checkbox *Ckb_Test;

@end
