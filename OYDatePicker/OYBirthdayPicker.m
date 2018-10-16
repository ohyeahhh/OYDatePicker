//
//  OYBirthdayPicker.m
//  lunarCompute
//
//  Created by ohyeah on 17/8/8.
//  Copyright © 2017年 ohyeah. All rights reserved.
//

#import "OYBirthdayPicker.h"
#import "Masonry.h"
#import "OYCalendarData.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger,CalendarType){
    CalendarTypeLunar = 01,
    CalendarTypeNormal = 00,
    CalendarTypeLunarIgnoreYear = 11,
    CalendarTypeNormalIgnoreYear = 10
};


#define HEIGHT 300

#define normalCalendarSelectedImg @"normalC"
#define lunarCalendarSelectedImg @"lunarC"
#define normalCalendarDefaultImg @"normalN"
#define lunarCalendarDefaultImg @"lunarN"

#define yearIgnoredImg @"ignore"
#define yearDefultImg @"normal"


@interface OYBirthdayPicker ()

//控件
@property (strong,nonatomic)UIView *backgroundView;
@property (strong,nonatomic)UIView *containerView;
@property (strong,nonatomic)UIView *cancelGestureRecognizerView;
@property (strong,nonatomic)UIPickerView *innerPickView;
@property (strong,nonatomic)UIButton *confirmButton;
@property (strong,nonatomic)UIButton *cancelButton;
@property (strong,nonatomic)UIButton *calendarSwitcherLunar;
@property (strong,nonatomic)UIButton *calendarSwitcherNormal;
@property (strong,nonatomic)UIButton *yearIgnoreButton;
@property (assign,nonatomic)BOOL isShown;

//状态
@property (assign,nonatomic)NSInteger dayComponent;
@property (assign,nonatomic)NSInteger monthComponent;
@property (assign,nonatomic)CalendarType calendarType;
@property (assign,nonatomic)NSInteger endDateYear;
@property (assign,nonatomic)NSInteger endDateMonth;
@property (assign,nonatomic)NSInteger endDateDay;



//数据
@property (strong,nonatomic)NSArray *years;
@property (strong,nonatomic)NSArray *monthLunarStringArray;
@property (strong,nonatomic)NSArray *dayLunarStringArray;

@property (strong,nonatomic)NSArray *dayNormalNumberArray;
@property (strong,nonatomic)NSDictionary *calendarProperties;

//工具
@property (strong,nonatomic)OYCalendarData *data;





@end

@implementation OYBirthdayPicker
{
    OYDate todayNormal;
    OYDate todayLunar;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViews];
        [self initData];
        //endDateMode与年份信息相关，因此必须初始化
        self.endDateMode = OYEndDateModeDefault;
        self.isLunar = NO;
        self.isYearIgnored = NO;

    }
    return self;
}


-(void)initViews{
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, kScreenW, kScreenH);
    self.userInteractionEnabled = NO;
    
    //半透明背景
    UIView *backgroundView =[[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroundView];
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.backgroundView = backgroundView;
    
    
    //响应取消动作的view
    self.cancelGestureRecognizerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-HEIGHT)];
    [self addSubview:_cancelGestureRecognizerView];
    [_cancelGestureRecognizerView  addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(completionAction:)]];
    _cancelGestureRecognizerView.userInteractionEnabled = NO;
    
    //整个控件的容器
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH, kScreenW, HEIGHT)];
    [self addSubview:_containerView];
    
    //顶部菜单容器
    UIView *menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    menuView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self.containerView addSubview:menuView];
    //确定按钮
    self.confirmButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuView addSubview:_confirmButton];
    [_confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_confirmButton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_confirmButton sizeToFit];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(menuView.mas_right).mas_offset(-20);
        make.centerY.equalTo(menuView);
    }];
    [_confirmButton addTarget:self action:@selector(completionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //取消按钮
    self.cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [menuView addSubview:_cancelButton];
    [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [_cancelButton  setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_confirmButton sizeToFit];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(menuView.mas_left).mas_offset(20);
        make.centerY.equalTo(menuView);
    }];
    [_cancelButton addTarget:self action:@selector(completionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //忽略年份按钮
    self.yearIgnoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_yearIgnoreButton setTitle:@"忽略年份" forState:UIControlStateNormal];
    _yearIgnoreButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_yearIgnoreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_yearIgnoreButton addTarget:self action:@selector(ignoreYearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_yearIgnoreButton setImage:[UIImage imageNamed:yearDefultImg] forState:UIControlStateNormal];
    [menuView addSubview:_yearIgnoreButton];
     [_yearIgnoreButton sizeToFit];
    [_yearIgnoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cancelButton.mas_right).mas_offset(20);
        make.centerY.equalTo(menuView);
    }];
    
    
    //公历按钮
    self.calendarSwitcherNormal = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.calendarSwitcherNormal setImage:[UIImage imageNamed:@"normalC"] forState:UIControlStateNormal];
    [menuView addSubview:_calendarSwitcherNormal];
    [self.calendarSwitcherNormal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(_yearIgnoreButton.mas_right).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.centerY.equalTo(menuView);
    }];
    [self.calendarSwitcherNormal addTarget:self action:@selector(calendarSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarSwitcherNormal setImage:[UIImage imageNamed:normalCalendarDefaultImg] forState:UIControlStateNormal];
    [self.calendarSwitcherNormal setImage:[UIImage imageNamed:normalCalendarSelectedImg] forState:UIControlStateDisabled];

    //农历按钮
    self.calendarSwitcherLunar = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.calendarSwitcherLunar setImage:[UIImage imageNamed:@"lunarC"] forState:UIControlStateNormal];
    [menuView addSubview:_calendarSwitcherLunar];
    [self.calendarSwitcherLunar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_calendarSwitcherNormal.mas_right);
        make.size.mas_equalTo(CGSizeMake(60, 40));
        make.centerY.equalTo(menuView);
    }];
    [self.calendarSwitcherLunar addTarget:self action:@selector(calendarSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.calendarSwitcherLunar setImage:[UIImage imageNamed:lunarCalendarDefaultImg] forState:UIControlStateNormal];
    [self.calendarSwitcherLunar setImage:[UIImage imageNamed:lunarCalendarSelectedImg] forState:UIControlStateDisabled];

    
    
    
    //内置picker
    self.innerPickView=[[UIPickerView alloc]init];
    self.innerPickView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    [self.containerView addSubview:_innerPickView];
    [self.innerPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
        make.top.equalTo(menuView.mas_bottom);
    }];
    _innerPickView.delegate=self;
    _innerPickView.dataSource=self;
    _isShown = NO;

}


-(void)initData{
    _data = [OYCalendarData new];
    
    //这里获取的当天农历日期 是字面日期，在有闰月的时候可能会比实际月份少一个月
    todayLunar = [_data todayLunar];
    todayNormal = [_data todayNormal];
    
    _year = todayLunar.year;
    _month = todayLunar.month;
    _day = todayLunar.day;
    
}



#pragma mark - button actions

-(void)calendarSwitchAction:(UIButton *)button{

    if([button isEqual:_calendarSwitcherNormal]){

        self.isLunar = NO;
    }else{
        self.isLunar = YES;
    
    }
}


-(void)ignoreYearButtonAction{
    self.isYearIgnored = !self.isYearIgnored;
}


-(void)completionAction:(UIButton *)button{
    if (_isShown) {
        //下滑消失
        _cancelGestureRecognizerView.userInteractionEnabled = NO;
        self.userInteractionEnabled = NO;
        _isShown = NO;
        [UIView animateWithDuration:0.4 animations:^{
            self.containerView.transform = CGAffineTransformTranslate(self.transform,0,HEIGHT);
            self.backgroundView.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            if (_completionBlock != nil) {
                [button isEqual:self.confirmButton]?_completionBlock(YES):_completionBlock(NO);
            }
        }];
    }
}

-(void)show{
    if (!_isShown) {
        _isShown = YES;
        [self sychronizePickerStatusWithAnimation:YES];
        [UIView animateWithDuration:0.4 animations:^{
            self.containerView.transform = CGAffineTransformTranslate(self.transform,0, -1*HEIGHT);
            self.backgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        } completion:^(BOOL finished) {
            _cancelGestureRecognizerView.userInteractionEnabled = YES;
            self.userInteractionEnabled = YES;
           
        }];
    }
}



#pragma mark - getters

-(NSInteger)endDateDay{
    return _isLunar?todayLunar.day:todayNormal.day;
}

-(NSInteger)endDateMonth{
    return _isLunar?todayLunar.month:todayNormal.month;
}

-(NSInteger)endDateYear{
    if (_endDateMode == OYEndDateModeToday) {
        return _isLunar?todayLunar.year:todayNormal.year;
    }else{
        return 2099;
    }
}

-(NSString *)yearString{
    return _isLunar?[self.data lunarYearStringOfYear:_year]:[_years[_year - OYFirstYear] stringByAppendingString:@"年"];
}

-(NSString *)monthString{
    return _isLunar? _monthLunarStringArray[_month-1]:[NSString stringWithFormat:@"%ld月",(long)_month];
}

-(NSString *)dayString{
    return _isLunar? _dayLunarStringArray[_day-1]:[NSString stringWithFormat:@"%ld日",(long)_day];
}

-(NSString *)isLunarString{
    return _isLunar?@"农历":@"公历";
}

#pragma mark - setters

//以下setter都会导致picker更新（控件状态、数据源）



-(void)setEndDateMode:(OYEndDateMode)endDateMode{
    if (_endDateMode != endDateMode) {
        _endDateMode = endDateMode;
        [self updateYearData];
        [self updateComponentsAfterCalendarChanged];
    }
}


-(void)setIsLunar:(BOOL)isLunar{
    _isLunar = isLunar;
    self.calendarType = _isYearIgnored * 10 + _isLunar;
    if (_isLunar) {
        self.calendarSwitcherLunar.enabled = NO;
        self.calendarSwitcherNormal.enabled = YES;
    }else{
        self.calendarSwitcherLunar.enabled = YES;
        self.calendarSwitcherNormal.enabled = NO;
    }

}


-(void)setIsYearIgnored:(BOOL)isYearIgnored{
    _isYearIgnored = isYearIgnored;
    if (_isYearIgnored) {
        _monthComponent = 0;
        _dayComponent = 1;
        [_yearIgnoreButton setImage:[UIImage imageNamed:yearIgnoredImg] forState:UIControlStateNormal];
    }
    else{
        _monthComponent = 1;
        _dayComponent = 2;
        [_yearIgnoreButton setImage:[UIImage imageNamed:yearDefultImg] forState:UIControlStateNormal];
    }
    self.calendarType = _isYearIgnored * 10 + _isLunar;
}

-(void)setCalendarType:(enum CalendarType)calendarType{
    if(_calendarType != calendarType){
        _calendarType = calendarType;
        [self updateComponentsAfterCalendarChanged];
    }
}


-(void)setYear:(NSInteger)year{
    if (_year != year && year > OYFirstYear && year - OYFirstYear < self.years.count ) {
        _year = year;
        if (_innerPickView) {
            //刷新
            [self updateComponentsAfterSelectedYearChanged];
        }
    }
}

-(void)setMonth:(NSInteger)month{
    if (month < 1) {
        return;
    }
    NSInteger maxMonth = _isLunar?[self.monthLunarStringArray count]:[self.dayNormalNumberArray count];
    if(_month != month && month <= maxMonth){
        _month = month;
        if (_innerPickView) {
            //刷新
            [self updateDayComponentAfterSelectedMonthChaged];
        }
    }

}

-(void)setDay:(NSInteger)day{
    if (day < 1) {
        return;
    }
    NSInteger maxDay = _isLunar?[self.dayLunarStringArray count]:[self.dayNormalNumberArray[_month-1] integerValue];
    if (_day != day && day <= maxDay) {
        _day = day;
        if (_innerPickView) {
            //刷新
            [_innerPickView selectRow:_day-1 inComponent:_dayComponent animated:NO];
        }
    }
}



#pragma mark - dataSource update

/*
 * 更新picker数据源的正确顺序：
 * -> 1.更新picker数据源 (更新数组)
 * -> 2.更新选中状态相关变量 (更新_year,_month,_day)
 * -> 3.重新加载picker，使最新数据源生效 (reloadComponent:/reloadAllComponent)
 * -> 4.让picker同步选中状态 (selectRow:InComponent)
 */


-(void)updateComponentsAfterCalendarChanged{
    //1.更新picker数据源
    //2.更新选中状态相关变量
    switch (_calendarType) {
        case CalendarTypeLunarIgnoreYear:
            _monthLunarStringArray = [OYCalendarData standaloneMonthStringsOfLunarYear];
            _dayLunarStringArray = [OYCalendarData standaloneDayStringsOfLunarMonth];
            break;
        case CalendarTypeNormalIgnoreYear:
            _dayNormalNumberArray = [OYCalendarData standaloneNumberOfDaysInEveryMonth];
            break;
        case CalendarTypeLunar:
            //农历要刷新月数据和日数据
            [self updateLunarMonthData];
            [self updateLunarDayData];
            break;
        case CalendarTypeNormal:
            //公历要刷新日数据
            [self updateNormalDayData];
            break;
        default:
            break;
    }

    //3.重新加载picker，使最新数据源生效
    [_innerPickView reloadAllComponents];
    //4.让picker同步选中状态
    [self sychronizePickerStatusWithAnimation:YES];

}
//当年份改变的时候 刷新月、日组件
-(void)updateComponentsAfterSelectedYearChanged{

    //1.更新数据源
    //2.更新选择状态
    switch (_calendarType) {
        case CalendarTypeLunar:
            
            [self updateLunarMonthData];
            [self updateLunarDayData];
            break;
        
        case CalendarTypeNormal:
            [self updateNormalDayData];
            break;
        default:
            break;
    }
    //3.重新加载picker，使最新数据源生效
    [_innerPickView reloadComponent:_monthComponent];
    [_innerPickView reloadComponent:_dayComponent];
    //4.让picker同步选中状态
    [self sychronizePickerStatusWithAnimation:NO];
}



//当月份改变的时候 刷新日组件
-(void)updateDayComponentAfterSelectedMonthChaged{
    //1.更新数据源
    //2.更新选择状态
    if (_calendarType == CalendarTypeLunarIgnoreYear) {
        return;
    }
    
    if (_calendarType == CalendarTypeLunar) {
        [self updateLunarDayData];
       
    }
    if (!_isLunar) {
        if (self.day > [self.dayNormalNumberArray[_month-1] integerValue]) {
            _day = [self.dayNormalNumberArray[_month-1] integerValue];
        }
    }
    //3.重新加载picker，使最新数据源生效
    [_innerPickView reloadComponent:_dayComponent];
    //4.让picker同步选中状态
    [self sychronizePickerStatusWithAnimation:NO];

}

//年
//1.更新数据源
//2.更新选中状态
-(void)updateYearData{
    
    self.years = [[NSMutableArray alloc]init];
    NSMutableArray *years = [NSMutableArray new];
    NSInteger endDateYear = self.endDateYear;
    for (int i = 1901; i <= endDateYear; i++) {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.years = years;
    if (_year - OYFirstYear > self.years.count -1) {
        _year = self.years.count+OYFirstYear - 1;
    }
}


-(void)updateNormalDayData{
    //1.更新数据源
    self.dayNormalNumberArray = [OYCalendarData numberOfDaysInEveryMonthOfYear:_year];
    if (_year == self.endDateYear && _endDateMode == OYEndDateModeToday && self.endDateDay < [self.dayNormalNumberArray[self.endDateMonth-1] integerValue]) {
        NSMutableArray * dayNormalNumberArray = [[self.dayNormalNumberArray subarrayWithRange:NSMakeRange(0, self.endDateMonth)] mutableCopy];
        dayNormalNumberArray[self.endDateMonth-1] = @(self.endDateDay);
        self.dayNormalNumberArray = [dayNormalNumberArray copy];
    }
    //2.更新选中状态
    if (self.month > self.dayNormalNumberArray.count) {
        _month = self.dayNormalNumberArray.count;
    }
    if (self.day > [self.dayNormalNumberArray[_month-1] integerValue]) {
        _day = [self.dayNormalNumberArray[_month-1] integerValue];
    }
    
}

-(void)updateLunarMonthData{
    //1.更新数据源
    self.monthLunarStringArray = [self.data lunarMonthStringsOfYear:_year];
    if (_year == self.endDateYear  && _endDateMode == OYEndDateModeToday && self.endDateMonth < _monthLunarStringArray.count) {
        _monthLunarStringArray = [_monthLunarStringArray subarrayWithRange:NSMakeRange(0, self.endDateMonth)];
    }
    
    //2.更新选中状态
    if (self.month > self.monthLunarStringArray.count) {
        _month = self.monthLunarStringArray.count;
    }
    
}
-(void)updateLunarDayData{
    //1.更新数据源
    self.dayLunarStringArray = [self.data lunarDayStringsOfMonth:self.month inYear:_year];
    if (_year == self.endDateYear  && self.month ==self.endDateMonth && _endDateMode == OYEndDateModeToday && self.endDateDay < self.dayLunarStringArray.count) {
        self.dayLunarStringArray = [self.dayLunarStringArray subarrayWithRange:NSMakeRange(0, self.endDateDay)];
    }
    //2.更新选中状态
    if (self.day > self.dayLunarStringArray.count) {
        _day = self.dayLunarStringArray.count;
    }
}

-(void)sychronizePickerStatusWithAnimation:(BOOL)animated{
    [_innerPickView selectRow:self.month-1 inComponent:_monthComponent animated:animated];
    [_innerPickView selectRow:self.day-1 inComponent:_dayComponent animated:animated];
    if (!_isYearIgnored) {
        [_innerPickView selectRow:_year - OYFirstYear inComponent:0 animated:animated];
    }
}
#pragma mark - pickerView delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return _isYearIgnored? 2: 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == _monthComponent) {
        
        switch (_calendarType) {
            
            case CalendarTypeLunar:
            case CalendarTypeLunarIgnoreYear:
                return  _monthLunarStringArray.count;
            case CalendarTypeNormal:
                return _dayNormalNumberArray.count;
            case CalendarTypeNormalIgnoreYear:
                return 12;
            default:
                return 0;
        }

    }else if(component == _dayComponent){
        
        return  self.isLunar?
        _dayLunarStringArray.count
        :[_dayNormalNumberArray[self.month-1] integerValue];
    }else{
        return _years.count;
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == _monthComponent) {
        return _isLunar? _monthLunarStringArray[row]:[NSString stringWithFormat:@"%ld月",(long)row+1];

    }else if(component == _dayComponent){
        return  _isLunar? _dayLunarStringArray[row]:[NSString stringWithFormat:@"%ld日",(long)row+1];
    }else{
        return [_years[row] stringByAppendingString:@"年"];

    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == _monthComponent) {
        self.month=row+1;
    }else if(component == _dayComponent){
        self.day=row+1;
    }else{
        self.year=row+OYFirstYear;
    }
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return self.frame.size.width*2/7;
    

//    if (component == _monthComponent) {
//        return self.frame.size.width*2/7;
//
//    }else if (component == _dayComponent){
//        return self.frame.size.width*2/7;
//    
//    }else{
//        return self.frame.size.width*2/7;
//    }
}

@end
