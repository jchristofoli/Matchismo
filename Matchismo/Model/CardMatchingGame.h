//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Floyd Christofoli on 5/2/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "CardMatchingGameState.h"

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int lastFlipScore;
@property (nonatomic, readonly) CardMatchingGameFlipResult lastFlipResult;
@property (nonatomic, readonly) NSArray* lastPlayedCards;
@property (nonatomic, readonly) int historyLocation;
@property (nonatomic, readonly) int numFlips;

@end
