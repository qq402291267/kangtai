//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "LoginINVC.h"

@interface LoginINVC ()<UITextFieldDelegate>
{
    UITextField *passText;
    UITextField *userText;
}

@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,copy)NSString *emailString;
@property(nonatomic,copy)NSString *passString;
@property(nonatomic,copy)NSString *loginString;

@property (strong,nonatomic) NSString  *imageSTring;


@end

@implementation LoginINVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *userInfo =  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
    NSString *passWord =  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_PASSWORD];
    
    NSLog(@"userInfo==%@===pwd=%@",userInfo,passWord);
    if (userInfo == nil || [userInfo isEqualToString:@""] || [userInfo isEqual:[NSNull null]] || passWord == nil || [passWord isEqualToString:@""] || [passWord isEqual:[NSNull null]])
    {
        
        self.loginString = @"login";
        NSLog(@"null");
        
    }else{
        [NSThread sleepForTimeInterval:0.5];
        self.loginString = @"lastlogin";
        
        [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
        [MMProgressHUD showWithTitle:NSLocalizedString(@"Login",nil) status:@""];
        [self  loginRequestHttpToServerWithpsWord:passWord withemailString:userInfo];
        
    }
    
    [self layUI];
}

- (void)layUI
{
    self.navigationController.navigationBarHidden = YES;
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, kScreen_Width, kScreen_Height)];
    self.scrollView .backgroundColor = [UIColor clearColor];
    //设置是否显示垂直滑动条
    self.scrollView .showsVerticalScrollIndicator = NO;
    //    设置代理
    self.scrollView .delegate = self;
    self.scrollView.scrollEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    
    float f = (kScreen_Width > 320) ? 100 : 45;
    float h = (kScreen_Width > 320) ? 220 : 205;
    float width = (kScreen_Width > 320) ? 170 : 130;
    float height = (kScreen_Width > 320) ? 80 : 60;

    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width- width) /2, (kScreen_Width > 320) ? 65 : 45, width, height)];
    logoImgView.image = [UIImage imageNamed:@"company_logo.png"];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, kScreen_Width, kScreen_Height)];
    backImgView.image = [UIImage imageNamed:@"login_back.png"];

    [self.scrollView addSubview:backImgView];
    [self.scrollView addSubview:logoImgView];
    
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapFrom:)];
    [self.scrollView addGestureRecognizer:singleRecognizer];
    
//    登入按键
    UIButton *lognin = [UIButton buttonWithType:UIButtonTypeCustom];
    lognin.frame = CGRectMake(25, h + f + ((kScreen_Width > 320) ? 3 : 10), kScreen_Width - 50, 40);
    [lognin setBackgroundImage:[UIImage imageNamed:@"login_button_normal.png"] forState:UIControlStateNormal];
    [lognin setBackgroundImage:[UIImage imageNamed:@"login_button_click.png"] forState:UIControlStateHighlighted];
    [lognin addTarget:self action:@selector(loginMethod:) forControlEvents:UIControlEventTouchUpInside];
    [lognin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lognin setTitle:NSLocalizedString(@"Log In", nil) forState:UIControlStateNormal];
    [self.scrollView addSubview:lognin];
    
//    注册按键
    UIButton *signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    signUp.frame = CGRectMake(25, 70 + h + f, kScreen_Width - 50, 40);
    [signUp setBackgroundImage:[UIImage imageNamed:@"sign_up_button_normal.png"] forState:UIControlStateNormal];
    [signUp setBackgroundImage:[UIImage imageNamed:@"sign_up_button_click.png"] forState:UIControlStateHighlighted];
    [signUp addTarget:self action:@selector(signUpMethod:) forControlEvents:UIControlEventTouchUpInside];
    [signUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [signUp setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
    [self.scrollView addSubview:signUp];
    
    UIButton *forgetPWDBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPWDBtn.frame = CGRectMake(kScreen_Width - 225, kScreen_Height - ((kScreen_Height == 480) ? 80 : 90), 200, 40);
    forgetPWDBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [forgetPWDBtn setTitle:NSLocalizedString(@"Forget Password", nil) forState:UIControlStateNormal];
    [forgetPWDBtn setTitleColor:RGBA(80, 200, 27, 1) forState:UIControlStateNormal];
    forgetPWDBtn.titleLabel.font =[UIFont systemFontOfSize:18];
    forgetPWDBtn.contentHorizontalAlignment = 2;
    [forgetPWDBtn addTarget:self action:@selector(forgetPasswordMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:forgetPWDBtn];
    
    UIImageView *textImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_input_squre.png"]];
    textImage.frame = CGRectMake(25, 90 + f , kScreen_Width - 50, 100);
    [self.scrollView addSubview:textImage];
    
    userText = [[UITextField alloc] initWithFrame:CGRectMake(32, 96 + f, kScreen_Width - 57, 44)];
    userText.textColor = [UIColor blackColor];
    userText.placeholder = NSLocalizedString(@"Email", nil);
    userText.font = [UIFont systemFontOfSize:16];
    userText.textAlignment = NSTextAlignmentLeft;
    if ([self.loginString isEqualToString:@"lastlogin"]) {
        
        NSString *userInfo =  [[NSUserDefaults standardUserDefaults]objectForKey:KEY_USERMODEL];
        
        userText.text = userInfo;
    }
    userText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userText.borderStyle = UITextBorderStyleNone;
    userText.tag = 111;
    userText.delegate = self;
    [self.scrollView addSubview:userText];
    
    passText = [[UITextField alloc] initWithFrame:CGRectMake(32, 141 + f, kScreen_Width - 57, 44)];
    passText.textColor = [UIColor blackColor];
    passText.placeholder = NSLocalizedString(@"Password", nil);
    passText.font = [UIFont systemFontOfSize:16];
    passText.textAlignment = NSTextAlignmentLeft;
    passText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passText.borderStyle = UITextBorderStyleNone;
    passText.tag = 112;
    passText.secureTextEntry = YES;
    passText.delegate = self;
    [self.scrollView addSubview:passText];
}

- (void)loginMethod:(UIButton *)but
{
    [self textFieldDidEndEditing:userText];
    [self textFieldDidEndEditing:passText];
    
    [self animationToKeyBoardDown];
    if (self.emailString == nil || [self.emailString isEqualToString:@""] || self.passString == nil || [self.passString isEqualToString:@""])
    {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Options can not be empty", nil)];
        
        return;
    }
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    
    [MMProgressHUD showWithTitle:NSLocalizedString(@"Login",nil) status:NSLocalizedString(@"Loading", nil)];
    
    [self loginRequestHttpToServerWithpsWord:self.passString withemailString:self.emailString];
}

#pragma mark-HTTP
- (void)loginRequestHttpToServerWithpsWord:(NSString *)psWord withemailString:(NSString *)emailString
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *appName = [Util getAppName];
    NSString *currentCountry = [Util getCurrentCountry];
    NSLog(@"=== %@ %@", appName, currentCountry);
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *tempString =   [Util  getPassWordWithmd5:psWord];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:emailString forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [dict setValue:[NSString stringWithFormat:@"%d",2] forKey:@"appType"];
    [dict setValue:appName forKey:@"appName"];
    [dict setValue:app_Version forKey:@"appVersion"];
    [dict setValue:currentCountry forKey:@"country"];

    // appType
    [HTTPService POSTHttpToServerWith:LoginURL WithParameters:dict success:^(NSDictionary *dic) {
        
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
            
            [self getWiFiListWith:psWord andEmail:emailString];
            [[NSUserDefaults standardUserDefaults]setObject:emailString forKey:KEY_USERMODEL];
            
            if (psWord == nil || [psWord isEqualToString:@""] || [psWord isEqual:[NSNull null]]) {
                
            }else{
                [[NSUserDefaults standardUserDefaults]setObject:psWord forKey:KEY_PASSWORD];
                
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        if ([success boolValue] == false) {
            
            [MMProgressHUD dismiss];
            
            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Username or password error", nil)];
            
        }
    } error:^(NSError *error) {
        
        
        [MMProgressHUD dismiss];
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Link Timeout", nil)];
    }];
}

//获取 WiFi 设备列表
- (void)getDeviceWifiTableRequestHttpToServerWord:(NSString *)email WithPassWord:(NSString *)passwprd
{
    
    NSString *tempString = [Util getPassWordWithmd5:passwprd];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:email forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    
    [HTTPService GetHttpToServerWith:GetwifiInfoURL WithParameters:dict  success:^(NSDictionary *dic) {
        
        NSString * success = [dic objectForKey:@"success"];
        
        if ([success boolValue] == true) {
            
            NSArray *array =[dic objectForKey:@"list"];
            
            NSLog(@"=== %@", dic);
            
            if (array.count !=0 || array.count == 0) {
                
                NSMutableArray *socketViewArray = [DataBase ascWithRFtableINOrderNumber];
                for (int i = 0; i <socketViewArray.count; i ++) {
                    Device *dec = [socketViewArray objectAtIndex:i];
                    [DataBase deleteDataFromDataBase:dec];
                }
            }
            for (NSDictionary *dictary in array) {
                Device *diceVi = [[Device alloc] init];
                diceVi.authCodeString = [dictary objectForKey:@"authCode"];
                diceVi.codeString = [dictary objectForKey:@"companyCode"];
                diceVi.name = [dictary objectForKey:@"deviceName"];
                diceVi.deviceType = [dictary objectForKey:@"deviceType"];
                diceVi.image = [dictary objectForKey:@"imageName"];
                diceVi.macString = [dictary objectForKey:@"macAddress"];
                diceVi.orderNumber = [[dictary objectForKey:@"orderNumber"] intValue];
                [DataBase insertIntoDataBase:diceVi];
                
                diceVi.localContent = @"0";
                diceVi.alarm = @"off";
                diceVi.hver = @"0";
                diceVi.interval  = 5;
                diceVi.remoteContent = @"1";
                diceVi.deviceRespons = NO;
                diceVi.heartBeatNumber = 0;
                
                diceVi.mac = [Crypt decodeHex:diceVi.macString];
                [[DeviceManagerInstance  getlocalDeviceDictary] setObject:diceVi  forKey:diceVi.macString];
            }
            
            [self down];
        }
        
        if ([success boolValue] == false) {
            
            [MMProgressHUD dismiss];
            
//            [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:[dic objectForKey:@"msg"]];
            
        }
        
    } error:^(NSError *error) {
        [MMProgressHUD dismiss];
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Link Timeout", nil)];
    }];
    
}

//获取 RF 设备列表
- (void)getDeviceRFTableRequestHttpToServerWord:(NSString *)email WithPassWord:(NSString *)passwprd
{
    
    NSString *tempString = [Util getPassWordWithmd5:passwprd];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:AccessKey forKey:@"accessKey"];
    [dict setValue:email forKey:@"username"];
    [dict setValue:tempString forKey:@"password"];
    [HTTPService GetHttpToServerWith:GetRFInfoURL WithParameters:dict  success:^(NSDictionary *dic) {

        NSString * success = [dic objectForKey:@"success"];

        if ([success boolValue] == true) {
            NSLog(@"===获取RF列表成功 === %@", dic);


            NSArray *tempArray = [dic objectForKey:@"list"];

            NSLog(@"== %d ==",(int)tempArray.count);
            
            if (tempArray.count !=0 || tempArray.count == 0)
            {

                NSMutableArray *listArray = [RFDataBase ascWithRFTableINorderNumber];
                if (listArray.count != 0) {
                    for (RFDataModel *model in listArray)
                    {
                        [RFDataBase deleteDataFromDataBase:model];
                    }
                }
            }
            
            // 添加到数据库
            for (NSDictionary *dictary in tempArray)
            {
                RFDataModel *model = [[RFDataModel alloc] init];
                model.rfDataLogo = [dictary objectForKey:@"imageName"];
                model.rfDataMac = [dictary objectForKey:@"macAddress"];
                model.rfDataName = [dictary objectForKey:@"deviceName"];
                model.typeRF = [dictary objectForKey:@"type"];
                model.address = [dictary objectForKey:@"addressCode"];
                model.orderNumber = [[dictary objectForKey:@"orderNumber"] integerValue];
                
                [RFDataBase insertIntoDataBase:model];
            }
                [self downLoadRFimageView];

        }
        if ([success boolValue] == false) {


        }


    } error:^(NSError *error) {
        NSLog(@"error");
    }];

}



//getWiFiListWith:psWord andEmail:emailString
- (void)getWiFiListWith:(NSString *)psWord andEmail:(NSString *)emailString
{
    //    dispatch_async(dispatch_get_main_queue(), ^{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:KEY_PASSWORD] == nil || [[defaults objectForKey:KEY_PASSWORD] isEqual:[NSNull null]] || [[defaults objectForKey:KEY_PASSWORD] isEqualToString:@""]) {
        
        
        [self getDeviceWifiTableRequestHttpToServerWord:emailString WithPassWord:psWord];
        
    }else
    {
        
        [self getDeviceWifiTableRequestHttpToServerWord:[defaults objectForKey:KEY_USERMODEL] WithPassWord:[defaults objectForKey:KEY_PASSWORD]];
        
    }
    //    });
}



- (void)down
{
    //    下载图片
    
    NSArray *dicArray = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    
    for (int i= 0; i < dicArray.count; i ++) {
        
        
        NSString *keyMac =   [dicArray objectAtIndex:i];
        
        Device *decives =[[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keyMac];
        
        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",decives.image]];//获取程序包中相应文件的路径
        NSFileManager *fileMa = [NSFileManager defaultManager];
        
        if(![fileMa fileExistsAtPath:dataPath]) //
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:decives.image]]) {
                
                
                [self httdpwnload:decives.image];
            }
            
            
        }else{
            
            continue;
            
        }
        
    }
    
    [self getRFlistTable];
    [self performSelector:@selector(pushToMainVC)  withObject:nil afterDelay:2.5];
    [self loadDataLocal];
    
    [self performSelector:@selector(subscrbetoevents) withObject:nil afterDelay:0.5];
}

- (void)deviceLinseToTCP
{
    NSArray *dicArray = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    
    for (int i = 0; i < dicArray.count; i ++)
    {
        NSString*keyMac =  [dicArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keyMac];
        
        [DeviceManagerInstance queryGPIOEventToMacDevice:decix.mac withHost:decix.host withloaclContent:decix.localContent deviceType:decix.deviceType];
    }
}

- (void)subscrbetoevents
{
    NSArray *dicArray = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    
    for (int i = 0; i < dicArray.count; i ++)
    {
        NSString*keyMac =  [dicArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keyMac];
        
        [RemoteServiceInstance subscribetoeventsWith:YES WithMac:decix.mac with:0x85 deviceType:decix.deviceType];
    }
}

- (void)loadDataLocal
{
    NSArray *dicArray = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    if (dicArray.count == 0) {
        return;
    }
    for (int i = 0; i < dicArray.count; i ++)
    {
        NSString*keyMac =  [dicArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keyMac];
        
        if ([DeviceManagerInstance networkStatus] == ReachableViaWiFi)
        {
            
            for (int i = 0; i < 2; i ++) {
                switch ([decix.deviceType intValue]) {
                    case 11:
                        [LocalServiceInstance addDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                    case 21:
                        [LocalServiceInstance addEnergyDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                    case 31:
                        [LocalServiceInstance addRFDeviceToFMDBWithisAdd:YES WithMac:decix.mac];
                        break;
                        
                    default:
                        break;
                }
            }
            
            if (decix != nil) {
                [[DeviceManagerInstance getlocalDeviceDictary] setObject:decix forKey:decix.macString];
            }

        }
    }
}
 
- (void)getDeviceOnline:(NSData *)mac withDeviceType:(NSString *)type
{
    [RemoteServiceInstance queryEquipmentOnlineWithMac:mac deviceType:type];
}

- (void)downLoadRFimageView
{
    NSMutableArray *modelArray =[RFDataBase ascWithRFTableINorderNumber];
    
    for (RFDataModel *model in modelArray) {
        
        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/%@",model.rfDataLogo]];//获取程序包中相应文件的路径
        NSFileManager *fileMa = [NSFileManager defaultManager];
        
        if(![fileMa fileExistsAtPath:dataPath]) //
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:[Util getFilePathWithImageName:model.rfDataLogo]]) {
                
                NSLog(@"meiypi==");
                
                [self httdpwnload:model.rfDataLogo];
            }
            
            
        }else{
            
            continue;
            
        }
    }    
}

- (void)getRFlistTable
{

    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults objectForKey:KEY_PASSWORD] == nil || [[defaults objectForKey:KEY_PASSWORD] isEqual:[NSNull null]] || [[defaults objectForKey:KEY_PASSWORD] isEqualToString:@""]) {


            [self getDeviceRFTableRequestHttpToServerWord:self.emailString  WithPassWord:self.passString];

        }else
        {

            [self getDeviceRFTableRequestHttpToServerWord:[defaults objectForKey:KEY_USERMODEL]  WithPassWord:[defaults objectForKey:KEY_PASSWORD]];
        }
    });

}
- (void)httdpwnload:(NSString *)url
{
    [HTTPService downloadWithFilePathString:[NSString stringWithFormat:@"%@/%@",UploadedFileImageUrl,url] downLoadPath:^(NSString *filePath) {
        
        NSLog(@"file=%@",filePath);
        
        
    } error:^(NSError *error) {
        
    }];
}

- (void)pushToMainVC
{
    if ([self.loginString isEqualToString:@"loading"]) {
        [[NSUserDefaults standardUserDefaults]setObject:self.emailString forKey:KEY_USERMODEL];
        
        [[NSUserDefaults standardUserDefaults]setObject:self.passString forKey:KEY_PASSWORD];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }
    
    
    NSArray *dicArray = [[DeviceManagerInstance getlocalDeviceDictary] allKeys];
    
    for (int i = 0; i < dicArray.count; i ++)
    {
        NSString*keyMac =  [dicArray objectAtIndex:i];
        Device *decix = [[DeviceManagerInstance getlocalDeviceDictary] objectForKey:keyMac];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getDeviceOnline:decix.mac withDeviceType:decix.deviceType];
        });
    }
    
    [self performSelector:@selector(deviceLinseToTCP) withObject:nil afterDelay:0.5];
    
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(toDeviceVC:) userInfo:nil repeats:YES];
}

- (void)toDeviceVC:(NSTimer *)timer
{
//    if ([Util getAppDelegate].connected) {
        [timer invalidate];
        timer = nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [Util getAppDelegate].hasRun = YES;
        });

        [Util getAppDelegate].rootVC = [[RootViewController alloc] init];
        [Util getAppDelegate].window.rootViewController = [Util getAppDelegate].rootVC;
//    }
}

- (void)forgetPasswordMethod:(UIButton *)btn
{
    ForGetPwdVC *forGet = [[ForGetPwdVC alloc] init];
    [self.navigationController pushViewController:forGet animated:YES];
}

- (void)signUpMethod:(UIButton *)but
{
    RegisterationVC *signin = [[RegisterationVC alloc] init];
    
    [self.navigationController pushViewController:signin animated:YES];
}

- (void)handleSingleTapFrom:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [self animationToKeyBoardDown];
        
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark-
#pragma mark-<UITextFieldDelegate>
//return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self animationToKeyBoardDown];
    
    return YES;
}


- (void)animationToKeyBoardDown
{
    [self.view endEditing:YES];
    
    self.scrollView.scrollEnabled = NO;
    
    self.scrollView .contentSize = CGSizeMake(kScreen_Width, kScreen_Height);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, -20);
        
    }];
}

//开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.scrollView .contentSize = CGSizeMake(kScreen_Width, kScreen_Height+200);
    
    self.scrollView.scrollEnabled = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        if (kScreen_Height <= 480) {
            if (textField.tag == 111) {
                
                self.scrollView.contentOffset = CGPointMake(0, 90);
            }else{
                self.scrollView.contentOffset = CGPointMake(0, 90);
                
            }
        }
        
    }];
    
    return YES;
}

//结束编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 111) {
        
        self.emailString = textField.text;
    }else{
        
        self.passString = textField.text;
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
