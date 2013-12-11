#import "ViewController.h"

static NSString *cellIdentifier = @"CVCell";

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet NSMutableArray *cellData;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    self.cellData = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < 400; i++)
    {
        [self.cellData addObject:[NSString stringWithFormat:@"#%d", i+1]];
    }
    
    /*
    UINib *cellNib = [UINib nibWithNibName:@"CVCell"
                                    bundle:nil];
    [self.myCollectionView registerNib:cellNib
            forCellWithReuseIdentifier:@"CVCell"];
    */
    
    /*
    UICollectionViewFlowLayout *layout =
    [[UICollectionViewFlowLayout alloc] init];
    
    [layout setItemSize:CGSizeMake(100, 100)];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.myCollectionView setCollectionViewLayout:layout];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                              forIndexPath:indexPath];
    
    UILabel *cellTitle = (UILabel *)[cell viewWithTag:1];
    
    cellTitle.text = [self.cellData objectAtIndex:indexPath.row];
    return cell;
}

@end
