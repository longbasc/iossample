//
//  ContainerViewController.m
//  TestSingleView
//
//  Created by admin on 6/14/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ContainerViewController.h"
#import "CommonChildView.h"
#import "ChildView1.h"
#import "ChildView2.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)touchUpBtHeader:(id)sender {
    [self addChildViewWithNibName:@"ChildView1"];
   
    
}




- (IBAction)touchUpBtFooter:(id)sender {
    
    [self addChildViewWithNibName:@"ChildView2"];
}


//=======================================================

-(void) addChildViewWithNibName:(NSString*) nibName{
    
    CommonChildView *av;
    
    if (av == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        av = [nib objectAtIndex:0];
        //av.delegate = self;
        //av.Txt_Content.text = @"My View 1";
        
    }
    
    
    av.delegate = self;
    [self.containerScrollView addSubview:av];
    [av setDefaultValue];
    //av.userInteractionEnabled = true;
    
    [av setFrame:CGRectMake( self.containerScrollView.frame.size.width , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
    
    [UIView beginAnimations:@"animateChildView" context:nil];
    [UIView setAnimationDuration:0.4];
    
    [av setFrame:CGRectMake( 0 , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
    //notice this is ON screen!
    
    
    [UIView commitAnimations];

}

//==========================
-(void) popChildView{
    
    //self.containerScrollView
}


@end
