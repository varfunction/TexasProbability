//
//  TPViewController.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-9.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPViewController.h"
#import "TPProbabilityManager.h"
#import "AboutViewController.h"

typedef NS_ENUM(NSInteger, TPPlayFlow) {
    TPPlayFlow_OpenHand = 0,    // 起手牌
    TPPlayFlow_Flop = 1,        // 看盘圈
    TPPlayFlow_Turn = 2,        // 转牌圈
    TPPlayFlow_River = 3,       // 河牌圈
};

@interface TPViewController ()
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardKind;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardValue;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *openCardArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *closedCardArray;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic, strong) AboutViewController *ab;

@property (strong, nonatomic) UIButton *modifyCard;

@property (assign, nonatomic) TPPlayFlow currentFlow;

@end

@implementation TPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ab = [AboutViewController instance];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.cardValue.frame), CGRectGetHeight(self.scrollView.frame));
    CGColorRef borderColor = [[UIColor colorWithRed:78/255.0 green:51/255.0 blue:28/255.0 alpha:1] CGColor];
    
    self.currentFlow = TPPlayFlow_OpenHand;
    
    [self.resultView.layer setMasksToBounds:YES];
    [self.resultView.layer setCornerRadius:5.0]; //设置矩圆角半径
    [self.resultView.layer setBorderWidth:1.0];   //边框宽度
    [self.resultView.layer setBorderColor:borderColor];//边框颜色
    
    for (UIButton *btn in self.openCardArray) {
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn.layer setBorderColor:borderColor];//边框颜色
        
        [btn setTitle:@"?" forState:UIControlStateNormal];
    }
    
    for (UIButton *btn in self.closedCardArray) {
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn.layer setBorderColor:borderColor];//边框颜色
        
        [btn setTitle:@"?" forState:UIControlStateNormal];
    }
    
    self.cardKind.hidden = YES;
    self.scrollView.hidden = YES;
    
    [self.cancelBtn.layer setMasksToBounds:YES];
    [self.cancelBtn.layer setCornerRadius:5.0]; //设置矩圆角半径
    [self.cancelBtn.layer setBorderWidth:1.0];   //边框宽度
    [self.cancelBtn.layer setBorderColor:borderColor];//边框颜色
    
    [self.acceptBtn.layer setMasksToBounds:YES];
    [self.acceptBtn.layer setCornerRadius:5.0]; //设置矩圆角半径
    [self.acceptBtn.layer setBorderWidth:1.0];   //边框宽度
    [self.acceptBtn.layer setBorderColor:borderColor];//边框颜色
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.view addSubview:_ab.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickOpenCard:(UIButton *)sender {
    self.cardKind.hidden = NO;
    self.scrollView.hidden = NO;
    self.modifyCard = sender;
}

- (IBAction)clickCloseCard:(UIButton *)sender {
    self.cardKind.hidden = NO;
    self.scrollView.hidden = NO;
    self.modifyCard = sender;
}

- (IBAction)clickAccept:(id)sender {
    
    NSString *title = [NSString stringWithFormat:@"%@%@",
                       [self.cardKind titleForSegmentAtIndex:self.cardKind.selectedSegmentIndex],
                       [self.cardValue titleForSegmentAtIndex:self.cardValue.selectedSegmentIndex]];

    if (![self isSelectedCard:title]) {
        [self.modifyCard setTitle:title forState:UIControlStateNormal];
        self.cardKind.hidden = YES;
        self.scrollView.hidden = YES;
    }
    
    if ([self needStartCalculator]) {
        
    }
}
- (IBAction)clickCancel:(id)sender {
    for (UIButton *btn in self.openCardArray) {
        [btn setTitle:@"?" forState:UIControlStateNormal];
    }
    
    for (UIButton *btn in self.closedCardArray) {
        [btn setTitle:@"?" forState:UIControlStateNormal];
    }
    
    self.cardKind.hidden = YES;
    self.scrollView.hidden = YES;
}

- (BOOL)isSelectedCard:(NSString *)title
{
    for (UIButton *btn in self.openCardArray) {
        if ([btn.currentTitle isEqualToString:title]) {
            return YES;
        }
    }
    
    for (UIButton *btn in self.closedCardArray) {
        if ([btn.currentTitle isEqualToString:title]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)needStartCalculator
{
    for (UIButton *btn in self.openCardArray) {
        
    }
    
    for (UIButton *btn in self.closedCardArray) {
        
    }
    return NO;
}

@end
