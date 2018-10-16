//
//  OYCalendarData.h
//  lunarCompute
//
//  Created by ohyeah on 17/8/11.
//  Copyright © 2017年 ohyeah. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef struct date{
    int year;
    int month;
    int day;
    bool isLunar;
} OYDate;


//OYDate构造方法
OYDate OYDateMake(int year,int month,int day,bool isLunar);

/*
 * 年份支持范围 1901-2099 年
 *
 *
 */
#define OYFirstYear 1901

@interface OYCalendarData : UIView

/*
 * 以下4个方法针对农历
 * 返回农历日历上的月份或日期的字符串数组
 */



//返回指定农历年份的字符串形式，如：二〇〇二年
-(NSString *)lunarYearStringOfYear:(NSInteger)year;



/**
 返回指定年份的  农历月份字符串，如@[@"正月",@"二月",@"三月",@"闰三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"]
 */
-(NSArray *)lunarMonthStringsOfYear:(NSInteger)year;
/**
 * 返回指定月份的 日期字符串，如
 * @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",
 *   @"初七",@"初八",@"初九",@"初十",@"十一",@"十二",
 *   @"十三",@"十四",@"十五",@"十六",@"十七",@"十八",
 *   @"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",
 *   @"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"]
 * 农历月份分大小月 大月30日 小月29日  年和月确定后才能确定是大月还是小月
 * @param month 这里的月份表示一年中的第几个月，而不是字面上的月份
 * 当某年没有闰月的时候month传入1-12表示第一到第十二月 
 * 当某年有闰月的时候month 传入1-13表示第一到第十三月
 */
-(NSArray *)lunarDayStringsOfMonth:(NSInteger)month inYear:(NSInteger)year;

/**
 返回与年份、月份无关的日字符串 即初一到三十
*/
 +(NSArray *)standaloneDayStringsOfLunarMonth;
/**
 返回与年份无关的月份字符串 即正月到腊月
 */
+(NSArray *)standaloneMonthStringsOfLunarYear;






/*
 * 以下3个方法 针对公历日历
 */

//某年是否为闰年   这里的年份指公历年份，公历才有闰年的说法，农历只有闰月的说法
+(BOOL)isLeapYear:(NSInteger)year;

//返回某年 公历每月的天数（闰年的二月29天，平年的二月28天）
+(NSArray *)numberOfDaysInEveryMonthOfYear:(NSInteger)year;

//返回与年份无关的 公历每月的天数 （二月29天）
+(NSArray *)standaloneNumberOfDaysInEveryMonth;






/*
 * 以下3个方法用于获取今日的日期
 */

//今日的公历日期
+(OYDate)todayNormal;
-(OYDate)todayNormal;
//今日的农历日期（阴阳历日期）
-(OYDate)todayLunar;
//今日的传统农历日期（年份周期为60年）
-(OYDate)todayTraditional;
@end
