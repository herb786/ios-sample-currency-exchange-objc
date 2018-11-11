//
//  CurrencyPickerViewController.h
//  XRateTin
//
//  Created by Herbert Caller on 05/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyPickerViewController : UIViewController
<UIPickerViewDelegate, UIPickerViewDataSource>

@property (copy, nonatomic) NSString *aimCurrency;
@property (copy, nonatomic) NSString *baseCurrency;

@end
