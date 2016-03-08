//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "EditAbsenceVC.h"
#import "ZQCustomTimePicker.h"
#import "ZQCustomDatePicker.h"

@interface EditAbsenceVC ()

{
    ZQCustomTimePicker *fromTimePicker;
    ZQCustomTimePicker *toTimePicker;
    ZQCustomDatePicker *fromDatePicker;
    ZQCustomDatePicker *toDatePicker;
    
    NSString *fromSelectDateDefalutStr;
    NSString *toSelectDateDefalutStr;
    NSMutableArray *yearArr;
    NSMutableArray *dayArr;
    int fromYearIndex;
    int fromMonthIndex;
    int fromDayIndex;
    int toYearIndex;
    int toMonthIndex;
    int toDayIndex;
    
    UIView *bgView;
    UIImageView *fromTrigon;
    UIImageView *toTrigon;
}

@property(nonatomic,assign)UInt8 fromHour;

@property(nonatomic,assign)UInt8 fromMin;

@property(nonatomic,assign)UInt8 toHour;


@property(nonatomic,assign)int yearInt;

@property(nonatomic,assign)UInt8 dateInt;

@property(nonatomic,assign)UInt8 dayInt;


@property(nonatomic,assign)int yearTo;

@property(nonatomic,assign)UInt8 dateTo;

@property(nonatomic,assign)UInt8 dayTo;

@property(nonatomic,assign)UInt8 toMin;

@property (nonatomic, strong)NSMutableArray *mutableArr;

@property (nonatomic, strong)UIView *dateView;


@property (nonatomic, strong)NSData *fromData;

@property (nonatomic, strong)NSData *toData;


@property (nonatomic, copy)NSString *fromTo;

@property (nonatomic, strong)UIButton *fromButt;
@property (nonatomic, strong)UIButton *toButt;


//
@end

@implementation EditAbsenceVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mutableArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self loadUI];
}
- (void)loadUI
{
    self.titlelab.text = NSLocalizedString(@"Add Absence", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    float lineF = (kScreen_Height == 480) ? 70 : 55;
    float x = (float)kScreen_Width / 320;
    float y = (float)kScreen_Height / 568;
    float h = (kScreen_Width > 320) ? y : 1;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    NSRange range = NSMakeRange(0, 4);
    NSString *yearString = [dateString substringWithRange:range];
    NSString *monthStr = [dateString substringWithRange:NSMakeRange(4, 2)];
    NSString *dayStr = [dateString substringWithRange:NSMakeRange(6, 2)];
    self.nowdYear = yearString.integerValue;
    self.nowHour = [[dateString substringWithRange:NSMakeRange(8, 2)] integerValue];
    self.nowMinute = [[dateString substringWithRange:NSMakeRange(10, 2)] integerValue];
    self.nowDateStr = [dateString substringWithRange:NSMakeRange(0, 8)];
    self.nowTimeStr = [dateString substringWithRange:NSMakeRange(8, 4)];
    fromSelectDateDefalutStr = [dateString substringWithRange:NSMakeRange(0, 8)];
    toSelectDateDefalutStr = [dateString substringWithRange:NSMakeRange(0, 8)];
    
    yearArr = [[NSMutableArray alloc] initWithCapacity:1];
    dayArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < 10; i++) {
        [yearArr addObject:[NSString stringWithFormat:@"%d",(int)self.nowdYear + i]];
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange dayRange = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    // 当月天数
    NSUInteger numberOfDaysInMonth = dayRange.length;
    for (int i = 0; i < numberOfDaysInMonth; i++) {
        [dayArr addObject:[NSString stringWithFormat:@"%02d",1 + i]];
    }
    NSArray *monthArr = [NSArray arrayWithObjects:@"01", @"02", @"03", @"04", @"05", @"06", @"07", @"08", @"09", @"10", @"11", @"12", nil];
    
    fromYearIndex = 0;
    fromMonthIndex = (int)[monthArr indexOfObject:monthStr];
    fromDayIndex = (int)[dayArr indexOfObject:dayStr];
    toYearIndex = 0;
    toMonthIndex = (int)[monthArr indexOfObject: monthStr];
    toDayIndex = (int)[dayArr indexOfObject:dayStr];
    
    // 选择日期
    self.fromButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fromButt.frame = CGRectMake(110 * x, self.barView.frame.size.height + 17, 120, 20);
    self.fromButt.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.fromButt addTarget:self action:@selector(fromdateDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.fromButt setTitleColor:  RGBA(84.0, 199.0, 20.0, 1) forState:UIControlStateNormal];
    [self.fromButt setTitle:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)yearString.integerValue, (long)monthStr.integerValue, (long)dayStr.integerValue] forState:UIControlStateNormal];
    [self.view addSubview:self.fromButt];
    fromTrigon = [[UIImageView alloc] initWithFrame:CGRectMake(111 + 120 * x, self.barView.frame.size.height + 21, 14, 14)];
    fromTrigon.image = [UIImage imageNamed:@"sjx_normal.png"];
    [self.view addSubview:fromTrigon];
    
    self.toButt = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toButt.frame = CGRectMake(110 * x, (int)(kScreen_Height - self.barView.frame.size.height) / 2  + self.barView.frame.size.height - ((iOS_version < 7.0 && kScreen_Height == 480) ? 58 : 45) + lineF, 120, 20);
    self.toButt.titleLabel.font = [UIFont systemFontOfSize:20];
//    [self.toButt setTitleColor: RGBA(30.0, 180.0, 240.0, 1.0) forState:UIControlStateNormal];
    [self.toButt setTitleColor: RGBA(84.0, 199.0, 20.0, 1) forState:UIControlStateNormal];
    [self.toButt setTitle:[NSString stringWithFormat:@"%ld-%02ld-%02ld",(long)yearString.integerValue, (long)monthStr.integerValue, (long)dayStr.integerValue] forState:UIControlStateNormal];
    [self.toButt addTarget:self action:@selector(toDateDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toButt];
    toTrigon = [[UIImageView alloc] initWithFrame:CGRectMake(111 + 120 * x, (int)(kScreen_Height - self.barView.frame.size.height) / 2  + self.barView.frame.size.height + lineF - ((iOS_version < 7.0 && kScreen_Height == 480) ? 53 : 40), 14, 14)];
    toTrigon.image = [UIImage imageNamed:@"sjx_normal.png"];
    [self.view addSubview:toTrigon];
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.barView.frame.size.height, 90, kScreen_Height - self.barView.frame.size.height)];
    leftView.backgroundColor = RGBA(242.0, 242.0, 242.0, 1.0);

    [self.view addSubview:leftView];
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(leftView.frame.size.width, (int)(kScreen_Height - self.barView.frame.size.height) / 2 + lineF - ((iOS_version < 7) ? 30 : 0), kScreen_Width - leftView.frame.size.width, 1)];
    midView.backgroundColor = RGBA(242.0, 242.0, 242.0, 1.0);
    [self.view addSubview:midView];
    
    UILabel *fromLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (int)(kScreen_Height - self.barView.frame.size.height) / 4 + 44, 80, 40)];
    fromLab.backgroundColor = [UIColor clearColor];
    fromLab.font = [UIFont systemFontOfSize:18];
    fromLab.text = NSLocalizedString(@"From",nil);
    fromLab.adjustsFontSizeToFitWidth = YES;
    fromLab.numberOfLines = 0;
    fromLab.textColor = RGBA(0.0, 0.0, 0.0, 1.0);
    [self.view addSubview:fromLab];
    
    UILabel *toLab = [[UILabel alloc] initWithFrame:CGRectMake(20, (int)(kScreen_Height - self.barView.frame.size.height) / 4 * 3 + 22 , 80, 40)];
    toLab.backgroundColor = [UIColor clearColor];
    toLab.font = [UIFont systemFontOfSize:18];
    toLab.adjustsFontSizeToFitWidth = YES;
    toLab.text = NSLocalizedString(@"To", nil);
    toLab.textColor = RGBA(0.0, 0.0, 0.0, 1.0);
    [self.view addSubview:toLab];
    
    float pickerF = (kScreen_Height == 480) ? 40 : 48;
    
    fromTimePicker = [[ZQCustomTimePicker alloc] initWithFrame:CGRectMake((leftView.frame.size.width + 10) * x, (barViewHeight + pickerF) * h, 205, 170) withIsZero:NO andSetTimeString:nil];
    toTimePicker = [[ZQCustomTimePicker alloc] initWithFrame:CGRectMake((leftView.frame.size.width + 10) * x, (barViewHeight + pickerF + ((kScreen_Height == 480) ? 210 : 245)) * h, 205, 170) withIsZero:NO andSetTimeString:nil];
    [self.view addSubview:fromTimePicker];
    [self.view addSubview:toTimePicker];
    
    fromDatePicker = [[ZQCustomDatePicker alloc] initWithFrame:CGRectMake(20, 40, 230, 170)];
    toDatePicker = [[ZQCustomDatePicker alloc] initWithFrame:CGRectMake(20, 40, 230, 170)];
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    bgView.backgroundColor = RGBA(80, 80, 80, 1);
    bgView.alpha = 0;
    [self.view addSubview:bgView];
    
    self.dateView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 280)];
    self.dateView.center = CGPointMake(kScreen_Width / 2, kScreen_Height / 2);
    self.dateView.layer.cornerRadius = 8;
    self.dateView.clipsToBounds = YES;
    self.dateView.backgroundColor = [UIColor whiteColor];
    self.dateView.userInteractionEnabled = YES;
    self.dateView.hidden = YES;
    [self.dateView addSubview:fromDatePicker];
    [self.dateView addSubview:toDatePicker];
    [self.view addSubview:self.dateView];
    
    NSArray *dateArr = [NSArray arrayWithObjects:NSLocalizedString(@"Year", nil), NSLocalizedString(@"Month", nil), NSLocalizedString(@"Day", nil), nil];
    for (int i = 0; i < 3; i++) {
        UILabel *dateLabel = [[UILabel alloc] init];
        if (i == 0) {
            dateLabel.frame = CGRectMake(10, 10, 120, 25);
        }
        if (i == 1) {
            dateLabel.frame = CGRectMake(122, 10, 75, 25);
        }
        if (i == 2) {
            dateLabel.frame = CGRectMake(190, 10, 75, 25);
        }
        dateLabel.adjustsFontSizeToFitWidth = YES;
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.text = [dateArr objectAtIndex:i];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font = [UIFont systemFontOfSize:21];
        [self.dateView addSubview:dateLabel];
    }
    
    UIButton *datecancelButt = [UIButton buttonWithType:UIButtonTypeCustom];
    datecancelButt.frame = CGRectMake(5, 220, 130, 50);
    [datecancelButt addTarget:self action:@selector(dateSaveButtDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
    datecancelButt.tag = 344;
    [datecancelButt setBackgroundImage:[UIImage imageNamed:@"sign_up_button_normal.png"] forState:UIControlStateNormal];
    [datecancelButt setBackgroundImage:[UIImage imageNamed:@"sign_up_button_click.png"] forState:UIControlStateHighlighted];
    [datecancelButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [datecancelButt setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    datecancelButt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.dateView addSubview:datecancelButt];
    
    UIButton *dateSaveButt = [UIButton buttonWithType:UIButtonTypeCustom];
    dateSaveButt.frame = CGRectMake(135, 220, 130, 50);
    [dateSaveButt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dateSaveButt setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    dateSaveButt.tag = 345;
    [dateSaveButt setBackgroundImage:[UIImage imageNamed:@"change_password_button_normal.png"] forState:UIControlStateNormal];
    [dateSaveButt setBackgroundImage:[UIImage imageNamed:@"change_password_button_click.png"] forState:UIControlStateHighlighted];
    [dateSaveButt addTarget:self action:@selector(dateSaveButtDeviceMethod:) forControlEvents:UIControlEventTouchUpInside];
    dateSaveButt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.dateView addSubview:dateSaveButt];
    
    
    NSDateComponents *componts = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[NSDate date]];
    
    self.yearInt = (int)[componts year];
    self.dateInt = [componts month];
    self.dayInt  = [componts day];
    
    self.yearTo = (int)[componts year];
    
    self.dateTo = [componts month];
    self.dayTo  = [componts day];
}

- (void)monthdateChanged:(UIDatePicker *)picker
{
    NSDateComponents *componts = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[picker date]];
    
    if ([self.fromTo isEqualToString:@"from"]) {
        
        self.yearInt = (int)[componts year];
        self.dateInt = [componts month];
        self.dayInt  = [componts day];
        
    }else{
        
        self.yearTo = (int)[componts year];
        self.dateTo = [componts month];
        self.dayTo  = [componts day];
    }
}

- (void)dateSaveButtDeviceMethod:(UIButton *)but
{
    NSString *fromSelectDateStr = [NSString stringWithFormat:@"%d%02d%02d", [yearArr[fromDatePicker.yearPicker.currentItemIndex] intValue], (int)fromDatePicker.monthPicker.currentItemIndex + 1, (int)fromDatePicker.dayPicker.currentItemIndex + 1];
    NSString *toSelectDateStr = [NSString stringWithFormat:@"%d%02d%02d",[yearArr[toDatePicker.yearPicker.currentItemIndex] intValue], (int)toDatePicker.monthPicker.currentItemIndex + 1, (int)toDatePicker.dayPicker.currentItemIndex + 1];
    
    
    // 判断是从from选择的 还是从to选择的
    switch (but.tag) {
        case 345:
        {
            if ([self.fromTo isEqualToString:@"from"]) {
                // 判断选择的日期不能小于当前日期
                if (fromSelectDateStr.integerValue < self.nowDateStr.integerValue ) {
                    
                    [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen date error.", nil)];
                } else {
                    [self.fromButt setTitle:[NSString stringWithFormat:@"%d-%02d-%02d", [yearArr[fromDatePicker.yearPicker.currentItemIndex] intValue], (int)fromDatePicker.monthPicker.currentItemIndex + 1, (int)fromDatePicker.dayPicker.currentItemIndex + 1] forState:UIControlStateNormal];
                    fromYearIndex = (int)fromDatePicker.yearPicker.currentItemIndex;
                    fromMonthIndex = (int)fromDatePicker.monthPicker.currentItemIndex;
                    fromDayIndex = (int)fromDatePicker.dayPicker.currentItemIndex;
                    fromSelectDateDefalutStr = fromSelectDateStr;
                    bgView.alpha = 0;
                    self.dateView.hidden = YES;
                }
            } else {
                if (toSelectDateStr.integerValue < fromSelectDateDefalutStr.integerValue) {
                    
                    [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen date error.", nil)];
                } else {
                    [self.toButt setTitle:[NSString stringWithFormat:@"%d-%02d-%02d",[yearArr[toDatePicker.yearPicker.currentItemIndex] intValue], (int)toDatePicker.monthPicker.currentItemIndex + 1, (int)toDatePicker.dayPicker.currentItemIndex + 1] forState:UIControlStateNormal];
                    toYearIndex = (int)toDatePicker.yearPicker.currentItemIndex;
                    toMonthIndex = (int)toDatePicker.monthPicker.currentItemIndex;
                    toDayIndex = (int)toDatePicker.dayPicker.currentItemIndex;
                    toSelectDateDefalutStr = toSelectDateStr;
                    bgView.alpha = 0;
                    self.dateView.hidden = YES;
                }
            }
        }
            break;
            
        case 344:
        {
            // 点击取消按钮后 datePicker恢复所选中的状态
            [fromDatePicker.yearPicker scrollToItemAtIndex:fromYearIndex animated:NO];
            [fromDatePicker.monthPicker scrollToItemAtIndex:fromMonthIndex animated:NO];
            [fromDatePicker.dayPicker scrollToItemAtIndex:fromDayIndex  animated:NO];
            [toDatePicker.yearPicker scrollToItemAtIndex:toYearIndex animated:NO];
            [toDatePicker.monthPicker scrollToItemAtIndex:toMonthIndex  animated:NO];
            [toDatePicker.dayPicker scrollToItemAtIndex:toDayIndex  animated:NO];
            
//            NSLog(@"==from== %d %d %d == to ===%d %d %d ",fromYearIndex, fromMonthIndex, fromDayIndex, toYearIndex, toMonthIndex, toDayIndex);
            
            bgView.alpha = 0;
            self.dateView.hidden = YES;
        }
            break;
        default:
            break;
    }
    
}
- (void)fromdateDeviceMethod:(UIButton *)but
{
    [fromTrigon setImage:[UIImage imageNamed:@"sjx_click.png"]];
    [self performSelector:@selector(changePic) withObject:nil afterDelay:.2f];
    bgView.alpha = 0.9;
    self.dateView.hidden = NO;
    fromDatePicker.hidden = NO;
    toDatePicker.hidden = YES;
    self.fromTo = @"from";
}

- (void)toDateDeviceMethod:(UIButton *)but
{
    [toTrigon setImage:[UIImage imageNamed:@"sjx_click.png"]];
    [self performSelector:@selector(changePic) withObject:nil afterDelay:0.2f];
    bgView.alpha = 0.9;
    self.dateView.hidden = NO;
    fromDatePicker.hidden = YES;
    toDatePicker.hidden = NO;
    self.fromTo = @"to";
}

- (void)changePic
{
    [fromTrigon setImage:[UIImage imageNamed:@"sjx_normal.png"]];
    [toTrigon setImage:[UIImage imageNamed:@"sjx_normal.png"]];
}

- (void)dateChanged:(UIDatePicker *)picker
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[picker date]];
    self.fromHour = [components hour];
    self.fromMin = [components minute];
    
}

- (void)toDatapickerdateChanged:(UIDatePicker *)picker
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit |NSCalendarUnitMinute |NSCalendarUnitSecond | NSCalendarUnitHour fromDate:[picker date]];
    self.toHour = [components hour];
    self.toMin = [components minute];
}

- (void)leftButtonMethod:(UIButton *)but
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadButtonMethod:(UIButton *)sender
{
    NSString *fromSelectTimeStr = [NSString stringWithFormat:@"%02ld%02ld",(long)fromTimePicker.hourPicker.currentItemIndex, (long)fromTimePicker.minutePicker.currentItemIndex];
    NSString *toSelectTimeStr = [NSString stringWithFormat:@"%02ld%02ld",(long)toTimePicker.hourPicker.currentItemIndex, (long)toTimePicker.minutePicker.currentItemIndex];
    
    if (fromSelectDateDefalutStr.intValue == self.nowDateStr.intValue) {
        
        if (toSelectDateDefalutStr.integerValue == fromSelectDateDefalutStr.integerValue)
        {
            if (fromTimePicker.hourPicker.currentItemIndex < self.nowHour || fromSelectTimeStr.integerValue < self.nowTimeStr.integerValue || toSelectTimeStr.integerValue <= fromSelectTimeStr.integerValue)
            {
                [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen time error.", nil)];
                return;
            }
        }
    }
    if (fromSelectDateDefalutStr.intValue > self.nowDateStr.intValue) {
        
        if (toSelectDateDefalutStr.integerValue == fromSelectDateDefalutStr.integerValue)
        {
            if (toSelectTimeStr.integerValue <= fromSelectTimeStr.integerValue) {
                
                [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen time error.", nil)];
                return;
            }
        }
    }
    if (toSelectDateDefalutStr.integerValue < fromSelectDateDefalutStr.integerValue) {
        
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Chosen date error.", nil)];
        return;
    }
    self.fromData = [self fromDateToDataBytes];
    self.toData = [self toDateToDataBytes];
    
    // 设置防盗
    Device *device = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:self.macString];
    [DeviceManagerInstance absenceToDeviceWith:device.mac Withhost:device.host ToOpen:YES WithState:self.fromData WithTodate:self.toData key:device.key With:device.localContent deviceType:device.deviceType];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (NSData *)fromDateToDataBytes
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *fromDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%d-%02d-%02d %02ld:%02ld:00", [[fromSelectDateDefalutStr substringWithRange:NSMakeRange(0, 4)] intValue], [[fromSelectDateDefalutStr substringWithRange:NSMakeRange(4, 2)] intValue], [[fromSelectDateDefalutStr substringWithRange:NSMakeRange(6, 2)] intValue],  (long)fromTimePicker.hourPicker.currentItemIndex, (long)fromTimePicker.minutePicker.currentItemIndex]];
    NSTimeInterval time = [fromDate timeIntervalSince1970];
    int i = time;
    NSData *doubleData =  [self intToData:i withDataLength:4];
    return doubleData;
}

- (NSData *)toDateToDataBytes
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *toDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%d-%02d-%02d %02ld:%02ld:00",[[toSelectDateDefalutStr substringWithRange:NSMakeRange(0, 4)] intValue], [[toSelectDateDefalutStr substringWithRange:NSMakeRange(4, 2)] intValue], [[toSelectDateDefalutStr substringWithRange:NSMakeRange(6, 2)] intValue], (long)toTimePicker.hourPicker.currentItemIndex, (long)toTimePicker.minutePicker.currentItemIndex]];
    NSTimeInterval time = [toDate timeIntervalSince1970];
    int i = time;
    NSData *doubleData =  [self intToData:i withDataLength:4];
    return doubleData;
}

- (NSData *)intToData:(long long)transInt withDataLength:(int)n
{
    Byte byte[n];
    for (int i = 0; i < n; i++) {
        UInt8 k = (transInt & (0xff << (8 * i))) >> (8 * i);
        byte[n - i - 1] = k;
    }
    NSData *data = [NSData dataWithBytes:byte length:n];
    return data;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
