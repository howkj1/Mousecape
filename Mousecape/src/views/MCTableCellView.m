//
//  MCTableCellView.m
//  ;
//
//  Created by Alex Zielenski on 2/10/13.
//  Copyright (c) 2013 Alex Zielenski. All rights reserved.
//

#import "MCTableCellView.h"

@interface MCTableCellView ()
- (void)_initialize;
@end

@implementation MCTableCellView
- (void)_initialize {
}

- (id)init {
    if ((self = [super init])) {
        [self _initialize];
    }
    return self;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initialize];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        [self _initialize];
    }
    return self;
}

- (void)viewDidMoveToWindow {
    __weak MCTableCellView *weakSelf = self;
    
    RAC(self.cursorLine.dataSource) = [RACSignal return:self];
    weakSelf.appliedView.hidden = !weakSelf.applied;

    [RACAble(self.applied) subscribeNext:^(id x) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.appliedView.hidden = !weakSelf.applied;
            [weakSelf layout];
        });
    }];
}

- (void)layout {
    [super layout];    
    BOOL applied = self.applied;

    if (!applied) {
        self.hdView.frame = NSMakeRect(self.bounds.size.width - self.hdView.frame.size.width - (self.bounds.size.width - self.appliedView.frame.origin.x - self.appliedView.frame.size.width), self.hdView.frame.origin.y, self.hdView.frame.size.width, self.hdView.frame.size.height);
    } else {
        self.hdView.frame = NSMakeRect(self.bounds.size.width - self.hdView.frame.size.width - (self.bounds.size.width - self.appliedView.frame.origin.x - self.appliedView.frame.size.width) - 8 - self.appliedView.frame.size.width, self.hdView.frame.origin.y, self.hdView.frame.size.width, self.hdView.frame.size.height);
    }
}

#pragma mark - MCCursorLineDataSource
- (NSUInteger)numberOfCursorsInLine:(MCCursorLine *)cursorLine {
    return [[self.objectValue valueForKeyPath:@"cursors"] count];
}

- (MCCursor *)cursorLine:(MCCursorLine *)cursorLine cursorAtIndex:(NSUInteger)index {
    //!TODO: Sort somewhere else
    return [[[self.objectValue valueForKey:@"cursors"] allValues] objectAtIndex:index];
//    return [[[[self.objectValue valueForKeyPath:@"cursors"] allValues] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"prettyName" ascending:YES selector:@selector(caseInsensitiveCompare:)]]] objectAtIndex:index];
}

@end
