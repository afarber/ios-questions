//
//  FailedBankDetails.h
//  FailedBankCD
//
//  Created by Alexander Farber on 05/03/15.
//  Copyright (c) 2015 Alexander Farber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FailedBankInfo;

@interface FailedBankDetails : NSManagedObject

@property (nonatomic, retain) NSDate * closeDate;
@property (nonatomic, retain) NSDate * updateDate;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) FailedBankInfo *info;

@end
