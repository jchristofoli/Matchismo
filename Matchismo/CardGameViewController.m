//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Floyd Christofoli on 4/21/13.
//  Copyright (c) 2013 Floyd Christofoli. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self updateUI];
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }

    switch (self.game.lastFlipResult) {
        case CARD_MATCHING_GAME_STATUS_FLIPPED:
            self.resultsLabel.text = [NSString stringWithFormat:@"Flipped up %@", self.game.lastPlayedCards[0]];
            break;
        case CARD_MATCHING_GAME_STATUS_MISMATCH:
            self.resultsLabel.text = [NSString stringWithFormat:@"%@ and %@ don't match! %d point penalty!", self.game.lastPlayedCards[0], self.game.lastPlayedCards[1], self.game.lastFlipScore];
            break;
        case CARD_MATCHING_GAME_STATUS_MATCH:
            self.resultsLabel.text = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", self.game.lastPlayedCards[0], self.game.lastPlayedCards[1], self.game.lastFlipScore];
            break;
        default:
            self.resultsLabel.text = @"Time to match some cards!";
            break;
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}


@end
