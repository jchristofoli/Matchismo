//
//  Deck.m
//  Matchismo
//
//  Created by Floyd Christofoli on 4/21/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@interface Deck()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation Deck

@synthesize cards = _cards;

- (NSMutableArray *) getCards
{
    if (_cards == nil)
        _cards = [[NSMutableArray alloc] init];

    return _cards;
}

- (void) addCard:(Card *) card atTop:(BOOL)atTop
{
    if (card != nil)
    {
        if (atTop)
        {
            [self.cards insertObject:card atIndex:0];
        }
        else
        {
            [self.cards addObject:card];
        }
    }
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    if (self.cards.count)
    {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}

@end
