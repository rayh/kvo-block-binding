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
    self.binding = [self.model addObserverForKeyPath:keyPath owner:self block:^(id observed, NSDictionary *change) {
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

- (void) testTwoWayBinding
{
    NSMutableArray *bindings = [self bind:self.model keyPath:@"exampleValue1" to:self.model keyPath:@"exampleValue2" addReverseBinding:YES];
    
    self.model.exampleValue1 = 1; // no change
    STAssertFalse(self.model.exampleValue2 == self.model.exampleValue1, @"Identical changes should not trigger an update of the target object");
    
    self.model.exampleValue1 = 10;
    STAssertTrue(self.model.exampleValue2 == self.model.exampleValue1, @"Source/Target binding did not product expected result. Expected: %d, Actual: %d",self.model.exampleValue1,self.model.exampleValue2);
    
    self.model.exampleValue2 = 20;
    STAssertTrue(self.model.exampleValue1 == self.model.exampleValue2, @"Target/Source binding did not product expected result. Expected: %d, Actual: %d",self.model.exampleValue2,self.model.exampleValue1);
    
    
    for (WSObservationBinding *binder in bindings) {
        [binding invalidate];
        [[self allBlockBasedObservations] removeObject:binder];
    }
}
@end
