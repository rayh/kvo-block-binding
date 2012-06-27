//
//  NSObject+WSObservation.m
//  Local
//
//  Created by Ray Hilton on 27/06/12.
//  Copyright (c) 2012 Wirestorm Pty Ltd. All rights reserved.
//

#import "NSObject+WSObservation.h"
#import <objc/runtime.h>

#define ASSOCIATED_OBJ_OBSERVING_KEY @"rayh_block_based_observing"

@implementation NSObject (WSObservation)

-(NSMutableArray*)allBlockBasedObservations
{
	NSMutableArray *objects = objc_getAssociatedObject(self, ASSOCIATED_OBJ_OBSERVING_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, ASSOCIATED_OBJ_OBSERVING_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objects;
}

- (void)removeAllObservationsOn:(id)object
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservations]]) {
        if([binding.observed isEqual:object]) {
            [binding invalidate];
            [[self allBlockBasedObservations] removeObject:binding];
        }
    }
}

- (void)removeAllObservations
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservations]]) {
        [binding invalidate];
        [[self allBlockBasedObservations] removeObject:binding];
    }
}


- (void)removeAllObserverationsOn:(id)object keyPath:(NSString*)keyPath
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservations]]) {
        if([binding.observed isEqual:object] && [binding.keyPath isEqualToString:keyPath]) {
            [binding invalidate];
            [[self allBlockBasedObservations] removeObject:binding];
        }
    }
}

-(WSObservationBinding*)observe:(id)object 
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options 
                          block:(WSObservationBlock)block 
{
    WSObservationBinding *binding = [[WSObservationBinding alloc] init];
    binding.block = block;
    binding.observed = object;
    binding.keyPath = keyPath;
    binding.owner = self;
    
    [[self allBlockBasedObservations] addObject:binding];
    
    [object addObserver:binding forKeyPath:keyPath options:options context:nil];
    
    return binding;
}

-(WSObservationBinding*)observe:(id)object 
                        keyPath:(NSString *)keyPath
                          block:(WSObservationBlock)block 
{
    
    return [self observe:object 
                 keyPath:keyPath 
                 options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
                   block:block];
}

@end