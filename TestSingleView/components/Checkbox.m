//
//  Checkbox.m
//  TestSingleView
//
//  Created by admin on 6/22/16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "Checkbox.h"

@implementation Checkbox



- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self) {
        [self addTarget:self action:@selector(didTouchButton) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setCheck:false];
    return [super initWithFrame:frame];
}

-(instancetype)init{
    return [super init];
}



- (void)didTouchButton {
    // do whatever you need to do here
    [self setCheck:!self.isChecked];
    
}

- (void) setCheck:(BOOL)checked{
    
    _isChecked = checked;
    
    UIImage *btnImage;
    if(_isChecked){
        btnImage = [UIImage imageNamed:@"checkbox-on.png"];
    }else{
        btnImage = [UIImage imageNamed:@"checkbox-off.png"];
    }
    
    [self setImage:btnImage forState:UIControlStateNormal];

}


@end
