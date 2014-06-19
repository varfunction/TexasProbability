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

- (void)startCalculator:(TPPlayFlow)flow firstTime:(BOOL)firstTime
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@1,@2,@3,@4,@5]];
    NSMutableArray *retArray = [NSMutableArray array];
    NSMutableArray *cretArray = [NSMutableArray array];
    NSLog(@"start111111");
    [self combineData:array toArray:retArray size:array.count count:2 startIndex:0 combineRet:cretArray];
    NSLog(@"%d",retArray.count);
}

- (void)combineData:(NSMutableArray *)srcArray
            toArray:(NSMutableArray *)retArray
               size:(int)size
              count:(int)count
         startIndex:(int)startIndex
         combineRet:(NSMutableArray *)cretArray
{
    if (count == 1) {
        for (int i = startIndex; i < srcArray.count; i++) {
            NSMutableArray *combineArray = [NSMutableArray arrayWithArray:cretArray];
            [combineArray addObject:@(i)];
            [retArray addObject:combineArray];
        }
    } else {
        for (int i = startIndex; i < srcArray.count; i++) {
            if (size == srcArray.count) {
                NSMutableArray *combineArray = [NSMutableArray array];
                [combineArray addObject:@(i)];
                [self combineData:srcArray
                          toArray:retArray
                             size:size-1
                            count:count-1
                       startIndex:i+1
                       combineRet:combineArray];
            } else {
                NSMutableArray *combineArray = [NSMutableArray arrayWithArray:cretArray];
                [combineArray addObject:@(i)];
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
