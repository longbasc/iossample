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
    self.myContentViews = [[NSMutableArray alloc] init];
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
    [self.myContentViews addObject:av];
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
-(bool) popChildViewToIndex: (int)index{
    
    //self.containerScrollView
    
    NSArray*  viewArr =  self.myContentViews;
    if(index==-1){
        if([viewArr count]>0){
            UIView* av = viewArr[[viewArr count]-1];
            
            [av setFrame:CGRectMake( 0 , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
            
            [UIView beginAnimations:@"animateChildView" context:nil];
            [UIView setAnimationDuration:0.4];
            
            [av setFrame:CGRectMake( self.containerScrollView.frame.size.width , 0, self.containerScrollView.frame.size.width  , self.containerScrollView.frame.size.height  )]; //notice this is OFF screen!
            //notice this is ON screen!
             [UIView commitAnimations];
            
            [av removeFromSuperview];
            [self.myContentViews removeObject:av];
            return true;
        }
    }
    else{
        if(index<viewArr.count){
            for(long i=viewArr.count-1;i>=0;i--){
                if(i<=index) break;
                
                UIView* av = viewArr[i];
                [av removeFromSuperview];
                [self.myContentViews removeObject:av];
                
                
            }
        }
    }
    
    return false;
}

//==========================
- (IBAction)touchUpBtBack:(id)sender {
    [self popChildViewToIndex:-1];
    
}


- (IBAction)touchUpBtLeftMenu:(id)sender {
    
    CommonChildView *av;
    
    if (av == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LeftMenuView" owner:self options:nil];
        av = [nib objectAtIndex:0];
        //av.delegate = self;
        //av.Txt_Content.text = @"My View 1";
        
    }
    
    
    av.delegate = self;
    [self.view addSubview:av];
    [av setDefaultValue];
    //av.userInteractionEnabled = true;
    
    [av setFrame:CGRectMake( -self.view.frame.size.width , 20, self.view.frame.size.width  -100 , self.view.frame.size.height  )]; //notice this is OFF screen!
    
    [UIView beginAnimations:@"animateChildView" context:nil];
    [UIView setAnimationDuration:0.4];
    
    [av setFrame:CGRectMake( 0 , 20, self.view.frame.size.width - 100 , self.view.frame.size.height  )]; //notice this is OFF screen!
    //notice this is ON screen!
    
    
    [UIView commitAnimations];

    
}



@end