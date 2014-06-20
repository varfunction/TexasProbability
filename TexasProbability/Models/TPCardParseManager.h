//
//  TPCardParseManager.h
//  TexasProbability
//
//  Created by ocean tang on 14-6-16.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TPCardType) {
    TPCardType_spade = 0,    // 黑桃
    TPCardType_heart = 1,    // 红桃
    TPCardType_club = 2,     // 梅花
    TPCardType_diamond = 3,  // 方块
};

typedef NS_ENUM(NSInteger, TPCardPower) {
    TPCardPower_HJ = 1<<1,     // 同花顺
    TPCardPower_JG = 1<<2,     // 金刚
    TPCardPower_HL = 1<<3,     // 葫芦
    TPCardPower_TH = 1<<4,     // 同花
    TPCardPower_SZ = 1<<5,     // 顺子
    TPCardPower_ST = 1<<6,     // 三条
    TPCardPower_LD = 1<<7,     // 两对
    TPCardPower_DD = 1<<8,     // 单对
    TPCardPower_GP = 1<<9,     // 高牌
};


typedef NS_ENUM(NSInteger, TPPlayFlow) {
    TPPlayFlow_Nothing = 0,
    TPPlayFlow_OpenHand = 1,    // 起手牌
    TPPlayFlow_Flop = 2,        // 看盘圈
    TPPlayFlow_Turn = 3,        // 转牌圈
    TPPlayFlow_River = 4,       // 河牌圈
};

@interface TPCard : NSObject

// 是否已读
@property (nonatomic, assign) TPCardType cardType;
// 是否已申请
@property (nonatomic, assign) int cardValue;  // 1-13

@end

@interface TPCardParseManager : NSObject

@property (nonatomic, strong) TPCard *openCard_1;
@property (nonatomic, strong) TPCard *openCard_2;
@property (nonatomic, strong) TPCard *openCard_3;
@property (nonatomic, strong) TPCard *openCard_4;
@property (nonatomic, strong) TPCard *openCard_5;

@property (nonatomic, strong) TPCard *closeCard_1;
@property (nonatomic, strong) TPCard *closeCard_2;

+ (instancetype)sharedInstance;

- (void)clearAllCard;

- (TPCardPower)parseCard:(NSArray *)cardArray;

@end
