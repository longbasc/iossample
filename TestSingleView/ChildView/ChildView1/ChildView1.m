//
//  ChildView1.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ChildView1.h"
#import "ContainerViewController.h"
#import "MyalertView.h"

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
    
     [self.Ckb_Test init];
    //bool isCheck = self.Ckb_Test.isChecked;
    
     [self.Ckb_Test2 init];
    [self.Ckb_Test2 setCheck:true];
    
}

- (IBAction)showAlertView:(id)sender {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyAlertView" owner:self options:nil];
    MyAlertView* alert = [nib objectAtIndex:0];
    alert.delegate = self;
    [alert setDefaultValue];
    
    alert.tag = 100;
    [self addSubview:alert];
    
   
    
   
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
