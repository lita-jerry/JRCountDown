//
//  ViewController.m
//  JRCountDownButton
//

#import "ViewController.h"
#import "NSObject+JRCountDown.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buttonClick:(UIButton *)sender {
    [[sender jr_configureWithCountDownTime:5.f intervalTime:1.f whileExecutingBlock:^(NSObject* selfInstance, CGFloat SurplusSec) {
        NSLog(@"%.f", roundf(SurplusSec));
        [(UIButton *)selfInstance setEnabled:NO];
        [(UIButton *)selfInstance setTitle:[NSString stringWithFormat:@"There are %.f seconds can send messages", roundf(SurplusSec)] forState:UIControlStateDisabled];
    } completionBlock:^(NSObject* selfInstance){
        NSLog(@"completion");
        [(UIButton *)selfInstance setEnabled:YES];
        [(UIButton *)selfInstance setTitle:@"Send verification code"forState:UIControlStateNormal];
    }] jr_start];
}

@end
