#import "KVOBlockBindingTests.h"
#import "NSObject+KVOBlockBinding.h"
#import "ExampleModel.h"

@implementation KVOBlockBindingTests
@synthesize model, binding;

- (void)setUp
{
    [super setUp];
    self.model = [[ExampleModel alloc] init];
    self.model.exampleValue1 = 1;
    self.model.exampleValue2 = -30;
    wasBlockCalled = NO;
}

- (void)tearDown
{
    self.binding = nil;
    [super tearDown];
}

- (void)bindTo:(NSString*)keyPath 
{
    wasBlockCalled = NO;
    self.binding = [self.model addObserverForKeyPath:keyPath block:^(NSDictionary *change) {
        wasBlockCalled = YES;
    }];    
}

- (void)testShouldUnbindWhenReferenceIsReleased {
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
    wasBlockCalled = NO;
    self.binding = nil;
    
    self.model.exampleValue1 = 4;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
}

- (void)testShouldCallBlockWhenKeyPathPropertyChanged
{
    [self bindTo:@"exampleValue1"];
    
    self.model.exampleValue1 = 2;
    
    STAssertTrue(wasBlockCalled, @"Expected the block to be called");
}

- (void)testShouldNotCallBlockWhenAnotherKeyPathPropertyChanged
{
    [self bindTo:@"exampleValue2"];
    
    self.model.exampleValue1 = 2;
    
    STAssertFalse(wasBlockCalled, @"Expected the block NOT to be called");
}

@end
