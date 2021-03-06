//
//
/**
 * Copyright (c) www.bugull.com
 */
//
//

#import "MainVC.h"

@interface MainVC ()

@end

@implementation MainVC

@synthesize titlelab = _titlelab;
@synthesize backButton = _backButton;
@synthesize barView = _barView;


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
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:240.0/255 alpha:1];

    [self addNavgationBarToView];
}




- (void)addNavgationBarToView
{
    self.barView = [[UIView alloc] init];
    self.navigationController.navigationBarHidden = YES;

    self.imageVW =[[UIImageView alloc]initWithImage: [UIImage imageNamed:@"menu_back.png"]] ;
    self.barView.frame = CGRectMake(0, 0, kScreen_Width, barViewHeight);
    self.imageVW.frame = self.barView.frame;
    [self.barView addSubview:self.imageVW];
    self.barView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.barView];

    self.titlelab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20 - iOS_6_height, kScreen_Width - 100, 44)];
    self.titlelab.textColor = [UIColor colorWithRed:65.0/255 green:65.0/255 blue:65.0/255 alpha:1];
    self.titlelab.font = [UIFont systemFontOfSize:17];
    self.titlelab.textColor = [UIColor whiteColor];
    self.titlelab.textAlignment  = NSTextAlignmentCenter;
    self.titlelab.backgroundColor = [UIColor clearColor];
    [self.titlelab setAdjustsFontSizeToFitWidth:YES];
    [self.barView addSubview:self.titlelab];

    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButton.frame = CGRectMake(0, 0, 50, 44);
    if (iOS7 == YES) {
        self.backButton.frame = CGRectMake(0, 20, 50, 44);
    }
    self.backButton.hidden = NO;
    [self.backButton addTarget:self action:@selector(leftButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"return_normal.png"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"return_normal_click.png"] forState:UIControlStateHighlighted];
    [self.barView addSubview:self.backButton];

    self.rightBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBut.frame = CGRectMake(kScreen_Width - 50, barViewHeight - 44, 50, 44);
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"confirm_normal.png"] forState:UIControlStateNormal];
    [self.rightBut setBackgroundImage:[UIImage imageNamed:@"confirm_click.png"] forState:UIControlStateHighlighted];
    [self.rightBut addTarget:self action:@selector(reloadButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.barView addSubview:self.rightBut];
}

- (void)leftButtonMethod:(UIButton *)but
{
    
}

- (void)reloadButtonMethod:(UIButton *)sender
{

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
