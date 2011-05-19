#import <UIKit/UIKit.h>
@class ExampleModel;
@class KVOBlockBinding;

@interface KVOBlockBindingViewController : UIViewController {
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
}

@property (nonatomic, retain) ExampleModel *model;
@property (nonatomic, retain) KVOBlockBinding *label1Binding;
@property (nonatomic, retain) KVOBlockBinding *label2Binding;

-(IBAction)pressMeButtonPressed:(id)sender;
-(IBAction)stopObservingButtonPressed:(id)sender;
@end
