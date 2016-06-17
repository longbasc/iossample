//
//  ChildView2.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ChildView2.h"

@implementation ChildView2

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setDefaultValue{
    
      [self.Bt_Content setTitle:@"My View 2" forState:UIControlStateNormal ];
    
}

- (IBAction)touchUpBtContent:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(wantCloseChildView)]) {
        [self.delegate wantCloseChildView];
        
    }
}

@end
