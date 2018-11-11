//
//  XChangeViewController.m
//  XRateTin
//
//  Created by Herbert Caller on 05/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "CurrencyRateTableViewCell.h"
#import "XChangeViewController.h"
#import "ReferenceRate.h"
#import "CurrencyPickerViewController.h"
#import "Flag.h"

@interface XChangeViewController ()

@property(strong, nonatomic) ReferenceRate* fixer;
@property(strong, nonatomic) NSDictionary* refs;
@property(strong, nonatomic) NSArray* currencies;
@property(strong, nonatomic) NSMutableArray* flags;
@property(strong, nonatomic) NSArray* values;
@property(strong, nonatomic) NSString* lblBaseCurrency;
@property(strong, nonatomic) NSString* baseCurrency;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation XChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.baseCurrency = @"EUR";
    self.lblBaseCurrency = @"Change Unit: Euro";
    [self fetchExchangeRates:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currencies count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        cell.textLabel.text = self.lblBaseCurrency;
        return cell;
    } else {
        CurrencyRateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyRateIdentifier"];
        cell.lblCode.text = self.currencies[indexPath.row];
        NSNumber* value = self.values[indexPath.row];
        NSString* textCell = [[NSString alloc] initWithFormat:@"%.4f", value.doubleValue];
        cell.lblValue.text = textCell;
        NSString *img = self.flags[indexPath.row];
        if ([img isEqualToString:@""] == false){
            NSLog(@"JSON: %@", img);
            NSURL *url = [NSURL URLWithString:img];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image = [UIImage imageWithData:data];
            cell.flag.image = image;
        }
        return cell;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    CurrencyPickerViewController *controller = [segue destinationViewController];
    controller.baseCurrency = self.baseCurrency;
    controller.aimCurrency = self.currencies[indexPath.row];
}



- (IBAction)fetchRatesEuroBased:(UIBarButtonItem *)sender {
    self.lblBaseCurrency = @"Change Unit: Euro";
    self.baseCurrency = @"EUR";
    [self fetchExchangeRates:@"?base=EUR"];
}

- (IBAction)fetchRatesDollarBased:(UIBarButtonItem *)sender {
    self.lblBaseCurrency = @"Change Unit: US Dollar";
    self.baseCurrency = @"USD";
    [self fetchExchangeRates:@"?base=USD"];
}


- (IBAction)fetchRatesPoundBased:(UIBarButtonItem *)sender {
    self.lblBaseCurrency = @"Change Unit: British Pound";
    self.baseCurrency = @"GBP";
    [self fetchExchangeRates:@"?base=GBP"];
}


- (void) fetchExchangeRates:(NSString*) baseCurrency {
    NSString* baseUrl = @"https://api.fixer.io/latest";
    NSString* fullUrl =[baseUrl stringByAppendingString:baseCurrency];
    NSURL* fixerioUrl = [NSURL URLWithString:fullUrl];
    [[[NSURLSession sharedSession]
      dataTaskWithURL:fixerioUrl
      completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
          //NSLog(@"%@", response.description);
          self.fixer = [[ReferenceRate alloc] initWithData:data error:nil];
          self.refs = [self.fixer.rates toDictionary];
          self.currencies = [self.refs allKeys];
          self.values = [self.refs allValues];
          dispatch_async(dispatch_get_main_queue(), ^{
              //NSLog(@"JSON: %@", self.fixer.base);
              [self.tableView reloadData];
              [self fetchImages];
          });
      }] resume];
    
    
    
}


- (void) fetchImages {
    NSString *imgUrl = @"https://py4hacaller.herokuapp.com/api/flags.json";
    NSURL* myUrl = [NSURL URLWithString:imgUrl];
    [[[NSURLSession sharedSession]
      dataTaskWithURL:myUrl
      completionHandler:^(NSData *data, NSURLResponse * response, NSError *error) {
          NSLog(@"%@", response.description);
          NSArray *myflags = [Flag arrayOfModelsFromData:data error:nil];
          self.flags = [[NSMutableArray alloc] init];
          int maxi = (int) self.currencies.count;
          int maxj = (int) myflags.count;
          int i, j;
          for ( i=0; i<maxi; i=i+1) {
              NSString *code = self.currencies[i];
              //NSLog(@"JSON: %@", code);
              for ( j=0; j<maxj; j=j+1) {
                  Flag *flag = myflags[j];
                  if ([flag.code isEqualToString:code]){
                      self.flags[i] = flag.flag;
                      //NSLog(@"JSON: %@", self.flags[i]);
                  }
              }
          }
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.tableView reloadData];
          });
      }] resume];
}
    
    
    
@end
