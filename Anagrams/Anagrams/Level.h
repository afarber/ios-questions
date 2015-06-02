//
//  Level.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject

//properties stored in a .plist file
@property (assign, nonatomic) int pointsPerTile;
@property (assign, nonatomic) int timeToSolve;
@property (strong, nonatomic) NSArray* anagrams;

//factory method to load a .plist file and initialize the model
+(instancetype)levelWithNum:(int)levelNum;

@end
