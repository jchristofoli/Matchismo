//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Floyd Christofoli on 5/2/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (nonatomic) int lastFlipScore;
@property (nonatomic) CardMatchingGameFlipResult lastFlipResult;
@property (nonatomic, retain) NSArray* lastPlayedCards;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck*)deck
{
    self = [super init];
    
    if (self)
    {
        self.lastFlipResult = CARD_MATCHING_GAME_STATUS_INVALID;

        for (int i = 0; i < cardCount; ++i)
        {
            Card *card = [deck drawRandomCard];
            if (card != nil)
            {
                self.cards[i] = card;
            }
            else
            {
                self = nil;
            }
        }
    }
    
    return self;
}

#define FLIP_COST (1)
#define MISMATCH_PENALTY (2)
#define MATCH_MULTIPLIER (4)

- (void)flipCardAtIndex:(NSUInteger)index
{
    int flipScore = 0;
    Card *card = [self cardAtIndex:index];

    NSMutableArray *playedCards = [[NSMutableArray alloc] init];
    [playedCards addObject:card];

    self.lastFlipResult = CARD_MATCHING_GAME_STATUS_FLIPPED;
    if (card != nil && !card.isUnplayable)
    {
        if (!card.isFaceUp)
        {
            for (Card *otherCard in self.cards)
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
                        self.lastFlipResult = CARD_MATCHING_GAME_STATUS_MATCH;
                    }
                    else
                    {
                        otherCard.faceUp = NO;
                        flipScore -= MISMATCH_PENALTY;
                        self.lastFlipResult = CARD_MATCHING_GAME_STATUS_MISMATCH;
                    }
                }
            }
            flipScore -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }

    self.score += flipScore;
    self.lastFlipScore = flipScore;
    self.lastPlayedCards = playedCards;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index]:nil;
}

@end
