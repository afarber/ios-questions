//
//  ViewController.h
//  FailedBankCD
//
//  Created by Alexander Farber on 04.03.15.
//  Copyright (c) 2015 Alexander Farber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UITableViewController

@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic,strong) NSArray *failedBankInfos;

@end

