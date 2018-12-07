//
//  ViewController.m
//  lunarCompute
//
//  Created by lanou on 16/7/7.
//  Copyright © 2016年 ohyeah. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

#import "OYCalendarData.h"
#import "OYBirthdayPicker.h"

@interface ViewController ()
@property (strong,nonatomic) OYBirthdayPicker *birthdayPicker;
@property (strong,nonatomic) UILabel *selectedDateLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日期选择器 demo";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化生日选择控件
    self.birthdayPicker = [[OYBirthdayPicker alloc]init];
    __weak typeof(self) weakSelf =  self;
    _birthdayPicker.completionBlock = ^(BOOL result){
        if (result == YES) {
            [weakSelf updateDateLabel];
        }
    };
    _birthdayPicker.year = 2018;
    _birthdayPicker.month = 11;
    _birthdayPicker.day = 16;
    _birthdayPicker.isLunar = YES;
    _birthdayPicker.isYearIgnored = NO;
    _birthdayPicker.endDateMode = OYEndDateModeToday;
    [[[[UIApplication sharedApplication] delegate] window]  addSubview:_birthdayPicker];
    
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    
    UILabel *function1 = [UILabel new];
    function1.text = @"功能1：日期选择";
    [self.view addSubview:function1];
    [function1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(14);
        make.top.equalTo(self.view).mas_offset(navigationBarHeight+50);
    }];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [showButton setTitle:@"点击显示日期选择器" forState:UIControlStateNormal];
    [showButton addTarget:_birthdayPicker action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showButton];
    [showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(14);
        make.top.equalTo(function1.mas_bottom).mas_offset(20);
    }];
    
    UILabel *selectedDateLabel = [UILabel new];
    selectedDateLabel.text= @"未选择";
    selectedDateLabel.textColor = [UIColor whiteColor];
    selectedDateLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:selectedDateLabel];
    [selectedDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(function1);
        make.top.equalTo(showButton.mas_bottom).mas_offset(20);
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-28);
        make.height.mas_equalTo(30);
    }];
    self.selectedDateLabel = selectedDateLabel;
   

    UILabel *function2 = [UILabel new];
    function2.text = @"功能2：跳到指定日期";
    [self.view addSubview:function2];
    [function2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(14);
        make.top.equalTo(selectedDateLabel.mas_bottom).mas_offset(20);
    }];
    
    UIButton *setDateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [setDateButton setTitle:@"点击切换选中日期至:农历二〇一七年闰六月十九" forState:UIControlStateNormal];
    [setDateButton addTarget:self action:@selector(setDate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setDateButton];
    [setDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).mas_offset(14);
        make.top.equalTo(function2.mas_bottom).mas_offset(20);
    }];
    
    

}

-(void)setDate{
     _birthdayPicker.endDateMode = OYEndDateModeToday;
    _birthdayPicker.year = 2017;
    _birthdayPicker.month = 7;
    _birthdayPicker.day = 18;
    _birthdayPicker.isLunar = YES;
    [self updateDateLabel];
}

- (void)updateDateLabel{
    if(self.birthdayPicker.isLunar){
        if (self.birthdayPicker.isYearIgnored) {
            NSLog(@"农历 %ld月%ld日",(long)self.birthdayPicker.month,(long)self.birthdayPicker.day);
        }else{
            NSLog(@"农历 %ld年第%ld个月第%ld日",(long)self.birthdayPicker.year,(long)self.birthdayPicker.month,(long)self.birthdayPicker.day);
        }
    }else{
        if (self.birthdayPicker.isYearIgnored) {
            NSLog(@"公历 %ld/%ld",(long)self.birthdayPicker.month,(long)self.birthdayPicker.day);
        }else{
            NSLog(@"公历 %ld/%ld/%ld",(long)self.birthdayPicker.year,(long)self.birthdayPicker.month,(long)self.birthdayPicker.day);
        }
        
    }
    
    self.selectedDateLabel.text = [NSString stringWithFormat:@"%@ %@%@%@",self.birthdayPicker.isLunarString,self.birthdayPicker.isYearIgnored?@"":self.birthdayPicker.yearString,self.birthdayPicker.monthString,self.birthdayPicker.dayString];
}


@end
