// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "HistoryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  if (![_history isEqualToString:@""]) {
    _historyTextView.text = _history;
  } else {
    _historyTextView.text = @"No history to show.";
  }

}

@end

NS_ASSUME_NONNULL_END
