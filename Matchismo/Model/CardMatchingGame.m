//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Floyd Christofoli on 5/2/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *history;
@property (nonatomic, readonly) CardMatchingGameState *currentGameState;
@property (nonatomic) NSUInteger historyLocation;
@end

@implementation CardMatchingGame

- (NSMutableArray *)history
{
    if (!_history) _history = [[NSMutableArray alloc] init];
    return _history;
}

- (NSUInteger)historySize
{
    return self.history.count;
}

- (int)score
{
    return self.currentGameState.score;
}

- (int)lastFlipScore
{
    return self.currentGameState.lastFlipScore;
}

- (CardMatchingGameFlipResult)lastFlipResult
{
    return self.currentGameState.lastFlipResult;
}

- (NSArray*)lastPlayedCards
{
    return self.currentGameState.lastPlayedCards;
}

- (CardMatchingGameState *)gameStateForHistoryLocation:(int)historyLocation
{
    return historyLocation >= 0 && historyLocation < self.history.count ? self.history[historyLocation]:nil;
}

- (CardMatchingGameState *)currentGameState
{
    return [self gameStateForHistoryLocation:self.historyLocation];
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck
{
    self = [super init];
    
    if (self)
    {
        CardMatchingGameState *newGameState = [[CardMatchingGameState alloc] initWithCardCount:cardCount usingDeck:deck];
        [self.history addObject:newGameState];
        self.historyLocation = 0;
    }
    
    return self;
}

- (BOOL)changeHistoryLocation:(NSUInteger)historyLocation
{
    if (historyLocation <= self.historySize)
    {
        self.historyLocation = historyLocation;
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)saveGameState
{
    if (self.historyLocation < self.history.count - 1)
    {
        [self.history removeObjectsInRange:NSMakeRange(self.historyLocation + 1, self.history.count - self.historyLocation - 1)];
    }
    [self.history addObject:[[CardMatchingGameState alloc] initWithPreviousState:self.history.lastObject]];
    self.historyLocation = self.history.count - 1;
}

#define FLIP_COST (0)
#define MISMATCH_PENALTY (2)
#define MATCH_MULTIPLIER (4)

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    if (card.isFaceUp)
    {
        return;
    }

    [self saveGameState];

    int flipScore = 0;

    card = [self cardAtIndex:index];
    
    if (card == nil)
    {
        return;
    }

    NSMutableArray *playedCards = [[NSMutableArray alloc] init];
    [playedCards addObject:card];

    self.currentGameState.lastFlipResult = CARD_MATCHING_GAME_STATUS_FLIPPED;
    if (card != nil && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            for (Card *otherCard in self.currentGameState.cards)
            {
                if (card != otherCard && otherCard.isFaceUp && !otherCard.isUnplayable)
                {
                    [playedCards addObject:otherCard];

                    int matchScore = [card match:@[otherCard]];
                    if (matchScore > 0)
                    {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        flipScore = matchScore * MATCH_MULTIPLIER;
                        self.currentGameState.lastFlipResult = CARD_MATCHING_GAME_STATUS_MATCH;
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        flipScore -= MISMATCH_PENALTY;
                        self.currentGameState.lastFlipResult = CARD_MATCHING_GAME_STATUS_MISMATCH;
                    }
                }
            }
            
            if (self.historyLocation > 1)
            {
                flipScore -= FLIP_COST;
            }
        }
        card.faceUp = !card.isFaceUp;
    }

    self.currentGameState.score += flipScore;
    self.currentGameState.lastFlipScore = flipScore;
    self.currentGameState.lastPlayedCards = playedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index forGameState:(CardMatchingGameState *)state
{
    return (index < state.cards.count) ? state.cards[index]:nil;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return [self cardAtIndex:index forGameState:self.currentGameState];
}

@end
