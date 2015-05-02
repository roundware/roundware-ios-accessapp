#import "MagicTapCenter.h"

static MagicTapCenter *_magicTapCenter;

@interface MagicTapCenter()
@property (nonatomic) NSMutableArray *observers;
@end

@implementation MagicTapCenter

+ (MagicTapCenter *)sharedInstance {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    _magicTapCenter = [[MagicTapCenter alloc] init];
  });

  return _magicTapCenter;
}

- (instancetype)init {
  if (self = [super init]) {
    self.observers = [[NSMutableArray alloc] init];
  }

  return self;
}

- (void)registerObserver:(id<MagicTapProtocol>)observer {
  [self.observers addObject:observer];

  [self.observers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    id<MagicTapProtocol> lhs = (id<MagicTapProtocol>)obj1;
    id<MagicTapProtocol> rhs = (id<MagicTapProtocol>)obj2;
    if ([lhs magicTapPriority] > [rhs magicTapPriority]) {
      return NSOrderedAscending;
    } else if ([lhs magicTapPriority] < [rhs magicTapPriority]) {
      return NSOrderedDescending;
    }
    return NSOrderedSame;
  }];
}

- (void)deRegisterObserver:(id<MagicTapProtocol>)observer {
  [self.observers removeObject:observer];
}

- (BOOL)execute {
  for (id<MagicTapProtocol> o in self.observers) {
    if ([o magicTapPause]) {
      return YES;
    }
  }

  for (id<MagicTapProtocol> o in self.observers) {
    if ([o magicTapStart]) {
      return YES;
    }
  }

  return NO;
}

@end
