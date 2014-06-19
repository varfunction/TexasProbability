//
//  CM.m
//  Rumpetroll
//
//  Created by gamy on 14-6-16.
//  Copyright (c) 2014年 gamy. All rights reserved.
//

#import "Poker.h"

@interface Poker()

@property(nonatomic, assign)NSInteger value;
@property(nonatomic, assign)NSUInteger index;

@end

@implementation Poker

- (NSUInteger)hash
{
    return _value;
}


- (BOOL)isEqual:(id)object
{
    return [self hash] == [object hash];
}


- (instancetype)initWithPattern:(PokerPattern)pattern figure:(NSInteger)figure
{
    self = [super init];
    if (self) {
        //cal _value
        _value = (pattern << 10) + figure;
    }
    return self;
}

+ (instancetype)pokerWithPattern:(PokerPattern)pattern figure:(NSInteger)figure
{
    return [[Poker alloc] initWithPattern:pattern figure:figure];
}


- (PokerPattern)pattern
{
    return (PokerPattern)(_value >> 10);
}

- (NSInteger)figure
{
    return _value & ((0x1<<6) - 1);
}

- (NSComparisonResult)compare:(Poker *)aPoker
{
    if ([self isEqual:aPoker]) {
        return NSOrderedSame;
    }
    if ([aPoker figure] > [self figure]) {
        return NSOrderedAscending;
    }else if([aPoker figure] == [self figure]){
        if ([aPoker pattern] > [self pattern]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }else{
        return NSOrderedDescending;
    }
}

- (NSString *)description
{
    PokerPattern pattern = [self pattern];
    NSInteger figure = [self figure];
    static dispatch_once_t onceToken;
    static NSArray *patternNames = nil;
    static NSArray *figureNames = nil;
    dispatch_once(&onceToken, ^{
//        patternNames = @[@"♢",@"♣", @"♡",@"♠"];
  
        patternNames = @[@"Diamond ",@"Club ", @"Heart ",@"Spade "];

        figureNames = @[@"J",@"Q",@"K"];
    });
//    NSLog(@"pattern = %d", pattern);
    NSString* pn = patternNames[pattern-1];
    NSString* fn = nil;
    if (figure < 11) {
        fn = [NSString stringWithFormat:@"%ld", (long)figure];
    }else if(figure < 14){
        fn = figureNames[figure - 11];
    }else{
        //Error.
    }
    return [pn stringByAppendingString:fn];
}




@end

@implementation PokerAL


- (id)maxValue:(NSArray *)list
{
    return [list lastObject];
}


- (NSArray *)calCombineList:(NSArray *)list combineCount:(NSInteger)combineCount
{
    
    list = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber *)obj1 compare:obj2];
    }];
    
    NSInteger index = 0;
    for (Poker *p in list) {
        p.index = index ++;
    }
    
    NSMutableArray *results = [NSMutableArray array];
    NSMutableArray *openList = [NSMutableArray array];
    
    //init open list, every object is an list.
    for (id obj in list) {
        [openList addObject:[NSMutableArray arrayWithObject:obj]];
    }
    
    while ([openList count] != 0) {
        //pop the first obj.
        NSMutableArray *subList = [openList firstObject];
        [openList removeObjectAtIndex:0];
        
        if ([subList count] == combineCount) {
            [results addObject:subList];
            continue;
        }
        
        //find the start index.
        Poker *maxValue = [self maxValue:subList];
        
        //get start index.
        NSInteger startIndex = [maxValue index] + 1;
//        NSInteger startIndex = [list indexOfObject:maxValue] + 1;

        //cur it
        if (([list count] - startIndex) < (combineCount - [subList count])) {
            continue;
        }
        
        for (NSInteger i = startIndex; i < [list count]; ++ i) {
            id obj = list[i];
            //push very obj into the set, and build a new set.
            NSMutableArray *tempList = [subList mutableCopy];
            [tempList addObject:obj];
            if ([tempList count] == combineCount) {
                [results addObject:tempList];
            }else{
                [openList addObject:tempList];
            }
        }
    }
    return results;
}



@end




@implementation TestModel


- (id)initWithInteger:(NSInteger)value
{
    self = [super initWithInteger:value];
    return self;
}

+ (TestModel *)numberWithInteger:(NSInteger)value
{
    return [[TestModel alloc] initWithInteger:value];
}

-(NSComparisonResult)compare:(NSNumber *)otherNumber
{
    return [super compare:otherNumber];
}


#define OBJ_COUNT 52
#define PK_COUNT 5
- (void)runTest
{
    NSLog(@"start = %ld",time(0));
    NSMutableArray *list = [NSMutableArray array];
    for(NSInteger i = 0; i < OBJ_COUNT; i++)
    {
        PokerPattern pattern = ((i%PokerPatternCount) + 1);
        NSInteger figure = (i % 13) + 1;
        Poker *poker = [Poker pokerWithPattern:pattern figure:figure];
        poker.index = i;
        NSLog(@"poker = %@", [poker description]);
        [list addObject:poker];
    }
    NSArray *results = [[[PokerAL alloc] init] calCombineList:list combineCount:PK_COUNT];
    
//    for (NSArray *l in results) {
//        NSLog(@"l = %@", l);
//    }
    
    NSLog(@"end = %ld",time(0));
    NSLog(@"resultNumber = %lu", (unsigned long)[results count]);
}


@end
