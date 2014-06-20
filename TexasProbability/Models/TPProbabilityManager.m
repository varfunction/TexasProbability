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
}

- (void)startCalculator:(TPPlayFlow)flow firstTime:(BOOL)firstTime
{
    NSArray *cardArray = [NSArray array];
    NSMutableArray *allCombineRet = [NSMutableArray array];
    NSMutableArray *combineRet = [NSMutableArray array];
    int count = 0;
    [self clearAll];
    if (flow == TPPlayFlow_OpenHand) {
        TPCard *closeCard_1 = [TPCardParseManager sharedInstance].closeCard_1;
        TPCard *closeCard_2 = [TPCardParseManager sharedInstance].closeCard_2;
        cardArray = [self buildCardArrayWithout:@[closeCard_1, closeCard_2]];
        count = 3;
        [self combineData:cardArray toArray:allCombineRet size:cardArray.count count:count startIndex:0 combineRet:combineRet];
        for (NSMutableArray *combineRet in allCombineRet) {
            [combineRet addObject:closeCard_1];
            [combineRet addObject:closeCard_2];
            
            TPCardPower power = [[TPCardParseManager sharedInstance] parseCard:combineRet];
            [self saveParseResult:power];
        }
        
        [self calculatePB:allCombineRet.count];
        
    } else {
        
    }
    
    // 通知controller层
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_PB_RESULT
                                                        object:self
                                                      userInfo:nil];
    
    NSLog(@"combine:%d,%d=%d", cardArray.count, count, allCombineRet.count);
    NSLog(@"%d",self.TH_TIME);
    NSLog(@"%d",self.SZ_TIME);
}

- (void)saveParseResult:(TPCardPower)power
{
    if ((power | TPCardPower_HJ) == power) {
        self.HJ_TIME ++;
    }
    
    if ((power | TPCardPower_JG) == power) {
        self.JG_TIME ++;
    }
    
    if ((power | TPCardPower_HL) == power) {
        self.HL_TIME ++;
    }
    
    if ((power | TPCardPower_TH) == power) {
        self.TH_TIME ++;
    }
    
    if ((power | TPCardPower_SZ) == power) {
        self.SZ_TIME ++;
    }
    
    if ((power | TPCardPower_ST) == power) {
        self.ST_TIME ++;
    }
    
    if ((power | TPCardPower_LD) == power) {
        self.LD_TIME ++;
    }
    
    if ((power | TPCardPower_DD) == power) {
        self.DD_TIME ++;
    }
    
    if ((power | TPCardPower_GP) == power) {
        self.GP_TIME ++;
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
