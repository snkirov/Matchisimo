// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "HistoryViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (nonatomic) BOOL isFromAttributedString;
@property (nonatomic, strong) NSString *history;
@property (nonatomic, strong) NSAttributedString *attributedHistory;
@end

@implementation HistoryViewController

- (void)setupWithAttributedHistory:(NSAttributedString *)attributedHistory {
  _isFromAttributedString = true;
  _attributedHistory = attributedHistory;
}

- (void)setupWithHistory:(NSString *)history {
  _isFromAttributedString = false;
  _history = history;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!_isFromAttributedString) {
    if ([_history isEqualToString:@""]) {
      _historyTextView.text = @"No history to show.";
    } else {
      _historyTextView.text = _history;
    }
    return;
  }

  if ([_attributedHistory.string isEqualToString:@""]) {
    _historyTextView.text = @"No history to show.";
  } else {
    [_historyTextView setAttributedText:_attributedHistory];
  }

}

@end

NS_ASSUME_NONNULL_END
