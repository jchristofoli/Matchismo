//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Floyd Christofoli on 5/2/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

typedef enum
{
    CARD_MATCHING_GAME_STATUS_INVALID = -1,
    CARD_MATCHING_GAME_STATUS_FLIPPED,
    CARD_MATCHING_GAME_STATUS_MATCH,
    CARD_MATCHING_GAME_STATUS_MISMATCH
} CardMatchingGameFlipResult;

@interface CardMatchingGame : NSObject

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck;
- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;
@property (nonatomic, readonly) int lastFlipScore;
@property (nonatomic, readonly) CardMatchingGameFlipResult lastFlipResult;
@property (nonatomic, retain, readonly) NSArray* lastPlayedCards;

@end
