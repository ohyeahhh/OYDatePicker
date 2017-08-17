//
//  OYBirthdayPicker.h
//  lunarCompute
//
//  Created by ohyeah on 17/8/8.
//  Copyright © 2017年 ohyeah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


typedef void(^CompletionBlock)(BOOL result);


//日历的截止日期
typedef NS_ENUM(NSInteger,OYEndDateMode){
    OYEndDateModeToday = 1,//可选日期为1901年到“今天”
    OYEndDateModeDefault = 2//可选日期为1901年到2099年最后一天
};



@interface OYBirthdayPicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

//点击确定、取消、半透明背景后的回调方法
@property (copy,nonatomic)CompletionBlock completionBlock;

//picker 的年月日
@property (assign,nonatomic)NSInteger year;
@property (assign,nonatomic)NSInteger month;
@property (assign,nonatomic)NSInteger day;


//类型
@property (assign,nonatomic)BOOL isLunar;
@property (assign,nonatomic)BOOL isYearIgnored;

//日历的截止日期
@property (assign,nonatomic)OYEndDateMode endDateMode;

-(void)show;

@end
