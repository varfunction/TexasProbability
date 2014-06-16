//
//  TPCardParseManager.m
//  TexasProbability
//
//  Created by ocean tang on 14-6-16.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import "TPCardParseManager.h"

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
    return NO;
}

@end
