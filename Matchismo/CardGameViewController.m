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

#define CARD_BACK_IMAGE (@"volition-company-logo.jpg")

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (void)resetGame
{
    self.flipCount = 0;
    _game = nil;
}

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
        [cardButton setImage:card.isFaceUp ? nil:[UIImage imageNamed:CARD_BACK_IMAGE] forState:UIControlStateNormal];
    }

    switch (self.game.lastFlipResult) {
        case CARD_MATCHING_GAME_STATUS_FLIPPED:
            self.resultsLabel.text = [NSString stringWithFormat:@"Flipped up %@", [self.game.lastPlayedCards componentsJoinedByString:@" and "]];
            break;
        case CARD_MATCHING_GAME_STATUS_MISMATCH:
            self.resultsLabel.text = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", [self.game.lastPlayedCards componentsJoinedByString:@" and "], self.game.lastFlipScore];
            break;
        case CARD_MATCHING_GAME_STATUS_MATCH:
            self.resultsLabel.text = [NSString stringWithFormat:@"Matched %@ for %d points", [self.game.lastPlayedCards componentsJoinedByString:@" and "], self.game.lastFlipScore];
            break;
        default:
            self.resultsLabel.text = @"Time to match some cards!";
            break;
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)dealButtonTapped:(id)sender
{
    [self resetGame];
    [self updateUI];
}

@end
