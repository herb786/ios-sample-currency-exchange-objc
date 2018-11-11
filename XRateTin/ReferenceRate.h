//
//  ReferenceRate.h
//  XRateTin
//
//  Created by Herbert Caller on 06/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "JSONModel.h"
#import "Currency.h"

@interface ReferenceRate : JSONModel

@property (strong, nonatomic) NSString* base;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) Currency* rates;

@end
