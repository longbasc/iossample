//
//  ChildView1.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ChildView1.h"
#import "ContainerViewController.h"

@implementation ChildView1

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) setDefaultValue{
    [super setDefaultValue ];
    
    self.Txt_Content.text = @"My View 1";
     //self.Txt_Text1.keyboardType = UIKeyboardTypeNumberPad;
     //[self.Txt_Text1 setAutocorrectionType:UITextAutocorrectionTypeNo];
    

}





//================================================================================================
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    /*
    if(textField != self.Txt_Text1)
        return YES;
    */
    
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
     
}




@end
