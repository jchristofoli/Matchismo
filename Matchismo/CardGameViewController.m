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
#import "GameScore.h"
#import "ScoresManager.h"

#define CARD_BACK_IMAGE (@"card_back_red.jpg")

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UIButton *dealButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (strong, nonatomic) CardMatchingGame *game;
@end

@implementation CardGameViewController

- (void)resetGame
{
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
    self.historySlider.continuous = YES;
    [self.historySlider addTarget:self
               action:@selector(historySliderChanged:)
     forControlEvents:UIControlEventValueChanged];
    
    [self updateUI];
}

-(IBAction)historySliderChanged:(UISlider *)sender
{
    int historyValue = (int)round(self.historySlider.value);
    [self.historySlider setValue:historyValue animated:NO];
    [self.game changeHistoryLocation:historyValue];
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
        cardButton.enabled = !card.isUnplayable && !card.isFaceUp;
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
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.game.historyLocation];
    
    self.historySlider.minimumValue = 0;
    if (self.game.historySize <= 1)
    {
        self.historySlider.enabled = NO;
        self.historySlider.maximumValue = 1;
        self.historySlider.value = 0;
    }
    else
    {
        self.historySlider.enabled = YES;
        self.historySlider.maximumValue = self.game.historySize - 1;
        self.historySlider.value = self.game.historyLocation;
    }
}

- (BOOL) gameIsOver
{
    BOOL allCardsUnplayable = YES;
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        allCardsUnplayable &= card.isUnplayable;
    }
    
    return allCardsUnplayable;
}
- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
    
    if ([self gameIsOver])
    {
        GameScore *score = [[GameScore alloc] init];
        score.endDate = [NSDate date];
        score.score = self.game.score;
        score.flips = self.game.historyLocation;
        
        [[ScoresManager sharedInstance] addScore:score];
    }
}

- (IBAction)dealButtonTapped:(id)sender
{
    [self resetGame];
    [self updateUI];
}

@end
