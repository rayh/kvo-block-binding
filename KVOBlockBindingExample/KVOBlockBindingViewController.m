#import "KVOBlockBindingViewController.h"
#import "ExampleModel.h"
#import "NSObject+KVOBlockBinding.h"

@implementation KVOBlockBindingViewController
@synthesize model;
@synthesize stepper1;
@synthesize stepper2;
@synthesize stepper1Label;
@synthesize stepper2Label;

- (void)dealloc
{
    self.model = nil;   
    [stepper1 release];
    [stepper2 release];
    [stepper1Label release];
    [stepper2Label release];
    [super dealloc];
}

-(void)bindObserverToValue1 
{
    toggleObservingValue1Button.selected = YES;
    [toggleObservingValue1Button setTitle:@"Stop Observing Value1" forState:UIControlStateNormal];
    [self.model addObserverForKeyPath:@"exampleValue1" owner:self block:^(id observed, NSDictionary *change) {
        label1.text = [NSString stringWithFormat:@"%d", self.model.exampleValue1];
    }];
}

-(void)bindObserverToValue2
{
    toggleObservingValue2Button.selected = YES;
    [toggleObservingValue2Button setTitle:@"Stop Observing Value2" forState:UIControlStateNormal];
    [self.model addObserverForKeyPath:@"exampleValue2" owner:self block:^(id observed, NSDictionary *change) {
        label2.text = [NSString stringWithFormat:@"%@ -> %@", [change valueForKey:NSKeyValueChangeOldKey] , [change valueForKey:NSKeyValueChangeNewKey]];
    }];
}

-(void)twoWayBinding
{
    [self bind:stepper1 keyPath:@"value" to:stepper2 keyPath:@"value" addReverseBinding:YES];
    
    // add one way blocks to observe the stepper values
    [self observe:stepper1 keyPath:@"value" block:^(id observed, NSDictionary *change) {       
        stepper1Label.text = [NSString stringWithFormat:@"%1.0f",stepper1.value];
    }];
    [self observe:stepper2 keyPath:@"value" block:^(id observed, NSDictionary *change) {
        stepper2Label.text = [NSString stringWithFormat:@"%1.0f",stepper2.value];
    }];

}

-(void)removeObserverFromValue1
{
    toggleObservingValue1Button.selected = NO;
    [self.model removeAllBlockBasedObserversForKeyPath:@"exampleValue1"];
    [toggleObservingValue1Button setTitle:@"Start Observing Value1" forState:UIControlStateNormal];
}
		
-(void)removeObserverFromValue2
{
    toggleObservingValue2Button.selected = NO;
    [self.model removeAllBlockBasedObserversForKeyPath:@"exampleValue2"];
    [toggleObservingValue2Button setTitle:@"Start Observing Value2" forState:UIControlStateNormal];
}

-(void)viewDidLoad 
{
    self.model = [[[ExampleModel alloc] init] autorelease];
    self.model.exampleValue1 = 0;
    self.model.exampleValue2 = 0;

    label1.text = @"0";
    label2.text = @"0";
    
    [self bindObserverToValue1];
    [self bindObserverToValue2];
    
    [self twoWayBinding];
}


-(IBAction)pressMeButtonPressed:(id)sender 
{
    self.model.exampleValue1+=1;
    self.model.exampleValue2+=2;
}

-(IBAction)toggleObservingValue1ButtonPressed:(UIButton*)sender 
{
    sender.selected ? [self removeObserverFromValue1] : [self bindObserverToValue1];
}

-(IBAction)toggleObservingValue2ButtonPressed:(UIButton*)sender 
{
    sender.selected ? [self removeObserverFromValue2] : [self bindObserverToValue2];
}

-(IBAction)removeObservingAllButtonPressed:(id)sender
{
    [self removeObserverFromValue1];
    [self removeObserverFromValue2];
}

- (void)viewDidUnload {
    [self setStepper1:nil];
    [self setStepper2:nil];
    [self setStepper1Label:nil];
    [self setStepper2Label:nil];
    [super viewDidUnload];
}
@end