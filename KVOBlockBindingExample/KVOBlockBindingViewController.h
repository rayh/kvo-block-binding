#import <UIKit/UIKit.h>
@class ExampleModel;
@class KVOBlockBinding;

@interface KVOBlockBindingViewController : UIViewController {
    IBOutlet UILabel *label1;
    IBOutlet UILabel *label2;
    IBOutlet UIButton *toggleObservingValue1Button;
    IBOutlet UIButton *toggleObservingValue2Button;
    IBOutlet UIButton *removeObservingAllButton;
}

@property (nonatomic, retain) ExampleModel *model;
@property (retain, nonatomic) IBOutlet UIStepper *stepper1;
@property (retain, nonatomic) IBOutlet UIStepper *stepper2;
@property (retain, nonatomic) IBOutlet UILabel *stepper1Label;
@property (retain, nonatomic) IBOutlet UILabel *stepper2Label;

-(IBAction)pressMeButtonPressed:(id)sender;
-(IBAction)toggleObservingValue2ButtonPressed:(id)sender;
-(IBAction)toggleObservingValue2ButtonPressed:(id)sender;
-(IBAction)removeObservingAllButtonPressed:(id)sender;

@end
