//
//  CardMatchingGameState.h
//  Matchismo
//
//  Created by Floyd Christofoli on 5/4/13.
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

@interface CardMatchingGameState : NSObject
@property (nonatomic) int score;
@property (nonatomic) int lastFlipScore;
@property (nonatomic) CardMatchingGameFlipResult lastFlipResult;
@property (strong, nonatomic) NSArray* lastPlayedCards;
@property (strong, nonatomic) NSArray* cards;

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck;
- (id)initWithPreviousState:(CardMatchingGameState*)state;

@end
