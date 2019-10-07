//
//  MasterViewController.m
//  Cake List
//
//  Created by Stewart Hart on 19/05/2015.
//  Copyright (c) 2015 Stewart Hart. All rights reserved.
//

#import "MasterViewController.h"
#import "CakeCell.h"

#import <Cake_List-Swift.h>

@interface MasterViewController ()
@property (strong, nonatomic) NSArray<Cake*> *objects;

@end

NSString* const cakeCellIdentifier = @"CakeCell";

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CakeCell *cell = (CakeCell*)[tableView dequeueReusableCellWithIdentifier:cakeCellIdentifier];
    
    Cake *cake = self.objects[indexPath.row];
    cell.titleLabel.text = cake.title;
    cell.descriptionLabel.text = cake.desc;
 
    
    NSURL *aURL = cake.image;
    NSData *data = [NSData dataWithContentsOfURL:aURL];
    UIImage *image = [UIImage imageWithData:data];
    [cell.cakeImageView setImage:image];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)getData{
    
    [CakeList loadCakes:^(NSArray<Cake *> * cakes) {
        // make sure we are back on the main/ui thread
        dispatch_async(dispatch_get_main_queue(), ^{
            self.objects = cakes;
            [self.tableView reloadData];
        });
    }];
}

@end
