//
//  OYCalendarData.m
//  lunarCompute
//
//  Created by ohyeah on 17/8/11.
//  Copyright © 2017年 ohyeah. All rights reserved.
//

#import "OYCalendarData.h"


#define  OYTotalYears 199
//农历起始年份
#define OYBaseYear 1901

//基础数据记录从农历起始年份的正月初一的信息，对应该农历日期的公历日期为公历起始日期
//使用公历来累计天数的时候，需要注意，公历起始年份当年的天数需要在365（或366）的基础上，减去当年元旦到公历起始日期之间的天数，
//即NormalBaseSum
#define NormalBaseSum -49//公历从1901年2月19日开始算起，计算天数的时候需要减去2月19日之前的天数，共31+18=49天


//农历1901年到2099年的日期基础数据
//农历起始日期  1901年正月初一
//公历起始日期  1901年2月19日
UInt32 yearData[OYTotalYears]={
    0x04AE53,0x0A5748,0x5526BD,0x0D2650,0x0D9544,0x46AAB9,0x056A4D,0x09AD42,0x24AEB6,0x04AE4A,/*1901-1910*/
    0x6A4DBE,0x0A4D52,0x0D2546,0x5D52BA,0x0B544E,0x0D6A43,0x296D37,0x095B4B,0x749BC1,0x049754,/*1911-1920*/
    0x0A4B48,0x5B25BC,0x06A550,0x06D445,0x4ADAB8,0x02B64D,0x095742,0x2497B7,0x04974A,0x664B3E,/*1921-1930*/
    0x0D4A51,0x0EA546,0x56D4BA,0x05AD4E,0x02B644,0x393738,0x092E4B,0x7C96BF,0x0C9553,0x0D4A48,/*1931-1940*/
    0x6DA53B,0x0B554F,0x056A45,0x4AADB9,0x025D4D,0x092D42,0x2C95B6,0x0A954A,0x7B4ABD,0x06CA51,/*1941-1950*/
    0x0B5546,0x555ABB,0x04DA4E,0x0A5B43,0x352BB8,0x052B4C,0x8A953F,0x0E9552,0x06AA48,0x6AD53C,/*1951-1960*/
    0x0AB54F,0x04B645,0x4A5739,0x0A574D,0x052642,0x3E9335,0x0D9549,0x75AABE,0x056A51,0x096D46,/*1961-1970*/
    0x54AEBB,0x04AD4F,0x0A4D43,0x4D26B7,0x0D254B,0x8D52BF,0x0B5452,0x0B6A47,0x696D3C,0x095B50,/*1971-1980*/
    0x049B45,0x4A4BB9,0x0A4B4D,0xAB25C2,0x06A554,0x06D449,0x6ADA3D,0x0AB651,0x093746,0x5497BB,/*1981-1990*/
    0x04974F,0x064B44,0x36A537,0x0EA54A,0x86B2BF,0x05AC53,0x0AB647,0x5936BC,0x092E50,0x0C9645,/*1991-2000*/
    0x4D4AB8,0x0D4A4C,0x0DA541,0x25AAB6,0x056A49,0x7AADBD,0x025D52,0x092D47,0x5C95BA,0x0A954E,/*2001-2010*/
    0x0B4A43,0x4B5537,0x0AD54A,0x955ABF,0x04BA53,0x0A5B48,0x652BBC,0x052B50,0x0A9345,0x474AB9,/*2011-2020*/
    0x06AA4C,0x0AD541,0x24DAB6,0x04B64A,0x69573D,0x0A4E51,0x0D2646,0x5E933A,0x0D534D,0x05AA43,/*2021-2030*/
    0x36B537,0x096D4B,0xB4AEBF,0x04AD53,0x0A4D48,0x6D25BC,0x0D254F,0x0D5244,0x5DAA38,0x0B5A4C,/*2031-2040*/
    0x056D41,0x24ADB6,0x049B4A,0x7A4BBE,0x0A4B51,0x0AA546,0x5B52BA,0x06D24E,0x0ADA42,0x355B37,/*2041-2050*/
    0x09374B,0x8497C1,0x049753,0x064B48,0x66A53C,0x0EA54F,0x06B244,0x4AB638,0x0AAE4C,0x092E42,/*2051-2060*/
    0x3C9735,0x0C9649,0x7D4ABD,0x0D4A51,0x0DA545,0x55AABA,0x056A4E,0x0A6D43,0x452EB7,0x052D4B,/*2061-2070*/
    0x8A95BF,0x0A9553,0x0B4A47,0x6B553B,0x0AD54F,0x055A45,0x4A5D38,0x0A5B4C,0x052B42,0x3A93B6,/*2071-2080*/
    0x069349,0x7729BD,0x06AA51,0x0AD546,0x54DABA,0x04B64E,0x0A5743,0x452738,0x0D264A,0x8E933E,/*2081-2090*/
    0x0D5252,0x0DAA47,0x66B53B,0x056D4F,0x04AE45,0x4A4EB9,0x0A4D4C,0x0D1541,0x2D92B5          /*2091-2099*/
};


unsigned char _runYueOfEveryYear[OYTotalYears];
unsigned char _dayInEveryMonthInEveryYear[OYTotalYears][13];

/*
 * OYDate的构造方法
 */
OYDate OYDateMake(int year,int month,int day,bool isLunar){
    OYDate date = {year,month,day,isLunar};
    return date;
}


@implementation OYCalendarData


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

-(void)initData{

    //提取每年的闰月
    for (int i=0; i<OYTotalYears; i++) {
        _runYueOfEveryYear[i]=yearData[i]>>20;
        //        NSLog(@"%d",_runYueOfEveryYear[i]);
    }
    
    //提取每年每月的是否为大月（30天）
    for (int y=0; y<OYTotalYears; y++) {
        int data=yearData[y]>>7;
        for (int m=12; m>=0; m--) {
            if (data==(data>>1)<<1) {
                _dayInEveryMonthInEveryYear[y][m]=0;
            }else{
                _dayInEveryMonthInEveryYear[y][m]=1;
            }
            data=data>>1;
        }
    }

}


-(NSArray *)lunarMonthStringsOfYear:(NSInteger)year{
    
    NSArray *standaloneMonthString = [OYCalendarData standaloneMonthStringsOfLunarYear];
    int leapMonth = _runYueOfEveryYear[year-OYBaseYear];
    
    if (leapMonth != 0) {
        //有闰月 加入闰月
        NSMutableArray * monthString = [NSMutableArray new];
        NSArray *firstPart = [standaloneMonthString subarrayWithRange:NSMakeRange(0, leapMonth)];
        NSArray *middlePart = @[[@"闰" stringByAppendingString:[firstPart lastObject]] ];
        NSArray *lastPart = [standaloneMonthString subarrayWithRange:NSMakeRange(leapMonth,12-leapMonth)];
        [monthString addObjectsFromArray:firstPart];
        [monthString addObjectsFromArray:middlePart];
        [monthString addObjectsFromArray:lastPart];
        
        
        return [monthString copy];
    
    }else{
        //没有闰月 直接返回常规一到十二月
        return  standaloneMonthString;
    }

}

-(NSArray *)lunarDayStringsOfMonth:(NSInteger)month inYear:(NSInteger)year{
    
    NSArray * standaloneDayStrings = [OYCalendarData standaloneDayStringsOfLunarMonth];

    if (_dayInEveryMonthInEveryYear[year-OYBaseYear][month-1] > 0) {
        return standaloneDayStrings;
    }else{
        return [standaloneDayStrings subarrayWithRange:NSMakeRange(0, 29)];
    }

}



+(NSArray *)standaloneDayStringsOfLunarMonth{

    return @[@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",
                @"初七",@"初八",@"初九",@"初十",@"十一",@"十二",
                @"十三",@"十四",@"十五",@"十六",@"十七",@"十八",
                @"十九",@"二十",@"廿一",@"廿二",@"廿三",@"廿四",
                @"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十"];
}

+(NSArray *)standaloneMonthStringsOfLunarYear{
    return @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
}

+(BOOL)isLeapYear:(NSInteger)year{
    if (year%100==0&&year%400==0) {
        return true;
    }else if(year%100!=0&&year%4==0){
        return true;
    }else{
        return false;
    }
}


+(NSArray *)numberOfDaysInEveryMonthOfYear:(NSInteger)year{
   
    if ([OYCalendarData isLeapYear:year]) {
        return @[@(31),@(29),@(31),@(30),@(31),@(30),@(31),@(31),@(30),@(31),@(30),@(31)];
    }else{
        return @[@(31),@(28),@(31),@(30),@(31),@(30),@(31),@(31),@(30),@(31),@(30),@(31)];
    }

}

+(NSArray *)standaloneNumberOfDaysInEveryMonth{
    return @[@(31),@(29),@(31),@(30),@(31),@(30),@(31),@(31),@(30),@(31),@(30),@(31)];
}


+(OYDate)todayNormal{
    NSCalendar *normalCalendar=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    int yearToday=(int)[normalCalendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    int monthToday=(int)[normalCalendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    int dayToday=(int)[normalCalendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    return OYDateMake(yearToday, monthToday, dayToday, false);
}
-(OYDate)todayNormal{
    return [OYCalendarData todayNormal];
}

-(OYDate)todayLunar{
    return [self getLunarDateOfNormalDate:[OYCalendarData todayNormal]];
}


-(OYDate)todayTraditional{
    //先获取今天的农历日期
    NSCalendar *ChineseCalendar=[NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
    NSDate *now=[NSDate date];
    //获取今天的农历月份
//    int monthToday=(int)[ChineseCalendar component:NSCalendarUnitMonth fromDate:now];
    //获取今天的农历日
//    int dayToday=(int)[ChineseCalendar component:NSCalendarUnitDay fromDate:now];
    //获取今天的年份（从Calendar取到的是60为周期的农历年份，传统农历的年份周期为60一轮回）
    int yearToday=(int)[ChineseCalendar component:NSCalendarUnitYear fromDate:now];
    
    OYDate todayLunar = [self getLunarDateOfNormalDate:[OYCalendarData todayNormal]];

    return OYDateMake(yearToday, todayLunar.month, todayLunar.day, true);
}


#pragma mark - 私有方法

/**
 *  将公历日期转换成农历（阴阳历）日期
 *
 *  @param normalDate 公历日期
 *  @return 农历日期
 *  注意：month的值表示当年的第几个月份，可能和字面上的月份不同 也就是2017年闰六月初五对应OYDateMake(2017,7,5)
 */


-(OYDate)getLunarDateOfNormalDate:(OYDate)date{
    int sum=0;
    int totalDays = numberOfDaysFromNormalBaseDateToNormalDate(date);
    
    int yearLunar=date.year-1;//假设农历年比公历年小一年
    OYDate normalDateOfNewYearsDay = OYChineseNewYearOfLunarYear(date.year);
    //如果date在date.year年的春节及之后，则date对应的农历年等于date.year
    if(date.month*100+date.day >= normalDateOfNewYearsDay.month*100+normalDateOfNewYearsDay.day){
        yearLunar = date.year;
    }
    for (int y=OYBaseYear-OYBaseYear;y<yearLunar-OYBaseYear ; y++) {//把之前每年的天数加起来，从起始年加到yearLunar-1年除夕
        int totalMonth=0;
        if(_runYueOfEveryYear[y] > 0){//如果是有闰月就加13个月
            totalMonth=13;
        }else{
            totalMonth=12;//如果没闰月就加12个月
        }
        for (int m=0; m<totalMonth; m++) {
            sum+=(29+_dayInEveryMonthInEveryYear[y][m]);
        }
    }
    int monthLunar = 1;
    int dayLunar;
    int LeapMonth = _runYueOfEveryYear[yearLunar-OYBaseYear];
    int MaxMonth = LeapMonth > 0 ?13:12;
    for (int m=0; m<MaxMonth; m++) {
        int numberOfDaysInThisMonth = 29 + _dayInEveryMonthInEveryYear[yearLunar-OYBaseYear][m];
        
        if(sum + numberOfDaysInThisMonth >= totalDays){
            
            for (int d = 1; d <= numberOfDaysInThisMonth; d++ ) {
                if (sum + d == totalDays) {
                    dayLunar = d;
                    NSLog(@"Self %d/%d/%d L--|--N %d/%d/%d",date.year,date.month,date.day,yearLunar, monthLunar, dayLunar);
                    return OYDateMake(yearLunar, monthLunar, dayLunar, true);
                }
            }
        }else{
            sum += numberOfDaysInThisMonth;
            monthLunar += 1;
        }
    }
    
    
    return OYDateMake(0, 0, 0, false);
    
}




/**
 *  获取某年的春节对应的公历日期
 *  @param year 农历年年份
 *
 */

OYDate OYChineseNewYearOfLunarYear(int year){
    UInt32 data = yearData[year-OYBaseYear];
    unsigned char month = (data<<25)>>30;
    unsigned char day = data & 0x0000001F;
    NSLog(@"%d年春节在公历%d月%d日",year,month,day);
    return OYDateMake(year, month, day, false);
}


/**
 *  判断公历年是否为闰年
 *  @param year 公历年年份
 *  @return 是否为公历年
 */
bool isLeapYear(int year){
    if (year%100==0&&year%400==0) {
        return true;
    }else if(year%100!=0&&year%4==0){
        return true;
    }else{
        return false;
    }
}


/**
 *  计算公历日期距离公历起始日期的天数
 *  @param date  公历日期
 *  @return 总天数
 */
int numberOfDaysFromNormalBaseDateToNormalDate(OYDate date){
    int year = date.year;
    int month = date.month;
    int day = date.day;
    int sum=NormalBaseSum;//公历从起始日期开始算起，减去1月1日到起始日期之间的天数，共31+16=47天
    for(int y=OYBaseYear;y<year;y++){//把1950年到year-1年的天数加起来
        if (isLeapYear(y)) {
            sum+=366;//闰年366天
        }else{
            sum+=365;//平年365天
        }
    }
    int numberOfDaysInCommonYear[12]={31,28,31,30,31,30,31,31,30,31,30,31};//把1到month-1月的天数加上
    for (int m=0; m<month-1; m++) {
        sum+=numberOfDaysInCommonYear[m];
    }
    if ((month==2&&day==29)||month>2) {//如果日期在2月29日及以后，需要考虑闰月的问题
        sum+=isLeapYear(year);//如果是闰年就加一天
    }
    sum+=day;
    if (sum<1) {
        sum=1;
    }
    return sum;
}



@end
