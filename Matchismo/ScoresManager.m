//
//  ScoresManager.m
//  Matchismo
//
//  Created by Floyd Christofoli on 9/28/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "ScoresManager.h"

#import "GameScore.h"

@implementation ScoresManager

+ (ScoresManager*)sharedInstance
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

#define ALL_RESULTS_KEY (@"GAME_RESULTS")

- (void)addScore:(GameScore*)score
{
    NSArray* topScores = [self getTopScores];
    
    NSMutableArray* mutableScores = [NSMutableArray arrayWithArray:topScores];
    [mutableScores addObject:score];

    NSMutableDictionary* results = [[[NSUserDefaults standardUserDefaults]dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (results == nil) results = [[NSMutableDictionary alloc] init];
    results[[score.endDate description]] = [score asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:results forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)getTopScores
{
    NSMutableArray* scores = [[NSMutableArray alloc] init];
    NSDictionary* scoreResults = [[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY];
    for (id key in scoreResults)
    {
        NSDictionary* plist = [scoreResults objectForKey:key];
        GameScore* score = [[GameScore alloc] initFromPropertyList:plist];
        if (score)
            [scores addObject:score];
    }

    return scores;
}

- (GameScore*)getHighScore:(NSArray*)scores
{
    NSArray* sortedScores = [scores sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        GameScore *first = (GameScore*)a;
        GameScore *second = (GameScore*)b;
        
        if (first.score == second.score)
            return first.flips >= second.flips;
        else
            return first.score < second.score;
    }];
    
    return sortedScores[0];
}

@end
