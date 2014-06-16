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
    TPCardPower_HJ = 0,     // 同花顺
    TPCardPower_JG = 1,     // 金刚
    TPCardPower_HL = 2,     // 葫芦
    TPCardPower_TH = 3,     // 同花
    TPCardPower_SZ = 4,     // 顺子
    TPCardPower_ST = 5,     // 三条
    TPCardPower_LD = 6,     // 两对
    TPCardPower_DD = 7,     // 单对
    TPCardPower_GP = 8,     // 高牌
};

@interface TPCard : NSObject

// 是否已读
@property (nonatomic, assign) TPCardType cardType;
// 是否已申请
@property (nonatomic, assign) BOOL cardValue;  // 1-13

@end

@interface TPCardParseManager : NSObject

+ (instancetype)sharedInstance;

- (TPCardPower)parseCard:(NSArray *)cardArray;

@end
