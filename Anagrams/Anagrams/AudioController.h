//
//  AudioController.h
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioController : NSObject

-(void)playEffect:(NSString*)name;
-(void)preloadAudioEffects:(NSArray*)effectFileNames;

@end
