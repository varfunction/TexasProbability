//
//  TPViewController.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-9.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPViewController.h"
#import "TPProbabilityManager.h"
#import "TPCardParseManager.h"
#import "AboutViewController.h"

@interface TPViewController ()
@property (weak, nonatomic) IBOutlet UIView *resultView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *cardKind;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *cardValue;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *openCardArray;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *closedCardArray;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *openCard_1;
@property (weak, nonatomic) IBOutlet UIButton *openCard_2;
@property (weak, nonatomic) IBOutlet UIButton *openCard_3;
@property (weak, nonatomic) IBOutlet UIButton *openCard_4;
@property (weak, nonatomic) IBOutlet UIButton *openCard_5;
@property (weak, nonatomic) IBOutlet UIButton *closeCard_1;
@property (weak, nonatomic) IBOutlet UIButton *closeCard_2;

@property (nonatomic, strong) AboutViewController *ab;

@property (strong, nonatomic) UIButton *modifyCard;

@end

@implementation TPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.ab = [AboutViewController instance];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.cardValue.frame), CGRectGetHeight(self.scrollView.frame));
    CGColorRef borderColor = [[UIColor colorWithRed:78/255.0 green:51/255.0 blue:28/255.0 alpha:1] CGColor];
    
    [self.resultView.layer setMasksToBounds:YES];
    [self.resultView.layer setCornerRadius:5.0]; //设置矩圆角半径
    [self.resultView.layer setBorderWidth:1.0];   //边框宽度
    [self.resultView.layer setBorderColor:borderColor];//边框颜色
    
    for (UIButton *btn in self.openCardArray) {
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn.layer setBorderColor:borderColor];//边框颜色
        
        [btn setTitle:CARD_TYPE_STR_INIT forState:UIControlStateNormal];
    }
    
    for (UIButton *btn in self.closedCardArray) {
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0]; //设置矩圆角半径
        [btn.layer setBorderWidth:1.0];   //边框宽度
        [btn.layer setBorderColor:borderColor];//边框颜色
        
        [btn setTitle:CARD_TYPE_STR_INIT forState:UIControlStateNormal];
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


- (IBAction)touchCard:(UIButton *)sender {
    self.cardKind.hidden = NO;
    self.scrollView.hidden = NO;
    self.modifyCard = sender;
}

- (IBAction)clickAccept:(id)sender {
    TPCardType type = [self getCardType:[self.cardKind titleForSegmentAtIndex:self.cardKind.selectedSegmentIndex]];
    int value = [self getCardValue:[self.cardValue titleForSegmentAtIndex:self.cardValue.selectedSegmentIndex]];
    
    NSString *title = [NSString stringWithFormat:@"%@%@",
                       [self.cardKind titleForSegmentAtIndex:self.cardKind.selectedSegmentIndex],
                       [self.cardValue titleForSegmentAtIndex:self.cardValue.selectedSegmentIndex]];

    if (![self isSelectedCard:title]) {
        // 没有被选过的牌
        BOOL isFirstTimeSet = [[self.modifyCard titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT];
        [self.modifyCard setTitle:title forState:UIControlStateNormal];
        self.cardKind.hidden = YES;
        self.scrollView.hidden = YES;
        
        [self saveCard:self.modifyCard withType:type value:value];
        
        TPPlayFlow flow = [self getCurrentPlayFlow];
        if (flow != TPPlayFlow_Nothing) {
            [TPHud showLoading:@"紧张计算中。。。"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                [[TPProbabilityManager sharedInstance] startCalculator:flow firstTime:isFirstTimeSet];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [TPHud hide];
                });
            });
        }
    }
}

- (IBAction)clickCancel:(id)sender {
    for (UIButton *btn in self.openCardArray) {
        [btn setTitle:CARD_TYPE_STR_INIT forState:UIControlStateNormal];
    }
    
    for (UIButton *btn in self.closedCardArray) {
        [btn setTitle:CARD_TYPE_STR_INIT forState:UIControlStateNormal];
    }
    
    self.cardKind.hidden = YES;
    self.scrollView.hidden = YES;
    
    [[TPCardParseManager sharedInstance] clearAllCard];
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

- (void)saveCard:(UIButton *)btn
        withType:(TPCardType)type
           value:(int)value
{
    TPCard *card = [[TPCard alloc] init];
    card.cardType = type;
    card.cardValue = value;
    if (btn == self.closeCard_1) {
        [TPCardParseManager sharedInstance].closeCard_1 = card;
    } else if (btn == self.closeCard_2) {
        [TPCardParseManager sharedInstance].closeCard_2 = card;
    } else if (btn == self.openCard_1) {
        [TPCardParseManager sharedInstance].openCard_1 = card;
    } else if (btn == self.openCard_2) {
        [TPCardParseManager sharedInstance].openCard_2 = card;
    } else if (btn == self.openCard_3) {
        [TPCardParseManager sharedInstance].openCard_3 = card;
    } else if (btn == self.openCard_4) {
        [TPCardParseManager sharedInstance].openCard_4 = card;
    } else if (btn == self.openCard_5) {
        [TPCardParseManager sharedInstance].openCard_5 = card;
    } else {
        NSLog(@"er...");
    }
}

- (TPCardType)getCardType:(NSString *)typeStr
{
    TPCardType type;
    if ([typeStr isEqualToString:CARD_TYPE_STR_SPADE]) {
        type = TPCardType_spade;
    } else if ([typeStr isEqualToString:CARD_TYPE_STR_HEART]) {
        type = TPCardType_heart;
    } else if ([typeStr isEqualToString:CARD_TYPE_STR_CLUB]) {
        type = TPCardType_club;
    } else {
        type = TPCardType_diamond;
    }
    return type;
}

- (int)getCardValue:(NSString *)valueStr
{
    int value = 0;
    if ([valueStr isEqualToString:@"A"]) {
        value = 1;
    } else if ([valueStr isEqualToString:@"K"]) {
        value = 13;
    } else if ([valueStr isEqualToString:@"Q"]) {
        value = 12;
    } else if ([valueStr isEqualToString:@"J"]) {
        value = 11;
    } else {
        value = [valueStr intValue];
    }
    return value;
}

- (TPPlayFlow)getCurrentPlayFlow
{
    int count = [self selectedCardCount];
    if (count == 7 && [self HasRiverValue] && [self HasTurnValue] && [self HasFlopValue] && [self HasOpenHandValue]) {
        return TPPlayFlow_River;
    } else if (count == 6 && [self HasTurnValue] && [self HasFlopValue] && [self HasOpenHandValue]) {
        return TPPlayFlow_Turn;
    } else if (count == 5 && [self HasFlopValue] && [self HasOpenHandValue]) {
        return TPPlayFlow_Flop;
    } else if (count == 2 && [self HasOpenHandValue]) {
        return TPPlayFlow_OpenHand;
    } else {
        return TPPlayFlow_Nothing;
    }
}

- (BOOL)HasRiverValue
{
    return ![[self.openCard_5 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT];
}

- (BOOL)HasTurnValue
{
    return ![[self.openCard_4 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT];
}

- (BOOL)HasFlopValue
{
    return ![[self.openCard_3 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT]
        && ![[self.openCard_2 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT]
        && ![[self.openCard_1 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT];
}

- (BOOL)HasOpenHandValue
{
    return ![[self.closeCard_1 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT]
        && ![[self.closeCard_2 titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT];
}

- (int)selectedCardCount
{
    int count = 0;
    
    for (UIButton *btn in self.closedCardArray) {
        if (![[btn titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT]) {
            count++;
        }
    }
    
    for (UIButton *btn in self.openCardArray) {
        if (![[btn titleForState:UIControlStateNormal] isEqualToString:CARD_TYPE_STR_INIT]) {
            count++;
        }
    }
    
    return count;
}

@end
