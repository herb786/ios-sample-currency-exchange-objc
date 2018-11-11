//
//  FlagSet.h
//  XRateTin
//
//  Created by Herbert Caller on 22/08/2017.
//  Copyright © 2017 hacaller. All rights reserved.
//

#import "JSONModel.h"
#import "Flag.h"

@interface FlagSet : JSONModel

@property (nonatomic) NSArray<Flag> *flags;

@end
