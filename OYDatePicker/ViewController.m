//
//  ViewController.m
//  lunarCompute
//
//  Created by lanou on 16/7/7.
//  Copyright © 2016年 ohyeah. All rights reserved.
//

#import "ViewController.h"
//#import "OYDateHelperGeneric.h"

#import "OYCalendarData.h"

#import "OYBirthdayPicker.h"

@interface ViewController ()
@property (strong,nonatomic)OYBirthdayPicker *birthdayPicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.birthdayPicker = [[OYBirthdayPicker alloc]init];
    __weak typeof(self) weakSelf =  self;
    _birthdayPicker.completionBlock = ^(BOOL result){
        if (result == YES) {
            NSLog(@"%ld  %ld %ld",weakSelf.birthdayPicker.year,weakSelf.birthdayPicker.month,weakSelf.birthdayPicker.day);
        }
    };
    
    _birthdayPicker.year = 2018;
    _birthdayPicker.month = 11;
    _birthdayPicker.day = 16;
    _birthdayPicker.isLunar = YES;
    _birthdayPicker.isYearIgnored = NO;
    _birthdayPicker.endDateMode = OYEndDateModeToday;
    
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showButton.frame = CGRectMake(100, 480, 60, 30);
    [self.view addSubview:showButton];
    [showButton setTitle:@"show" forState:UIControlStateNormal];
    [showButton addTarget:_birthdayPicker action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_birthdayPicker];
    
    UIButton *b = [UIButton buttonWithType:UIButtonTypeSystem];
    b.frame = CGRectMake(100, 280, 90, 30);
    [self.view addSubview:b];
    [b setTitle:@"CHANGE" forState:UIControlStateNormal];
    [b addTarget:self action:@selector(CHANGE) forControlEvents:UIControlEventTouchUpInside];

    
  

}

-(void)CHANGE{
     _birthdayPicker.endDateMode = OYEndDateModeToday;
    _birthdayPicker.year = 2015;
    _birthdayPicker.month = 10;
    _birthdayPicker.day = 18;

}


@end
