//
//  TPCardParseManager.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-16.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPCardParseManager.h"

@implementation TPCard : NSObject

@end

@implementation TPCardParseManager

+ (instancetype)sharedInstance
{
    static TPCardParseManager *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[TPCardParseManager alloc] init];
    });
    
	return instance;
}

- (void)clearAllCard
{
    self.closeCard_1 = nil;
    self.closeCard_2 = nil;
    self.openCard_1 = nil;
    self.openCard_2 = nil;
    self.openCard_3 = nil;
    self.openCard_4 = nil;
    self.openCard_5 = nil;
}

- (TPCardPower)parseCard:(NSArray *)cardArray
{
    assert(cardArray.count == 5);
    int power = 0;
    NSArray *sortedCardArray = [self sortCard:cardArray];
    
    if ([self hasHJ:sortedCardArray]) {
        power = power | TPCardPower_HJ;
    }
    if ([self hasJG:sortedCardArray]) {
        power = power | TPCardPower_JG;
    }
    if ([self hasHL:sortedCardArray]) {
        power = power | TPCardPower_HL;
    }
    if ([self hasTH:sortedCardArray]) {
        power = power | TPCardPower_TH;
    }
    if ([self hasSZ:sortedCardArray]) {
        power = power | TPCardPower_SZ;
    }
    if ([self hasST:sortedCardArray]) {
        power = power | TPCardPower_ST;
    }
    if ([self hasLD:sortedCardArray]) {
        power = power | TPCardPower_LD;
    }
    if ([self hasDD:sortedCardArray]) {
        power = power | TPCardPower_DD;
    }
    if ([self hasGP:sortedCardArray]) {
        power = power | TPCardPower_GP;
    }
    return power;
}

- (NSArray *)sortCard:(NSArray *)cardArray
{
    NSArray *sortedArray = [cardArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if (![obj1 isKindOfClass:[TPCard class]] || ![obj2 isKindOfClass:[TPCard class]]) {
            return NSOrderedSame;
        }
        
        TPCard *card1 = (TPCard *)obj1;
        TPCard *card2 = (TPCard *)obj2;
        
        if (card1.cardValue > card2.cardValue) {
            return NSOrderedDescending;
        } else if (card1.cardValue < card2.cardValue) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    return sortedArray;
}

- (BOOL)hasHJ:(NSArray *)cardArray
{
    return [self hasTH:cardArray] && [self hasSZ:cardArray];
}

- (BOOL)hasJG:(NSArray *)cardArray
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TPCard *card in cardArray) {
        NSString *cardKey = [NSString stringWithFormat:@"%d", card.cardValue];
        int currentCount = [[dic objectForKey:cardKey] intValue];
        [dic setObject:@(currentCount+1) forKey:cardKey];
    }
    
    int JG_count = 0;
    for (NSString *key in dic) {
        NSNumber *count = [dic objectForKey:key];
        if ([count intValue] >= 4) {
            JG_count++;
        }
    }
    
    return JG_count >= 1;
}

- (BOOL)hasHL:(NSArray *)cardArray
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TPCard *card in cardArray) {
        NSString *cardKey = [NSString stringWithFormat:@"%d", card.cardValue];
        int currentCount = [[dic objectForKey:cardKey] intValue];
        [dic setObject:@(currentCount+1) forKey:cardKey];
    }
    
    int ST_count = 0;
    int DD_count = 0;
    for (NSString *key in dic) {
        NSNumber *count = [dic objectForKey:key];
        if ([count intValue] == 3) {
            ST_count++;
        }
        if ([count intValue] == 2) {
            DD_count++;
        }
    }
    
    return ST_count >= 1 && DD_count >= 1;
}

- (BOOL)hasTH:(NSArray *)cardArray
{
    assert(cardArray.count == 5);
    int spadeCount = 0;
    int heartCount = 0;
    int clubCount = 0;
    int diamondCount = 0;
    for (TPCard *card in cardArray) {
        switch (card.cardType) {
            case TPCardType_spade:
                spadeCount++;
                break;
            case TPCardType_heart:
                heartCount++;
                break;
            case TPCardType_club:
                clubCount++;
                break;
            case TPCardType_diamond:
                diamondCount++;
                break;
            default:
                break;
        }
    }
    int size = cardArray.count;
    BOOL hasTH = (spadeCount == size || heartCount == size || clubCount == size || diamondCount == size);
    return hasTH;
}

// 入参保证是从小到大排列的数组,count == 5
- (BOOL)hasSZ:(NSArray *)cardArray
{
    assert(cardArray.count == 5);
    BOOL hasSZ = NO;
    if ([(TPCard *)cardArray[0] cardValue] == 1) {
        NSMutableArray *copyArray = [NSMutableArray arrayWithArray:[cardArray copy]];
        TPCard *card_14 = [[TPCard alloc] init];
        card_14.cardValue = 14;
        [copyArray removeObjectAtIndex:0];
        [copyArray addObject:card_14];
        
        int delta_1 = [(TPCard *)copyArray[1] cardValue] - [(TPCard *)copyArray[0] cardValue];
        int delta_2 = [(TPCard *)copyArray[2] cardValue] - [(TPCard *)copyArray[1] cardValue];
        int delta_3 = [(TPCard *)copyArray[3] cardValue] - [(TPCard *)copyArray[2] cardValue];
        int delta_4 = [(TPCard *)copyArray[4] cardValue] - [(TPCard *)copyArray[3] cardValue];
        
        hasSZ = (delta_1 == delta_2
                 && delta_2 == delta_3
                 && delta_3 == delta_4
                 && delta_1 == 1);
    }
    
    if (!hasSZ) {
        int delta_1 = [(TPCard *)cardArray[1] cardValue] - [(TPCard *)cardArray[0] cardValue];
        int delta_2 = [(TPCard *)cardArray[2] cardValue] - [(TPCard *)cardArray[1] cardValue];
        int delta_3 = [(TPCard *)cardArray[3] cardValue] - [(TPCard *)cardArray[2] cardValue];
        int delta_4 = [(TPCard *)cardArray[4] cardValue] - [(TPCard *)cardArray[3] cardValue];
        
        hasSZ = (delta_1 == delta_2
                 && delta_2 == delta_3
                 && delta_3 == delta_4
                 && delta_1 == 1);
    }
    
    return hasSZ;
}

- (BOOL)hasST:(NSArray *)cardArray
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TPCard *card in cardArray) {
        NSString *cardKey = [NSString stringWithFormat:@"%d", card.cardValue];
        int currentCount = [[dic objectForKey:cardKey] intValue];
        [dic setObject:@(currentCount+1) forKey:cardKey];
    }
    
    int ST_count = 0;
    for (NSString *key in dic) {
        NSNumber *count = [dic objectForKey:key];
        if ([count intValue] >= 3) {
            ST_count++;
        }
    }
    
    return ST_count >= 1;
}

- (BOOL)hasLD:(NSArray *)cardArray
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TPCard *card in cardArray) {
        NSString *cardKey = [NSString stringWithFormat:@"%d", card.cardValue];
        int currentCount = [[dic objectForKey:cardKey] intValue];
        [dic setObject:@(currentCount+1) forKey:cardKey];
    }
    
    int DD_count = 0;
    for (NSString *key in dic) {
        NSNumber *count = [dic objectForKey:key];
        if ([count intValue] >= 2) {
            DD_count++;
        }
    }
    
    return DD_count >= 2;
}

- (BOOL)hasDD:(NSArray *)cardArray
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (TPCard *card in cardArray) {
        NSString *cardKey = [NSString stringWithFormat:@"%d", card.cardValue];
        int currentCount = [[dic objectForKey:cardKey] intValue];
        [dic setObject:@(currentCount+1) forKey:cardKey];
    }
    
    int DD_count = 0;
    for (NSString *key in dic) {
        NSNumber *count = [dic objectForKey:key];
        if ([count intValue] >= 2) {
            DD_count++;
        }
    }
    
    return DD_count >= 1;
}

- (BOOL)hasGP:(NSArray *)cardArray
{
    return cardArray.count == 5;
}

@end
