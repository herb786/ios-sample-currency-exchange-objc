//
//  TinButton.m
//  XRateTin
//
//  Created by Herbert Caller on 25/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "TinButton.h"
IB_DESIGNABLE

@implementation TinButton



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self customInit];
    
}

-(void) customInit {
    self.layer.cornerRadius = _cornerRadius;
    if (_lineWidth > 0){
        self.layer.borderWidth = _lineWidth;
    }
    
    if (_cornerRadius > 0){
        self.layer.masksToBounds = YES;
    }
    
    
    const CGFloat *sComp = CGColorGetComponents([_startColor CGColor]);
    const CGFloat *eComp = CGColorGetComponents([_endColor CGColor]);
    CGFloat components[8] = {sComp[0], sComp[1], sComp[2], 1.0,
        eComp[0], eComp[1], eComp[2], 1.0};
    //CGFloat components[8] = { 1.0, 0.5, 0.4, 1.0, 0.8, 0.8, 0.3, 1.0 };
    
    CGRect rect = self.bounds;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0};
    CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, num_locations);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGPoint center= CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    CGFloat radius = MIN(rect.size.height, rect.size.width);
    CGContextDrawRadialGradient(ctx, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer new];
    gradientLayer.frame = rect;
    [self.layer addSublayer:gradientLayer];
}

@end
