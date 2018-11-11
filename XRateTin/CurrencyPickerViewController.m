//
//  CurrencyPickerViewController.m
//  XRateTin
//
//  Created by Herbert Caller on 05/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "CurrencyPickerViewController.h"
#import "ReferenceRate.h"
#import "TinButton.h"

@interface CurrencyPickerViewController ()

@property (strong, nonatomic)NSArray *baseMoneyCode;
@property (weak, nonatomic) IBOutlet TinButton *swapBtn;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerFromCurrency;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerToCurrency;
@property (weak, nonatomic) IBOutlet UILabel *lblRate;
@property (weak, nonatomic) IBOutlet UITextField *edtAmount;
@property (weak, nonatomic) IBOutlet TinButton *btnConvert;
@property (weak, nonatomic) IBOutlet UILabel *lblExchange;
@property (strong, nonatomic) UIColor *colorStart;
@property (strong, nonatomic) UIColor *colorEnd;

@end

@implementation CurrencyPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.colorStart = [UIColor colorWithRed:90/255.0 green:90/255.0 blue:90/255.0 alpha:1.0];
    self.colorEnd = [UIColor colorWithRed:0.0 green:20/255.0 blue:90/255.0 alpha:1.0];

    self.baseMoneyCode = [NSArray arrayWithObjects:@"AUD",@"BGN",@"BRL",@"CAD",@"CHF",@"CNY",@"CZK",@"DKK",@"GBP",@"HKD",@"HRK",@"HUF",@"IDR",@"ILS",@"INR",@"JPY",@"KRW",@"MXN",@"MYR",@"NOK",@"NZD",@"PHP",@"PLN",@"RON",@"RUB",@"SEK",@"SGD",@"THB",@"TRY",@"USD",@"ZAR",@"EUR", nil];
    NSUInteger row0 = [self.baseMoneyCode indexOfObject:self.baseCurrency];
    NSUInteger row1 = [self.baseMoneyCode indexOfObject:self.aimCurrency];
    [self.pickerFromCurrency selectRow:row0 inComponent:0 animated:false];
    [self.pickerToCurrency selectRow:row1 inComponent:0 animated:false];
    [self fetchExchangeRates:self.baseCurrency aimCurrency:self.aimCurrency];
    self.swapBtn.startColor = self.colorStart;
    self.swapBtn.endColor = self.colorEnd;
    self.btnConvert.startColor = self.colorStart;
    self.btnConvert.endColor = self.colorEnd;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.pickerFromCurrency){
        return 1;
    }
    if (pickerView == self.pickerToCurrency) {
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerFromCurrency){
        return [self.baseMoneyCode count];
    }
    if (pickerView == self.pickerToCurrency) {
        return [self.baseMoneyCode count];
    }
    return 0;
}

#pragma mark - Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerFromCurrency){
        return self.baseMoneyCode[row];
    }
    if (pickerView == self.pickerToCurrency) {
        return self.baseMoneyCode[row];
    }
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerFromCurrency){
        NSInteger row1 = [self.pickerToCurrency selectedRowInComponent:0];
        [self fetchExchangeRates:self.baseMoneyCode[row] aimCurrency:self.baseMoneyCode[row1]];
    }
    if (pickerView == self.pickerToCurrency) {
        NSInteger row1 = [self.pickerFromCurrency selectedRowInComponent:0];
        [self fetchExchangeRates:self.baseMoneyCode[row1] aimCurrency:self.baseMoneyCode[row]];    }
}



#pragma mark - Actions
- (IBAction)changeStyle:(TinButton *)sender {
    self.swapBtn.startColor = self.colorStart;
    self.swapBtn.endColor = self.colorEnd;
    self.btnConvert.startColor = self.colorStart;
    self.btnConvert.endColor = self.colorEnd;
    [self.swapBtn setNeedsDisplay];
    [self.btnConvert setNeedsDisplay];

}

- (IBAction)swapCurrencies:(TinButton *)sender {
    CGFloat hue, brg;
    [self.colorEnd getHue:&hue saturation:nil brightness:&brg alpha:nil];
    self.swapBtn.endColor = [UIColor colorWithHue:hue saturation:0.1 brightness:brg alpha:1.0];
    [self.swapBtn setNeedsDisplay];
    NSInteger row0 = [self.pickerFromCurrency selectedRowInComponent:0];
    NSInteger row1 = [self.pickerToCurrency selectedRowInComponent:0];
    [self.pickerToCurrency selectRow:row0 inComponent:0 animated:false];
    [self.pickerFromCurrency selectRow:row1 inComponent:0 animated:false];
    [self fetchExchangeRates:self.baseMoneyCode[row1] aimCurrency:self.baseMoneyCode[row0]];
}



- (IBAction)btnConvert:(TinButton *)sender {
    CGFloat hue, brg;
    [self.colorEnd getHue:&hue saturation:nil brightness:&brg alpha:nil];
    self.btnConvert.endColor = [UIColor colorWithHue:hue saturation:0.1 brightness:brg alpha:1.0];
    [self.btnConvert setNeedsDisplay];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    float amount = [[numberFormatter numberFromString:self.edtAmount.text] floatValue];
    float rate = [[numberFormatter numberFromString:self.lblRate.text] floatValue];
    NSNumber *exchange = [NSNumber numberWithFloat:(amount*rate)];
    self.lblExchange.text = [numberFormatter stringFromNumber:exchange];
}

- (void) fetchExchangeRates:(NSString*) baseCurrency aimCurrency:(NSString*) aimCurrency {
    NSString *baseUrl = @"https://api.fixer.io/latest?symbols=";
    NSString *fullUrl =[baseUrl stringByAppendingFormat:@"%@,%@",baseCurrency,aimCurrency];
    NSURL *fixerioUrl = [NSURL URLWithString:fullUrl];
    [[[NSURLSession sharedSession]
      dataTaskWithURL:fixerioUrl
      completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
          NSLog(@"%@", response.description);
          ReferenceRate *result = [[ReferenceRate alloc] initWithData:data error:nil];
          NSDictionary *refs = [result.rates toDictionary];
          NSArray *currencies = [refs allKeys];
          NSArray *values = [refs allValues];
          dispatch_async(dispatch_get_main_queue(), ^{
              NSLog(@"JSON: %@", result.base);
              NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
              [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
              
              NSNumber *value = values[0];
              float base = value.floatValue;
              float aim = value.floatValue;
              
              if (([baseCurrency isEqualToString:aimCurrency]) == false){
                  if ([baseCurrency isEqualToString:@"EUR"]){
                      base = 1.0;
                      value = values[0];
                      aim = value.floatValue;
                  } else if ([aimCurrency isEqualToString:@"EUR"]) {
                      aim = 1.0;
                      value = values[0];
                      base = value.floatValue;
                  } else {
                      if ([currencies[0] isEqualToString:baseCurrency]){
                          value = values[0];
                          base = value.floatValue;
                          value = values[1];
                          aim = value.floatValue;
                      } else {
                          value = values[1];
                          base = value.floatValue;
                          value = values[0];
                          aim = value.floatValue;
                      }
                  
                  }
                  
                  
              }

              NSNumber *rate = [NSNumber numberWithFloat:(aim/base)];
              self.lblRate.text = [numberFormatter stringFromNumber:rate];
          });
      }] resume];
    
    
}


- (IBAction)hideKeyboard:(id)sender {
    [self.edtAmount resignFirstResponder];
}




@end
