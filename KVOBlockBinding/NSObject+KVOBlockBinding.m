#import "NSObject+KVOBlockBinding.h"
#import <objc/runtime.h>

#define ASSOCIATED_OBJ_KEY @"rayh_block_based_observers"

@implementation KVOBlockBinding 
@synthesize block, observed, keyPath;

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
        self.block(change);
}

- (void)invalidate
{
    [self.observed removeObserver:self forKeyPath:self.keyPath];
    valid = NO;
}

- (void)release 
{
    // If this release will reduce the retain count to zero, prevent further calls to the block
    if([self retainCount]==1 && valid)
        [self invalidate];
    
    [super release];
}

@end

@implementation NSObject (KVOBlockBinding)

-(NSMutableArray*)allBlockBasedObservers
{
	NSMutableArray *objects = objc_getAssociatedObject(self, ASSOCIATED_OBJ_KEY);
    if(!objects) {
        objects = [NSMutableArray array];
        objc_setAssociatedObject(self, ASSOCIATED_OBJ_KEY, objects, OBJC_ASSOCIATION_RETAIN);
    }
    
    return objects;
}

- (void)removeBlockBasedObserverForKeyPath:(NSString*)keyPath
{
    for(KVOBlockBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservers]]) {
        if([binding.keyPath isEqualToString:keyPath]) {
            [binding invalidate];
            [[self allBlockBasedObservers] removeObject:binding];
        }
    }
}

- (void)removeAllBlockBasedObservers
{
    for(KVOBlockBinding *binding in [NSArray arrayWithArray:[self allBlockBasedObservers]]) {
        [binding invalidate];
        [[self allBlockBasedObservers] removeObject:binding];
    }
}

-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                 options:(NSKeyValueObservingOptions)options 
                                   block:(KVOBindingBlock)block 
{
    KVOBlockBinding *binding = [[[KVOBlockBinding alloc] init] autorelease];
    binding.block = block;
    binding.observed = self;
    binding.keyPath = keyPath;
    
    [[self allBlockBasedObservers] addObject:binding];
    
    [self addObserver:binding forKeyPath:keyPath options:options context:nil];
    
    return binding;
}

-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                   block:(KVOBindingBlock)block 
{
    return [self addObserverForKeyPath:keyPath 
                               options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld 
                                 block:block];
}

@end