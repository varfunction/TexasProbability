//
//  TPProbabilityManager.h
//  TexasProbability
//
//  Created by ocean tang on 14-6-10.
//  Copyright (c) 2014年 ocean tang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPCardParseManager.h"

#define REFRESH_PB_RESULT @"REFRESH_PB_RESULT"

@interface TPProbabilityManager : NSObject

@property (nonatomic, assign) int HJ_TIME;
@property (nonatomic, assign) int JG_TIME;
@property (nonatomic, assign) int HL_TIME;
@property (nonatomic, assign) int TH_TIME;
@property (nonatomic, assign) int SZ_TIME;
@property (nonatomic, assign) int ST_TIME;
@property (nonatomic, assign) int LD_TIME;
@property (nonatomic, assign) int DD_TIME;
@property (nonatomic, assign) int GP_TIME;

@property (nonatomic, assign) double HJ_PB;
@property (nonatomic, assign) double JG_PB;
@property (nonatomic, assign) double HL_PB;
@property (nonatomic, assign) double TH_PB;
@property (nonatomic, assign) double SZ_PB;
@property (nonatomic, assign) double ST_PB;
@property (nonatomic, assign) double LD_PB;
@property (nonatomic, assign) double DD_PB;
@property (nonatomic, assign) double GP_PB;

@property (nonatomic, assign) double WIN_PB;

+ (instancetype)sharedInstance;

- (void)startCalculator:(TPPlayFlow)flow firstTime:(BOOL)firstTime;

@end
