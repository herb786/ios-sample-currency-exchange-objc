//
//  ViewController.m
//  XRateTin
//
//  Created by Herbert Caller on 01/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "TinButton.h"
#import "MainViewController.h"
#import "CurrencyPickerViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet TinButton *pairsButton;
@property (weak, nonatomic) IBOutlet TinButton *currenciesButton;
@property (strong, nonatomic) UIColor *colorStart;
@property (strong, nonatomic) UIColor *colorEnd;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colorStart = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
    self.colorEnd = [UIColor colorWithRed:0.0 green:20/255.0 blue:90/255.0 alpha:1.0];
    
    [self.pairsButton setEndColor:self.colorEnd];
    [self.pairsButton setStartColor:self.colorStart];
    
    [self.currenciesButton setEndColor:self.colorEnd];
    [self.currenciesButton setStartColor:self.colorStart];


    
    _pairsButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _pairsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_pairsButton setTitle:@"Currency\nPairs" forState:UIControlStateNormal];
    
    self.currenciesButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.currenciesButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.currenciesButton setTitle:@"Most Used\nCurrencies" forState:UIControlStateNormal];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self.pairsButton setEndColor:self.colorEnd];
    [self.pairsButton setStartColor:self.colorStart];
    [_pairsButton setNeedsDisplay];
    [self.currenciesButton setEndColor:self.colorEnd];
    [self.currenciesButton setStartColor:self.colorStart];
    [_currenciesButton setNeedsDisplay];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *identifier = segue.identifier;
    if ([identifier isEqualToString:@"seguePairs"]){
        CurrencyPickerViewController *controller = [segue destinationViewController];
        controller.baseCurrency = @"USD";
        controller.aimCurrency = @"EUR";
    }
}


- (IBAction)gotoPairsExchange:(TinButton*)sender {
    CGFloat hue, brg;
    [self.colorEnd getHue:&hue saturation:nil brightness:&brg alpha:nil];
    _pairsButton.endColor = [UIColor colorWithHue:hue saturation:0.1 brightness:brg alpha:1.0];
    [_pairsButton setNeedsDisplay];
    [self performSegueWithIdentifier:@"seguePairs" sender:sender];
}


- (IBAction)gotoMostUsedExchange:(id)sender {
    CGFloat hue, brg;
    [self.colorEnd getHue:&hue saturation:nil brightness:&brg alpha:nil];
    _currenciesButton.endColor = [UIColor colorWithHue:hue saturation:0.1 brightness:brg alpha:1.0];
    [_currenciesButton setNeedsDisplay];
    [self performSegueWithIdentifier:@"segueMostUsed" sender:sender];
}



@end
