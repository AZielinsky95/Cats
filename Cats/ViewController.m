//
//  ViewController.m
//  Cats
//
//  Created by Alejandro Zielinsky on 2018-04-26.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "PhotoCell.h"
#import "DetailViewController.h"

@interface ViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray<Photo*> *photos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photos = [[NSMutableArray alloc] init];

    
     NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=12b4f5ab7547f2de3140c989f974d48e&tags=cat"];
    
    NSURLRequest *request;
    request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                              completionHandler:^(NSData * _Nullable data,
                                                                                  NSURLResponse * _Nullable response, NSError * _Nullable error)
                               {
                                   NSLog(@"got result");
                                   [self parseResponseData:data];
                               }];
    
    [task resume];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showDetail"])
    {
        NSArray *currentItems = [self.collectionView indexPathsForSelectedItems];
        NSIndexPath *indexPath = currentItems[0];
        
        long index = indexPath.row;
        
        DetailViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.photo = [self.photos objectAtIndex:index];
    }
}

-(void)parseResponseData:(NSData *)data
{
    NSError *error;
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    NSDictionary *allPhotos = results[@"photos"];
    NSArray *photos = allPhotos[@"photo"];
    
    
    for(NSDictionary *item in photos)
    {
        Photo *photo = [[Photo alloc] initWithFarmID:item[@"farm"] serverID:item[@"server"] secret:item[@"secret"] identifier:item[@"id"] name:item[@"title"]];
        [self downloadImagesForPhoto:photo];
        [self.photos addObject:photo];
    }
}

-(void)downloadImagesForPhoto:(Photo*)photo
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 2
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 3
    
    NSURL *url = [[NSURL alloc] initWithString:photo.photoURL];
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data]; // 2
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            photo.image = image;
            [self.collectionView reloadData];
        }];
        
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           [self.collectionView reloadData];
//                       });
        
    }];
    
    
    [downloadTask resume]; // 5
}


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.imageView.image = self.photos[indexPath.row].image;
    cell.label.text = self.photos[indexPath.row].photoName;
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photos count];
}


@end
