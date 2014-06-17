//
//  CM.h
//  Rumpetroll
//
//  Created by gamy on 14-6-16.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import <Foundation/Foundation.h>


//Spade 黑桃, heart红心, diamond 红砧, club黑梅

typedef enum{
    PokerPatternDiamond = 0x1,
    PokerPatternClub,
    PokerPatternHeart,
    PokerPatternSpade,
    PokerPatternCount = 4,
}PokerPattern;

@interface Poker : NSObject


- (PokerPattern)pattern;
- (NSInteger)figure;

+ (instancetype)pokerWithPattern:(PokerPattern)pattern figure:(NSInteger)figure;

- (NSComparisonResult)compare:(Poker *)aPoker;

@end

@interface CM : NSObject

- (NSArray *)calCombineList:(NSArray *)list combineCount:(NSInteger)combineCount;

@end


@interface TestModel : NSNumber//<Compairable>

- (void)runTest;

@end
