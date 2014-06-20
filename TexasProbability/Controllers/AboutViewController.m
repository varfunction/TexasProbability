//
//  AboutViewController.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-9.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
- (IBAction)clickMenu:(id)sender;

@end

@implementation AboutViewController

+ (instancetype)instance
{
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AboutViewController"];
}

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(10, 50, 50, 30)];
    [button addTarget:self action:@selector(clickMenu:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor greenColor]forState:UIControlStateNormal];
    [button setTitle:@"Menu" forState:UIControlStateNormal];
    [self.view addSubview:button];
    // Do any additional setup after loading the view.
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

- (IBAction)clickMenu:(id)sender {
//    BOOL needShow = (self.view.frame.origin.x == 0);
//    if (needShow) {
//        UIView *tpView = self.presentingViewController.view;
//        [[[UIApplication sharedApplication] keyWindow] insertSubview:tpView belowSubview:self.view];
//    }
    if (self.view.frame.origin.x == 0) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.center = CGPointMake(320+160 - 80, CGRectGetMidY(self.view.frame));
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.center = CGPointMake(160, CGRectGetMidY(self.view.frame));
        }];
    }
}
@end
