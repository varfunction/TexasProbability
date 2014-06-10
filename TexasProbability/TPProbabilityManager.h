//
//  TPProbabilityManager.h
//  TexasProbability
//
//  Created by ocean tang on 14-6-10.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TPCardType) {
    TPCardType_spade = 0,    // 黑桃
    TPCardType_heart = 1,    // 红桃
    TPCardType_club = 2,     // 梅花
    TPCardType_diamond = 3,  // 方块
};

@interface TPCard : NSObject

// 是否已读
@property (nonatomic, assign) TPCardType cardType;
// 是否已申请
@property (nonatomic, assign) BOOL cardValue;  // 1-13

@end

@interface TPProbabilityManager : NSObject

@property (nonatomic, assign) double HJ_PB;
@property (nonatomic, assign) double JG_PB;
@property (nonatomic, assign) double HL_PB;
@property (nonatomic, assign) double TH_PB;
@property (nonatomic, assign) double SZ_PB;
@property (nonatomic, assign) double ST_PB;
@property (nonatomic, assign) double LD_PB;
@property (nonatomic, assign) double GP_PB;

@property (nonatomic, assign) double WIN_PB;

@property (nonatomic, strong) TPCard *openCard1;
@property (nonatomic, strong) TPCard *openCard2;
@property (nonatomic, strong) TPCard *openCard3;
@property (nonatomic, strong) TPCard *openCard4;
@property (nonatomic, strong) TPCard *openCard5;

@property (nonatomic, strong) TPCard *closeCard1;
@property (nonatomic, strong) TPCard *closeCard2;

- (void)startCalculator;

@end
