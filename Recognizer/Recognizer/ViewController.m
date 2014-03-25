#import "ViewController.h"

@interface Tile : UIButton
@property (nonatomic, readonly) IBOutlet NSLayoutConstraint* widthConstraint;
@property (nonatomic, readonly) IBOutlet NSLayoutConstraint* heightConstraint;
@end

@implementation Tile
@synthesize widthConstraint, heightConstraint;
@end

@interface ViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@end

@implementation ViewController
{
    UIImageView* _imageView;
    Tile*        _dragTile;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer* pgr = [[UIPanGestureRecognizer alloc]
                                   initWithTarget: self
                                           action: @selector( pan: )];
    pgr.delegate = self;
    
    [self.view addGestureRecognizer: pgr];
}

- (UIView*) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView: self.view];
    
    UIView* v = [self.view hitTest: pt withEvent: nil];
    
    return [v isKindOfClass: [Tile class]];
}

- (void) pan: (UIGestureRecognizer*) gestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView: self.view];
    
    switch ( gestureRecognizer.state )
    {
        case UIGestureRecognizerStateBegan:
        {
            NSLog( @"pan start!" );
            
            _dragTile = (Tile*)[self.view hitTest: pt withEvent: nil];
            
            [UIView transitionWithView: self.view
                              duration: 0.4
                               options: UIViewAnimationOptionAllowAnimatedContent
                            animations: ^{
                                _dragTile.widthConstraint.constant = 70;
                                _dragTile.heightConstraint.constant = 70;
                                [self.view layoutIfNeeded];
                            }
                            completion: nil];
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            NSLog( @"pan!" );
            
            _dragTile.center = pt;
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            NSLog( @"pan ended!" );
            
            pt = [gestureRecognizer locationInView: _imageView];
            
            // reparent:
            [_dragTile removeFromSuperview];
            [_imageView addSubview: _dragTile];
            
            // animate:
            [UIView transitionWithView: self.view
                              duration: 0.25
                               options: UIViewAnimationOptionAllowAnimatedContent
                            animations: ^{
                                _dragTile.widthConstraint.constant = 40;
                                _dragTile.heightConstraint.constant = 40;
                                _dragTile.center = pt;
                                [self.view layoutIfNeeded];
                            }
                            completion: ^(BOOL finished) {
                                _dragTile = nil;
                            }];
        }
            break;
            
        default:
            NSLog( @"pan other!" );
            break;
    }
}

@end
