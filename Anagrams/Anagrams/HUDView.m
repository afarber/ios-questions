//
//  HUDView.m
//  Anagrams
//
//  Created by Marin Todorov on 16/02/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "HUDView.h"
#import "config.h"

@implementation HUDView

+(instancetype)viewWithRect:(CGRect)r
{
  //create the hud layer
  HUDView* hud = [[HUDView alloc] initWithFrame:r];
  hud.userInteractionEnabled = YES;
  
  //the stopwatch
  hud.stopwatch = [[StopwatchView alloc] initWithFrame: CGRectMake(kScreenWidth/2-150, 0, 300, 100)];
  hud.stopwatch.seconds = 0;
  [hud addSubview: hud.stopwatch];
  
  //"points" label
  UILabel* pts = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-340,30,140,70)];
  pts.backgroundColor = [UIColor clearColor];
  pts.font = kFontHUD;
  pts.text = @" Points:";
  [hud addSubview:pts];
  
  //the dynamic points label
  hud.gamePoints = [CounterLabelView labelWithFont:kFontHUD frame:CGRectMake(kScreenWidth-200,30,200,70) andValue:0];
  hud.gamePoints.textColor = [UIColor colorWithRed:0.38 green:0.098 blue:0.035 alpha:1] /*#611909*/;
  [hud addSubview: hud.gamePoints];
  
  //load the button image
  UIImage* image = [UIImage imageNamed:@"btn"];
  
  //the help button
  hud.btnHelp = [UIButton buttonWithType:UIButtonTypeCustom];
  [hud.btnHelp setTitle:@"Hint!" forState:UIControlStateNormal];
  hud.btnHelp.titleLabel.font = kFontHUD;
  [hud.btnHelp setBackgroundImage:image forState:UIControlStateNormal];
  hud.btnHelp.frame = CGRectMake(50, 30, image.size.width, image.size.height);
  hud.btnHelp.alpha = 0.8;
  [hud addSubview: hud.btnHelp];
  
  return hud;
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
  // let touches through and only catch the ones on buttons
  UIView* hitView = (UIView*)[super hitTest:point withEvent:event];
  
  if ([hitView isKindOfClass:[UIButton class]]) {
    return hitView;
  }
  
  return nil;
  
}

@end