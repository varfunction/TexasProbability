//
//  TPProbabilityManager.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-10.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPProbabilityManager.h"

@implementation TPProbabilityManager

+ (instancetype)sharedInstance
{
    static TPProbabilityManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[TPProbabilityManager alloc] init];
    });
    
	return instance;
}

- (void)clearAll
{
    self.HJ_TIME = 0;
    self.JG_TIME = 0;
    self.HL_TIME = 0;
    self.TH_TIME = 0;
    self.SZ_TIME = 0;
    self.ST_TIME = 0;
    self.LD_TIME = 0;
    self.DD_TIME = 0;
    self.GP_TIME = 0;
    
    self.HJ_PB = .0f;
    self.JG_PB = .0f;
    self.HL_PB = .0f;
    self.TH_PB = .0f;
    self.SZ_PB = .0f;
    self.ST_PB = .0f;
    self.LD_PB = .0f;
    self.DD_PB = .0f;
    self.GP_PB = .0f;
}

- (void)startCalculator:(TPPlayFlow)flow firstTime:(BOOL)firstTime
{
    [self clearAll];
    
    if (flow == TPPlayFlow_OpenHand) {
        [self calculateOpenHand];
    } else if (flow == TPPlayFlow_Flop) {
        [self calculateFlop];
    } else if (flow == TPPlayFlow_Turn) {
        [self calculateTurn];
    } else if (flow == TPPlayFlow_River) {
        [self calculateRiver];
    }
    
    // 通知controller层
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_PB_RESULT
                                                        object:self
                                                      userInfo:nil];

}

- (void)calculateOpenHand
{
    NSArray *cardArray = [NSArray array];
    NSMutableArray *allCombineRet = [NSMutableArray array];
    NSMutableArray *combineRet = [NSMutableArray array];
    
    
    TPCard *closeCard_1 = [TPCardParseManager sharedInstance].closeCard_1;
    TPCard *closeCard_2 = [TPCardParseManager sharedInstance].closeCard_2;
    cardArray = [self buildCardArrayWithout:@[closeCard_1, closeCard_2]];
    
    int count = 3;
    [self combineData:cardArray toArray:allCombineRet size:cardArray.count count:count startIndex:0 combineRet:combineRet];
     NSLog(@"combine:%d,%d=%d", cardArray.count, count, allCombineRet.count);
    
    for (NSMutableArray *combineRet in allCombineRet) {
        [combineRet addObject:closeCard_1];
        [combineRet addObject:closeCard_2];
        
        TPCardPower power = [[TPCardParseManager sharedInstance] parseCard:combineRet];
        [self saveParseResult:power current:NO];
    }
    
    [self calculatePB:allCombineRet.count];
}

- (void)calculateFlop
{
    NSArray *cardArray = [NSArray array];
    NSMutableArray *allCombineRet = [NSMutableArray array];
    NSMutableArray *combineRet = [NSMutableArray array];
    
    TPCard *closeCard_1 = [TPCardParseManager sharedInstance].closeCard_1;
    TPCard *closeCard_2 = [TPCardParseManager sharedInstance].closeCard_2;
    
    TPCard *openCard_1 = [TPCardParseManager sharedInstance].openCard_1;
    TPCard *openCard_2 = [TPCardParseManager sharedInstance].openCard_2;
    TPCard *openCard_3 = [TPCardParseManager sharedInstance].openCard_3;
    
    cardArray = [self buildCardArrayWithout:@[closeCard_1, closeCard_2, openCard_1, openCard_2, openCard_3]];
    
    int count = 1;
    [self combineData:cardArray toArray:allCombineRet size:cardArray.count count:count startIndex:0 combineRet:combineRet];
    NSLog(@"combine:%d,%d=%d", cardArray.count, count, allCombineRet.count);
    
    for (NSMutableArray *combineRet in allCombineRet) {
        [combineRet addObject:closeCard_1];
        [combineRet addObject:closeCard_2];
        [combineRet addObject:openCard_1];
        [combineRet addObject:openCard_2];
        [combineRet addObject:openCard_3];
        
        NSArray *cardArray2 = [NSArray arrayWithArray:combineRet];
        NSMutableArray *allCombineRet2 = [NSMutableArray array];
        NSMutableArray *combineRet2 = [NSMutableArray array];
        [self combineData:cardArray2 toArray:allCombineRet2 size:cardArray2.count count:5 startIndex:0 combineRet:combineRet2];
        
        TPCardPower power = 0;
        for (NSMutableArray *combineRet2 in allCombineRet2) {
            power = power | [[TPCardParseManager sharedInstance] parseCard:combineRet2];
        }
        
        [self saveParseResult:power current:NO];
        
    }
    
    [self calculatePB:allCombineRet.count];
    
    NSArray *currentArray = @[closeCard_1, closeCard_2, openCard_1, openCard_2, openCard_3];
    TPCardPower power = [[TPCardParseManager sharedInstance] parseCard:currentArray];
    [self saveParseResult:power current:YES];
}

- (void)calculateTurn
{
    NSArray *cardArray = [NSArray array];
    NSMutableArray *allCombineRet = [NSMutableArray array];
    NSMutableArray *combineRet = [NSMutableArray array];
    
    
    
    TPCard *closeCard_1 = [TPCardParseManager sharedInstance].closeCard_1;
    TPCard *closeCard_2 = [TPCardParseManager sharedInstance].closeCard_2;
    
    TPCard *openCard_1 = [TPCardParseManager sharedInstance].openCard_1;
    TPCard *openCard_2 = [TPCardParseManager sharedInstance].openCard_2;
    TPCard *openCard_3 = [TPCardParseManager sharedInstance].openCard_3;
    TPCard *openCard_4 = [TPCardParseManager sharedInstance].openCard_4;
    
    cardArray = [self buildCardArrayWithout:@[closeCard_1, closeCard_2, openCard_1, openCard_2, openCard_3, openCard_4]];
    
    int count = 1;
    [self combineData:cardArray toArray:allCombineRet size:cardArray.count count:count startIndex:0 combineRet:combineRet];
    NSLog(@"combine:%d,%d=%d", cardArray.count, count, allCombineRet.count);
    
    for (NSMutableArray *combineRet in allCombineRet) {
        [combineRet addObject:closeCard_1];
        [combineRet addObject:closeCard_2];
        [combineRet addObject:openCard_1];
        [combineRet addObject:openCard_2];
        [combineRet addObject:openCard_3];
        [combineRet addObject:openCard_4];
        
        NSArray *cardArray2 = [NSArray arrayWithArray:combineRet];
        NSMutableArray *allCombineRet2 = [NSMutableArray array];
        NSMutableArray *combineRet2 = [NSMutableArray array];
        [self combineData:cardArray2 toArray:allCombineRet2 size:cardArray2.count count:5 startIndex:0 combineRet:combineRet2];
        
        TPCardPower power = 0;
        for (NSMutableArray *combineRet2 in allCombineRet2) {
            power = power | [[TPCardParseManager sharedInstance] parseCard:combineRet2];
        }
        
        [self saveParseResult:power current:NO];
    }
    
    [self calculatePB:allCombineRet.count];
    
    
    NSArray *currentArray = @[closeCard_1, closeCard_2, openCard_1, openCard_2, openCard_3, openCard_4];
    NSArray *cardArray3 = [NSArray arrayWithArray:currentArray];
    NSMutableArray *allCombineRet3 = [NSMutableArray array];
    NSMutableArray *combineRet3 = [NSMutableArray array];
    [self combineData:cardArray3 toArray:allCombineRet3 size:cardArray3.count count:5 startIndex:0 combineRet:combineRet3];
    
    for (NSMutableArray *combineRet3 in allCombineRet3) {
        TPCardPower power = [[TPCardParseManager sharedInstance] parseCard:combineRet3];
        [self saveParseResult:power current:YES];
    }
}

- (void)calculateRiver
{
    TPCard *closeCard_1 = [TPCardParseManager sharedInstance].closeCard_1;
    TPCard *closeCard_2 = [TPCardParseManager sharedInstance].closeCard_2;
    
    TPCard *openCard_1 = [TPCardParseManager sharedInstance].openCard_1;
    TPCard *openCard_2 = [TPCardParseManager sharedInstance].openCard_2;
    TPCard *openCard_3 = [TPCardParseManager sharedInstance].openCard_3;
    TPCard *openCard_4 = [TPCardParseManager sharedInstance].openCard_4;
    TPCard *openCard_5 = [TPCardParseManager sharedInstance].openCard_5;
    
    NSArray *cardArray = @[closeCard_1, closeCard_2, openCard_1, openCard_2, openCard_3, openCard_4, openCard_5];
    NSMutableArray *allCombineRet = [NSMutableArray array];
    NSMutableArray *combineRet = [NSMutableArray array];
    [self combineData:cardArray toArray:allCombineRet size:cardArray.count count:5 startIndex:0 combineRet:combineRet];
    
    for (NSMutableArray *combineRet in allCombineRet) {
        TPCardPower power = [[TPCardParseManager sharedInstance] parseCard:combineRet];
        [self saveParseResult:power current:YES];
    }
}

- (void)saveParseResult:(TPCardPower)power current:(BOOL)current
{
    if ((power | TPCardPower_HJ) == power) {
        self.HJ_TIME ++;
        self.HJ_PB = (current == YES) ? 1.0f : self.HJ_PB;
    }
    
    if ((power | TPCardPower_JG) == power) {
        self.JG_TIME ++;
        self.JG_PB = (current == YES) ? 1.0f : self.JG_PB;
    }
    
    if ((power | TPCardPower_HL) == power) {
        self.HL_TIME ++;
        self.HL_PB = (current == YES) ? 1.0f : self.HL_PB;
    }
    
    if ((power | TPCardPower_TH) == power) {
        self.TH_TIME ++;
        self.TH_PB = (current == YES) ? 1.0f : self.TH_PB;
    }
    
    if ((power | TPCardPower_SZ) == power) {
        self.SZ_TIME ++;
        self.SZ_PB = (current == YES) ? 1.0f : self.SZ_PB;
    }
    
    if ((power | TPCardPower_ST) == power) {
        self.ST_TIME ++;
        self.ST_PB = (current == YES) ? 1.0f : self.ST_PB;
    }
    
    if ((power | TPCardPower_LD) == power) {
        self.LD_TIME ++;
        self.LD_PB = (current == YES) ? 1.0f : self.LD_PB;
    }
    
    if ((power | TPCardPower_DD) == power) {
        self.DD_TIME ++;
        self.DD_PB = (current == YES) ? 1.0f : self.DD_PB;
    }
    
    if ((power | TPCardPower_GP) == power) {
        self.GP_TIME ++;
        self.GP_PB = (current == YES) ? 1.0f : self.GP_PB;
    }
}

- (void)calculatePB:(int)totalCombine
{
    double totalCombinef = [[NSNumber numberWithInt:totalCombine] doubleValue];
    self.HJ_PB = self.HJ_TIME / totalCombinef;
    self.JG_PB = self.JG_TIME / totalCombinef;
    self.HL_PB = self.HL_TIME / totalCombinef;
    self.TH_PB = self.TH_TIME / totalCombinef;
    self.SZ_PB = self.SZ_TIME / totalCombinef;
    self.ST_PB = self.ST_TIME / totalCombinef;
    self.LD_PB = self.LD_TIME / totalCombinef;
    self.DD_PB = self.DD_TIME / totalCombinef;
    self.GP_PB = self.GP_TIME / totalCombinef;
}

- (NSArray *)buildCardArrayWithout:(NSArray *)selectedArray
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        TPCardType type = i;
        for (int j = 1; j <= 13; j++) {
            int value = j;
            TPCard *card = [[TPCard alloc] init];
            card.cardType = type;
            card.cardValue = value;
            [array addObject:card];
        }
    }
    
    
    NSArray *copyArray = [array copy];
    for (TPCard *card in copyArray) {
        for (TPCard *selectedCard in selectedArray) {
            if (card.cardType == selectedCard.cardType
                && card.cardValue == selectedCard.cardValue) {
                [array removeObject:card];
            }
        }
    }
    
    return array;
}


- (void)combineData:(NSArray *)srcArray
            toArray:(NSMutableArray *)retArray
               size:(int)size
              count:(int)count
         startIndex:(int)startIndex
         combineRet:(NSMutableArray *)cretArray
{
    if (count == 1) {
        for (int i = startIndex; i < srcArray.count; i++) {
            NSMutableArray *combineArray = [NSMutableArray arrayWithArray:cretArray];
            TPCard *card = [srcArray objectAtIndex:i];
            [combineArray addObject:card];
            [retArray addObject:combineArray];
        }
    } else {
        for (int i = startIndex; i < srcArray.count; i++) {
            if (size == srcArray.count) {
                NSMutableArray *combineArray = [NSMutableArray array];
                TPCard *card = [srcArray objectAtIndex:i];
                [combineArray addObject:card];
                [self combineData:srcArray
                          toArray:retArray
                             size:size-1
                            count:count-1
                       startIndex:i+1
                       combineRet:combineArray];
            } else {
                NSMutableArray *combineArray = [NSMutableArray arrayWithArray:cretArray];
                TPCard *card = [srcArray objectAtIndex:i];
                [combineArray addObject:card];
                [self combineData:srcArray
                          toArray:retArray
                             size:size-1
                            count:count-1
                       startIndex:i+1
                       combineRet:combineArray];
            }
        }
    }
}

@end
