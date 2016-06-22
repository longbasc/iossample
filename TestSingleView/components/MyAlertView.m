//
//  MyAlertView.m
//  TestSingleView
//
//  Created by Lisa on 6/22/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "MyAlertView.h"
#import "CommonChildView.h"
#import "ContainerViewController.h"

@implementation MyAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)touchUpOK:(id)sender {
    //[self.delegate onTouchMyAlertViewOK];
    
    //CommonChildView* pView = self.delegate;
   // [self setInteracts: ((CommonViewController*) pView.delegate).view enabled:true] ;
    
    CommonChildView* pView = self.delegate;
    
    for(UIView * subView in pView.subviews ) // here write Name of you ScrollView.
    {
        [subView setUserInteractionEnabled:true];
    }
    
    [((ContainerViewController*) pView.delegate).HeaderView setUserInteractionEnabled:true];
    [((ContainerViewController*) pView.delegate).FooterView setUserInteractionEnabled:true];
    
    

    
    
    
    [self removeFromSuperview];
    
}
- (IBAction)touchUpCancel:(id)sender {
    //[self.delegate onTouchMyAlertViewCancel];
    
    
    CommonChildView* pView = self.delegate;
    
    for(UIView * subView in pView.subviews ) // here write Name of you ScrollView.
    {
        [subView setUserInteractionEnabled:true];
    }
    
    [((ContainerViewController*) pView.delegate).HeaderView setUserInteractionEnabled:true];
    [((ContainerViewController*) pView.delegate).FooterView setUserInteractionEnabled:true];
    
    
    
    [self removeFromSuperview];
    
}

-(id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    UIColor *borderColor=[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1.0];
    
    
    //[self setBackgroundColor:[UIColor whiteColor]];
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
       return self;
}

- (void) setDefaultValue{
    
     CommonChildView* pView = self.delegate;
    [self setFrame:CGRectMake( (pView.frame.size.width - 300)/2 , (pView.frame.size.height - 200)/2,  300  ,  200 )]; //notice this is OFF screen!

    
   
    
    for(UIView * subView in pView.subviews ) // here write Name of you ScrollView.
    {
        [subView setUserInteractionEnabled:false];
    }
    
    [((ContainerViewController*) pView.delegate).HeaderView setUserInteractionEnabled:false];
    [((ContainerViewController*) pView.delegate).FooterView setUserInteractionEnabled:false];
    
   
    
}



@end
