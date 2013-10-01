//
//  ScoresManager.h
//  Matchismo
//
//  Created by Floyd Christofoli on 9/28/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameScore;

@interface ScoresManager : NSObject

+ (ScoresManager*)sharedInstance;

- (void)addScore:(GameScore*)score;
- (NSArray*)getTopScores;
+ (GameScore*)getHighScore:(NSArray*)scores;
+ (GameScore*)getLowScore:(NSArray*)scores;

@end
