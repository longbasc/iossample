//
//  CommonViewController.m
//  
//
//  Created by admin on 6/10/16.
//
//

#import "CommonViewController.h"

@interface CommonViewController ()
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

//==========================================================================
- (void)showWaitingIcon{
    
    self.view.userInteractionEnabled = false;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    
    
    if(self.waitingView== nil)
    {
        self.waitingView = [[UIView alloc] init];
        self.waitingView.frame = CGRectMake((width-60)/2, (height-40)/2, 60, 40);
        [self.waitingView setBackgroundColor:[UIColor blackColor]];
        self.waitingView.layer.cornerRadius = 5;
        self.waitingView.layer.masksToBounds = YES;
        
        
    }
    
    if(![self.waitingView isDescendantOfView:self.view]){
        [self.view addSubview:self.waitingView];
        [self.view bringSubviewToFront:self.waitingView];
    }
    
    
    _spinner.center = CGPointMake(width/2, height/2);
    _spinner.tag = 12;
    [self.view addSubview:_spinner];
    [self.view bringSubviewToFront:_spinner];
    [_spinner startAnimating];
    
}


//==========================================================================
- (void)hideWaitingIcon{
    
    //AppManager *appManager =  [AppManager sharedInstance];
    //UIActivityIndicatorView *_spinner = appManager.spinner;
    
    [_spinner stopAnimating];
    self.view.userInteractionEnabled = true;
    
    if ([self.waitingView isDescendantOfView:self.view])
        [self.waitingView removeFromSuperview];
    
    //[_spinner removeFromSuperview];
    
}

//==========================================================================
- (void)doHTPPostSuccessWithMarkData:(id)markData Data:(NSData*)data{
    [self hideWaitingIcon];
}

//==========================================================================
- (void)doHTPPostFailWithMarkData:(id)markData Error:(NSError*)error{
    [self hideWaitingIcon];
}



@end
