#import <SenTestingKit/SenTestingKit.h>
@class ExampleModel;

@interface KVOBlockBindingTests : SenTestCase {
    BOOL wasBlockCalled;
}

@property (nonatomic, retain) ExampleModel *model;
@property (nonatomic, assign) id binding;

@end
