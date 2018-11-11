//
//  CurrencyRateTableViewCell.h
//  XRateTin
//
//  Created by Herbert Caller on 08/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyRateTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flag;
@property (weak, nonatomic) IBOutlet UILabel *lblValue;
@property (weak, nonatomic) IBOutlet UILabel *lblCode;

@end
