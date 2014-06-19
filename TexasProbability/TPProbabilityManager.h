//
//  TPProbabilityManager.h
//  TexasProbability
//
//  Created by ocean tang on 14-6-10.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPCardParseManager.h"



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

+ (instancetype)sharedInstance;

- (void)startCalculator:(TPPlayFlow)flow firstTime:(BOOL)firstTime;

@end
