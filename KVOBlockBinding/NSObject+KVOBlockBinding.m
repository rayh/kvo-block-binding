#import "NSObject+KVOBlockBinding.h"
#import <objc/runtime.h>

#define ASSOCIATED_OBJ_OBSERVERS_KEY @"rayh_block_based_observers"

@implementation NSObject (KVOBlockBinding)

-(NSMutableArray*)allBlockBasedObservers
{
	NSMutableArray *objects = objc_getAssociatedObject(self, ASSOCIATED_OBJ_OBSERVERS_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, ASSOCIATED_OBJ_OBSERVERS_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objects;
}

- (void)removeAllBlockBasedObserversForKeyPath:(NSString*)keyPath
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservers]]) {
        if([binding.keyPath isEqualToString:keyPath]) {
            [binding invalidate];
            [[self allBlockBasedObservers] removeObject:binding];
        }
    }
}

- (void)removeAllBlockBasedObservers
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservers]]) {
        [binding invalidate];
        [[self allBlockBasedObservers] removeObject:binding];
    }
}

- (void)removeAllBlockBasedObserversForOwner:(id)owner
{
    for(WSObservationBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservers]]) {
        if([binding.owner isEqual:owner]) {
            [binding invalidate];
            [[self allBlockBasedObservers] removeObject:binding];
        }
    }
}

-(WSObservationBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                   owner:(id)owner 
                                 options:(NSKeyValueObservingOptions)options 
                                   block:(WSObservationBlock)block 
{
    WSObservationBinding *binding = [[WSObservationBinding alloc] init];
    binding.block = block;
    binding.observed = self;
    binding.keyPath = keyPath;
    binding.owner = owner;
    
    [[self allBlockBasedObservers] addObject:binding];
    
    [self addObserver:binding forKeyPath:keyPath options:options context:nil];
    
    return binding;
}

-(WSObservationBinding*)addObserverForKeyPath:(NSString*)keyPath  
                                   owner:(id)owner 
                                   block:(WSObservationBlock)block 
{
    return [self addObserverForKeyPath:keyPath  
                                 owner:owner 
                               options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
                                 block:block];
}

@end