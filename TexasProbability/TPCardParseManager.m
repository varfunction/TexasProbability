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
    return TPCardPower_HJ;
}

- (BOOL)hasTH:(NSArray *)cardArray
{
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
    return spadeCount == size || heartCount == size || clubCount == size || diamondCount == size;
}

- (BOOL)hasSZ:(NSArray *)cardArray
{
    for (int i = 1; i < cardArray.count; i++) {
        int currentValue = [(TPCard *)cardArray[i] cardValue];
        int prevValue = [(TPCard *)cardArray[i-1] cardValue];
        if (currentValue - prevValue != 1) {
            return NO;
        }
    }
    return YES;
}

@end
