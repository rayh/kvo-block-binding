#import <SenTestingKit/SenTestingKit.h>
@class ExampleModel;

@interface KVOBlockBindingTests : SenTestCase {
    BOOL wasBlockCalled;
}

@property (nonatomic, retain) ExampleModel *model;
@property (nonatomic, retain) id binding;

@end
