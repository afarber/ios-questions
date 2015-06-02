//
//  StarDustView.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "StarDustView.h"
#import "QuartzCore/QuartzCore.h"

@implementation StarDustView
{
  CAEmitterLayer* _emitter;
}

+ (Class) layerClass
{
  //configure the UIView to have emitter layer
  return [CAEmitterLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    //initialize the emitter
    _emitter = (CAEmitterLayer*)self.layer;
    _emitter.emitterPosition = CGPointMake(self.bounds.size.width /2, self.bounds.size.height/2 );
    _emitter.emitterSize = self.bounds.size;
    _emitter.emitterMode = kCAEmitterLayerAdditive;
    _emitter.emitterShape = kCAEmitterLayerRectangle;
  }
  return self;
}

-(void)didMoveToSuperview
{
  [super didMoveToSuperview];
  
  if (self.superview==nil) return;
  
  //load the texture image
  UIImage* texture = [UIImage imageNamed: @"particle.png"];
  NSAssert(texture, @"particle.png not found");
  
  //create new emitter cell
  CAEmitterCell* emitterCell = [CAEmitterCell emitterCell];
  
  emitterCell.contents = (__bridge id)[texture CGImage];
  emitterCell.name = @"cell";
  
  emitterCell.birthRate = 200;
  emitterCell.lifetime = 1.5;
  
  emitterCell.blueRange = 0.33;
  emitterCell.blueSpeed = -0.33;
  
  emitterCell.yAcceleration = 100;
  emitterCell.xAcceleration = -200;
  
  emitterCell.velocity = 100;
  emitterCell.velocityRange = 40;
  
  emitterCell.scaleRange = 0.5;
  emitterCell.scaleSpeed = -0.2;
  
  emitterCell.emissionRange = M_PI*2;
  
  _emitter.emitterCells = @[emitterCell];
}

-(void)disableEmitterCell
{
  [_emitter setValue:@0 forKeyPath:@"emitterCells.cell.birthRate"];
}

@end
