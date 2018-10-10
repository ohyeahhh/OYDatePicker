//
//  OYDatePicker.h
//  Created by ohyeah on 17/8/8.
//  Copyright © 2017年 ohyeah. All rights reserved.
//

#import <UIKit/UIKit.h>




typedef void(^CompletionBlock)(BOOL result);


/**
  picker 的截止日期类型

 - OYEndDateModeToday: 可选日期为1901年到“今天”
 - OYEndDateModeDefault: 可选日期为1901年到2099年最后一天
 */
typedef NS_ENUM(NSInteger,OYEndDateMode){
    OYEndDateModeToday = 1,//可选日期为1901年到“今天”
    OYEndDateModeDefault = 2//可选日期为1901年到2099年最后一天
};



@interface OYBirthdayPicker : UIView <UIPickerViewDataSource,UIPickerViewDelegate>


/**
 点击确定、取消、半透明背景后的回调方法
 当用户点击确定时，completionBlock将会获得参数 YES，此时可以通过以下的 year、month、day 等属性获得当前选中日期；其他情况下，completionBlock都会获得参数 NO。
 */
@property (copy,nonatomic)CompletionBlock completionBlock;


//以下方法用于获取和设置 picker 的选中日期，以及 picker 的状态

/**
 通过该属性来读取、更新 picker 的选中年份
 */
@property (assign,nonatomic)NSInteger year;
/**
 通过该属性来读取、更新 picker 的选中月份
 */
@property (assign,nonatomic)NSInteger month;
/**
 通过该属性来读取、更新 picker 的选中日
 */
@property (assign,nonatomic)NSInteger day;
/**
 通过该属性来读取、更新 picker 的日期类型
 为 YES 时表示显示农历日期，为 NO 时表示显示公历日期
 */
@property (assign,nonatomic)BOOL isLunar;
/**
 通过该属性来读取、更新 picker 的日期是否忽略年份
 为 YES 时表示忽略年份，picker 中只显示月、日；为 NO 时表示不忽略年份，picker 中只显示年、月、日
 */
@property (assign,nonatomic)BOOL isYearIgnored;
/**
 通过该属性来读取、更新 picker 的截止日期类型
 见枚举值OYEndDateMode
 */
@property (assign,nonatomic)OYEndDateMode endDateMode;



//以下属性用于提供与picker当前状态相关的中文描述

/**
 当前选中年份的中文描述
 */
@property (assign,nonatomic,readonly)NSString *yearString;
/**
 当前选中月份的中文描述
 */
@property (assign,nonatomic,readonly)NSString *monthString;
/**
 当前选中日的中文描述
 */
@property (assign,nonatomic,readonly)NSString *dayString;
/**
 返回当前日期类型的中文描述,“公历”或“农历”
 */
@property (assign,nonatomic,readonly)NSString *isLunarString;




/**
 调用该方法使picker弹出
 没有隐藏 picker 的方法，picker 会在点击取消和半透明背景时自动消失
 */
-(void)show;

@end
