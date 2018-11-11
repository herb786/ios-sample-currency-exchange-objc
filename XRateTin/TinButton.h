//
//  TinButton.h
//  XRateTin
//
//  Created by Herbert Caller on 25/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TinButton : UIButton

@property (nonatomic) IBInspectable UIColor *startColor;
@property (nonatomic) IBInspectable UIColor *endColor;
@property (nonatomic) IBInspectable NSInteger lineWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
