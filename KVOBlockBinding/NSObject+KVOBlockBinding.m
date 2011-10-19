#import "NSObject+KVOBlockBinding.h"
#import <objc/runtime.h>

#define ASSOCIATED_OBJ_OBSERVERS_KEY @"rayh_block_based_observers"
#define ASSOCIATED_OBJ_OBSERVING_KEY @"rayh_block_based_observing"

@implementation WSObservationBinding 
@synthesize block, observed, keyPath, owner;

- (id)init {
    if((self = [super init])) {
        valid = YES;
    }
    return self;
    
}
- (void)dealloc {
    if(valid)
        [self invalidate];
    
    self.block = nil;
    self.keyPath = nil;
    [super dealloc];  
}

- (void)observeValueForKeyPath:(NSString *)path 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context
{
    if(valid)
        self.block(self.observed, change);
}

- (void)invalidate
{
    [self.observed removeObserver:self forKeyPath:self.keyPath];
    valid = NO;
}

- (void)invoke 
{
    self.block(self.observed, [NSDictionary dictionary]);
}
@end

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


-(WSObservationBinding*)observe:(id)object 
                   keyPath:(NSString *)keyPath
                   options:(NSKeyValueObservingOptions)options 
                     block:(WSObservationBlock)block 
{
    WSObservationBinding *binding = [[[WSObservationBinding alloc] init] autorelease];
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
    WSObservationBinding *binding = [[[WSObservationBinding alloc] init] autorelease];
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