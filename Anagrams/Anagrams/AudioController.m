//
//  AudioController.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "AudioController.h"
#import <AVFoundation/AVFoundation.h>

@implementation AudioController
{
  NSMutableDictionary* audio;
}

-(void)preloadAudioEffects:(NSArray*)effectFileNames
{
  //initialize the effects array
  audio = [NSMutableDictionary dictionaryWithCapacity: effectFileNames.count];
  
  //loop over the filenames
  for (NSString* effect in effectFileNames) {
    
    //1 get the file path URL
    NSString* soundPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: effect];
    NSURL* soundURL = [NSURL fileURLWithPath: soundPath];
    
    //2 load the file contents
    NSError* loadError = nil;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error: &loadError];
    NSAssert(loadError==nil, @"load sound failed");
    
    //3 prepare the play
    player.numberOfLoops = 0;
    [player prepareToPlay];
    
    //4 add to the array ivar
    audio[effect] = player;
  }
}

-(void)playEffect:(NSString*)name
{
  NSAssert(audio[name], @"effect not found");
  
  AVAudioPlayer* player = (AVAudioPlayer*)audio[name];
  if (player.isPlaying) {
    player.currentTime = 0;
  } else {
    [player play];
  }
}

@end
