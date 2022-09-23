// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#ifndef ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___
#define ObjectiveCTesting____FILEBASENAMEASIDENTIFIER_______FILEEXTENSION___

#import "BaseGameViewController.h"

@interface BaseGameViewController ()

/// The `CardMatchingGame` object which handles the game rules and logic.
@property (nonatomic, strong) CardMatchingGame *cardMatchingGame;

/// Sets up the CardMatchingGame object.
/// Each `BaseGameViewController` subclass is responsible for overwritting this method.
- (void)setupCardMatchingGame;
/// Generates a `CardView` object.
/// Each `BaseGameViewController` subclass is responsible for overwritting this method.
- (CardView *)drawCardAndCreateView;
/// Returns the `Card` object from the `CardMatchingGame` for the given `CardView`.
/// Each `BaseGameViewController` subclass is responsible for overwritting this method.
- (Card *)getCardForView:(CardView *)cardView;

@end

#endif
