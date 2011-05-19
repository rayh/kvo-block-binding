#import "NSObject+KVOBlockBinding.h"

@implementation KVOBlockBinding 
@synthesize block, observed, keyPath;

- (void)dealloc {
    [self.observed removeObserver:self forKeyPath:self.keyPath];
    self.keyPath = nil;
    [super dealloc];  
}

- (void)observeValueForKeyPath:(NSString *)path 
                       ofObject:(id)object 
                         change:(NSDictionary *)change 
                        context:(void *)context
{
    if(self.block)
        self.block(change);
}

- (void)release 
{
    self.block = nil;
    [super release];
}

@end

@implementation NSObject (KVOBlockBinding)

-(KVOBlockBinding*)addObserverForKeyPath:(NSString*)keyPath 
                                 options:(NSKeyValueObservingOptions)options 
                                   block:(KVOBindingBlock)block 
{
    KVOBlockBinding *binding = [[[KVOBlockBinding alloc] init] autorelease];
    binding.block = block;
    binding.observed = self;
    binding.keyPath = keyPath;
    
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