//
//  CardMatchingGameState.m
//  Matchismo
//
//  Created by Floyd Christofoli on 5/4/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardMatchingGameState.h"

@interface CardMatchingGameState()
@end

@implementation CardMatchingGameState

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck
{
    self = [super init];
    
    if (self)
    {
        self.lastFlipResult = CARD_MATCHING_GAME_STATUS_INVALID;
        self.lastFlipScore = 0;
        self.score = 0;

        NSMutableArray *newCards = [[NSMutableArray alloc] initWithCapacity:cardCount];
        for (int i = 0; i < cardCount; ++i)
        {
            Card *card = [deck drawRandomCard];
            if (card != nil)
            {
                newCards[i] = card;
            }
            else
            {
                self = nil;
            }
        }

        self.cards = newCards;
    }
    
    return self;
}

- (id)initWithPreviousState:(CardMatchingGameState*)previousState
{
    self = [super init];
    
    if (self)
    {
        self.lastFlipResult = CARD_MATCHING_GAME_STATUS_INVALID;
        self.lastFlipScore = 0;
        self.lastPlayedCards = nil;
        self.score = previousState.score;

        NSArray* cardsCopy = [[NSArray alloc] initWithArray:previousState.cards copyItems:YES];
        self.cards = cardsCopy;
    }
    
    return self;
}

@end
