//
//  DetailViewController.m
//  Cats
//
//  Created by Alejandro Zielinsky on 2018-04-26.
//  Copyright © 2018 Alejandro Zielinsky. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = self.photo.image;
    self.name.text = self.photo.photoName;
    [self getDetailedInfoForPhoto];
}

- (IBAction)viewInFlickr:(UIButton *)sender
{
    NSURL* url = [[NSURL alloc] initWithString:self.photo.flickrURL];
    UIApplication *mySafari = [UIApplication sharedApplication];
    [mySafari openURL:url];
}

-(void)getDetailedInfoForPhoto
{
    
    NSString *temp = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&api_key=12b4f5ab7547f2de3140c989f974d48e&photo_id=%@",self.photo.identifier];
    
    NSURL *url = [[NSURL alloc] initWithString:temp];
    
    NSURLRequest *request;
    request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionTask *task  = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                              completionHandler:^(NSData * _Nullable data,
                                                                                  NSURLResponse * _Nullable response, NSError * _Nullable error)
                               {
                                   NSLog(@"got result");
                                   NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   
                                   NSDictionary *photoItems = results[@"photo"];
                                   NSDictionary *description = photoItems[@"description"];
                                   NSString *descriptionContent = description[@"_content"];
                                   NSDictionary *comments = photoItems[@"comments"];
                                   NSString *commentContent = comments[@"_content"];
                                   
                                   NSDictionary *urls = photoItems[@"urls"];
                                   NSArray *flickrURL = urls[@"url"];
                                   NSDictionary *url = flickrURL[0];
                                   NSString *urlContent = url[@"_content"];
                                   
                                   self.photo.flickrURL = urlContent;
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^
                                   {
                                   self.descriptionLabel.text = [[NSString alloc] initWithString:descriptionContent];
                                   self.commentsLabel.text = [[NSString alloc] initWithString:commentContent];
                                   });
                               }];
    
    [task resume];
    
    
}



@end
