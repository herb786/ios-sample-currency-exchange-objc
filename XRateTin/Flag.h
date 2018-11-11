//
//  Flag.h
//  XRateTin
//
//  Created by Herbert Caller on 22/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "JSONModel.h"

@protocol Flag;

@interface Flag : JSONModel

@property (strong, nonatomic) NSNumber <Optional>* id;
@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* flag;

@end
