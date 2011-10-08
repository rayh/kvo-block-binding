#import "KVOBlockBindingTests.h"
#import "NSObject+KVOBlockBinding.h"
#import "ExampleModel.h"

@implementation KVOBlockBindingTests
@synthesize model, binding;

- (void)setUp
{
    [super setUp];
    self.model = [[[ExampleModel alloc] init] autorelease];
    self.model.exampleValue1 = 1;
    self.model.exampleValue2 = -30;
    wasBlockCalled = NO;
}

- (void)tearDown
{
    self.binding = nil;
    self.model = nil;
    [super tearDown];
}

- (void)bindTo:(NSString*)keyPath 
{
    __block KVOBlockBindingTests *blockSelf = self;
    self.binding = [self.model addObserverForKeyPath:keyPath owner:self block:^(NSDictionary *change) {
        blockSelf->wasBlockCalled = YES;
    }];    
}

- (void)testShouldUnbindWhenRemoveObserverForKeyPathIsCalled {
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
    wasBlockCalled = NO;
    [self.model removeAllBlockBasedObserversForOwner:self];
    
    self.model.exampleValue1 = 4;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
}

- (void)testShouldUnbindWhenRemoveAllObserversIsCalled {
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
    wasBlockCalled = NO;
    
    [self.model removeAllBlockBasedObservers];
    
    self.model.exampleValue1 = 4;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
}

- (void)testShouldUnbindWhenInvalidateIsCalled {
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
    wasBlockCalled = NO;
    
    [self.binding invalidate];
    
    self.model.exampleValue1 = 4;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
}

- (void)testShouldCallBlockWhenKeyPathPropertyChanged
{
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
    [self.binding invalidate];
}

- (void)testShouldNotCallBlockWhenAnotherKeyPathPropertyChanged
{
    [self bindTo:@"exampleValue2"];
    
    self.model.exampleValue1 = 2;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
    [self.binding invalidate];
}
@end
