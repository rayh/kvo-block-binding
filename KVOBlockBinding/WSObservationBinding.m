//
//  WSObservationBinding.m
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "WSObservationBinding.h"

@interface WSObservationBinding ()
@end

@implementation WSObservationBinding 
@synthesize valid=valid_;
@synthesize block=block_;
@synthesize observed=observed_;
@synthesize keyPath=keyPath_;
@synthesize owner=owner_;

- (id)init 
{
    if((self = [super init])) {
        self.valid = YES;
    }
    return self;
    
}

- (void)dealloc 
{
    if(self.valid)
        [self invalidate];
}

- (void)observeValueForKeyPath:(NSString *)path 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    if(self.valid && ![[change valueForKey:NSKeyValueChangeNewKey] isEqual:[change valueForKey:NSKeyValueChangeOldKey]]) 
        self.block(self.observed, change);
}

- (void)invalidate
{
    [self.observed removeObserver:self forKeyPath:self.keyPath];
    self.valid = NO;
}

- (void)invoke 
{
    self.block(self.observed, [NSDictionary dictionary]);
}
@end
