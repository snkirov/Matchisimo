// Copyright (c) 2022 Lightricks. All rights reserved.
// Created by Svilen Kirov.

#import "HistoryViewController.h"
#import <UIKit/NSAttributedString.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@property (nonatomic) BOOL shouldShowAttributed;
@property (nonatomic, strong) NSString *history;
@property (nonatomic, strong) NSMutableAttributedString *attributedHistory;
@end

@implementation HistoryViewController

- (void)setupWithAttributedHistory:(NSMutableAttributedString *)attributedHistory {
  _shouldShowAttributed = true;
  _attributedHistory = attributedHistory;
  NSRange range;
  range.length = _attributedHistory.length;
  range.location = 0;
  auto paragraph = [[NSMutableParagraphStyle alloc] init];
  [paragraph setAlignment:NSTextAlignmentCenter];
  auto attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18],
                      NSParagraphStyleAttributeName: paragraph};
  [_attributedHistory addAttributes:attributes range:range];
}

- (void)setupWithHistory:(NSString *)history {
  _shouldShowAttributed = false;
  _history = history;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (_shouldShowAttributed) {
    [self loadAttributedHistory];
  } else {
    [self loadHistory];
  }
}

- (void)loadHistory {
  if ([_history isEqualToString:@""]) {
    _historyTextView.text = @"No history to show.";
  } else {
    _historyTextView.text = _history;
  }
}

- (void)loadAttributedHistory {
  if ([_attributedHistory.string isEqualToString:@""]) {
    _historyTextView.text = @"No history to show.";
  } else {
    [_historyTextView setAttributedText:_attributedHistory];
  }
}
@end

NS_ASSUME_NONNULL_END
