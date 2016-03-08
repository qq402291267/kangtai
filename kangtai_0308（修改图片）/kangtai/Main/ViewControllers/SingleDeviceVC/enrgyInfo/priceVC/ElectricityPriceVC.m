//
//  ElectricityPriceVC.m
//  kangtai
//
//  Created by 张群 on 14/10/30.
//  Copyright (c) 2014年 ohbuy. All rights reserved.
//

#import "ElectricityPriceVC.h"

@interface ElectricityPriceVC ()<UITextFieldDelegate>
{
    NSString *currencyStr;
    NSString *priceStr;
    UITextField *costTextField;
}

@end

@implementation ElectricityPriceVC

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initUI];
}

- (void)initUI
{
    self.titlelab.text = NSLocalizedString(@"Electricity Price", nil);
    self.view.backgroundColor = RGBA(248, 248, 248, 1);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, self.barView.frame.size.height, 90, kScreen_Height - self.barView.frame.size.height)];
    leftView.backgroundColor = RGBA(242.0, 242.0, 242.0, 1.0);
    [self.view addSubview:leftView];
    
    CGSize size = [Util sizeForText:NSLocalizedString(@"Unit Cost", nil) Font:16.f forWidth:90];
    UILabel *costLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, barViewHeight + 65 * heightScale , 90, size.height)];
    costLabel.numberOfLines = 0;
    costLabel.lineBreakMode = NSLineBreakByCharWrapping;
    costLabel.backgroundColor = [UIColor clearColor];
    costLabel.text = NSLocalizedString(@"Unit Cost", nil);
    costLabel.textAlignment = NSTextAlignmentCenter;
    costLabel.font = [UIFont systemFontOfSize:16];
    costLabel.textColor = RGBA(35, 35, 35, 1);
    [self.view addSubview:costLabel];
    
    UIImageView *inputView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"input_squre.png"]];
    inputView.frame = CGRectMake(110,  costLabel.frame.origin.y + 10, kScreen_Width - 180 , 7.5);

    inputView.userInteractionEnabled = YES;
    [self.view addSubview:inputView];
    UILabel *energyUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(115 + inputView.frame.size.width, costLabel.frame.origin.y + 3, 40, 20)];
    energyUnitLabel.backgroundColor = [UIColor clearColor];
    energyUnitLabel.text = NSLocalizedString(@"/kwh", nil);
    energyUnitLabel.textAlignment = NSTextAlignmentCenter;
    energyUnitLabel.font = [UIFont systemFontOfSize:16];
    energyUnitLabel.textColor = [UIColor grayColor];
    [self.view addSubview:energyUnitLabel];

    costTextField = [[UITextField alloc] initWithFrame:CGRectMake(115, inputView.frame.origin.y - 25, kScreen_Width - 190, 40)];
    costTextField.delegate = self;
    NSString *costStr = [[NSUserDefaults standardUserDefaults] objectForKey:self.macStr];
    if (costStr == nil || [costStr isEqualToString:@""]) {
        costTextField.text = @"0.00";
    } else {
        costTextField.text = [NSString stringWithFormat:@"%.2f",[costStr floatValue]];
    }
    costTextField.textAlignment = NSTextAlignmentCenter;
    costTextField.keyboardType = UIKeyboardTypeDecimalPad;
    costTextField.font = [UIFont systemFontOfSize:20];
    costTextField.textColor = RGBA(84.0, 199.0, 20.0, 1);
    [self.view addSubview:costTextField];
    
    size = [Util sizeForText:NSLocalizedString(@"Currency", nil) Font:16.f forWidth:90];

    UILabel *currencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, barViewHeight + 240 * heightScale , 90, size.height)];
    currencyLabel.numberOfLines = 0;
    currencyLabel.lineBreakMode = NSLineBreakByCharWrapping;
    currencyLabel.backgroundColor = [UIColor clearColor];
    currencyLabel.text = NSLocalizedString(@"Currency", nil);
    currencyLabel.textAlignment = NSTextAlignmentCenter;
    currencyLabel.font = [UIFont systemFontOfSize:16];
    currencyLabel.textColor = RGBA(35, 35, 35, 1);
    [self.view addSubview:currencyLabel];

    NSString *currencyString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@",self.macStr,self.macStr]];
    if (currencyString == nil || [currencyString isEqualToString:@""]) {
        currencyString = @"$";
    }
    NSArray *currencyArr = [NSArray arrayWithObjects:NSLocalizedString(@"unit_doller", nil), NSLocalizedString(@"unit_rmb", nil), NSLocalizedString(@"unit_gbp", nil), NSLocalizedString(@"unit_", nil), NSLocalizedString(@"unit_rbl", nil), nil];
    for (int i = 0; i < 5; i++) {
        UIButton *currencyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        currencyBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        currencyBtn.frame = CGRectMake(95 + (kScreen_Width / 5 - 21) * i, currencyLabel.frame.origin.y + 1, (kScreen_Width - 105) / 5, 20);
        [currencyBtn setTitle:currencyArr[i] forState:UIControlStateNormal];
        [currencyBtn addTarget:self action:@selector(changeCurrency:) forControlEvents:UIControlEventTouchUpInside];
        currencyBtn.tag = 100 + i;
        if (i == [currencyArr indexOfObject:currencyString]) {
            [currencyBtn setTitleColor: RGBA(84.0, 199.0, 20.0, 1) forState:UIControlStateNormal];
        } else {
            [currencyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        [self.view addSubview:currencyBtn];
    }
    
    UITapGestureRecognizer *endEditingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:endEditingTap];
}

#pragma mark - endEditing
- (void)endEditing
{
    [self.view endEditing:YES];
}

#pragma mark - navBarBtn method
- (void)leftButtonMethod:(UIButton *)but
{
    EnergyInfoVC *energyVC = [[EnergyInfoVC alloc] init];
    energyVC.type = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)reloadButtonMethod:(UIButton *)sender
{
    [self textFieldDidEndEditing:costTextField];

    BOOL isPositive = [self isPositiveFloat:priceStr];
    if (!isPositive) {
        [Util showAlertWithTitle:NSLocalizedString(@"Tips", nil) msg:NSLocalizedString(@"Please enter an available float value", nil)];
        return;
    } 
    
    [[NSUserDefaults standardUserDefaults] setObject:priceStr forKey:self.macStr];
    [[NSUserDefaults standardUserDefaults] setObject:currencyStr forKey:[NSString stringWithFormat:@"%@%@",self.macStr, self.macStr]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    EnergyInfoVC *energyVC = [[EnergyInfoVC alloc] init];
    energyVC.type = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - currencyBtn method
- (void)changeCurrency:(UIButton *)btn
{
    for (int i = 0; i < 5; i++) {
        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:100 + i];
        if (i == btn.tag - 100) {
            [tempBtn setTitleColor: RGBA(84.0, 199.0, 20.0, 1) forState:UIControlStateNormal];
            currencyStr = tempBtn.titleLabel.text;
        } else {
            [tempBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text != nil || ![textField.text isEqualToString:@""]) {
        
        priceStr = textField.text;
    }
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - positive float
- (BOOL)isPositiveFloat:(NSString*)floatValue
{
    NSString *floatRegex = @"^(?:[1-9][0-9]*(?:\\.[0-9]+)?|0\\.[0-9]+)$";
    NSPredicate *floatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", floatRegex];
    return [floatTest evaluateWithObject:floatValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
