//
//  QBAlbumsViewController.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAlbumsViewController.h"

#import "AMPhotoLibrary.h"

// Views
#import "QBAlbumCell.h"

// ViewControllers
#import "QBImagePickerController.h"
#import "QBAssetsViewController.h"


static NSString *kAlbumCellIdentifier = @"kAlbumCellIdentifier";

static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface QBImagePickerController (Private)

@property (nonatomic, strong) NSBundle *assetBundle;

@end

@interface QBAlbumsViewController () <AMPhotoLibraryChangeObserver>

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSArray<AMPhotoAlbum *> *photoAlbums;

@end

@implementation QBAlbumsViewController


- (void)dealloc {
    [[AMPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [self setUpToolbarItems];
    
    [self updateAssetCollections];
    
    self.tableView.rowHeight = 86;
    [self.tableView registerClass:QBAlbumCell.class forCellReuseIdentifier:kAlbumCellIdentifier];
    
    [[AMPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Configure navigation item
    self.navigationItem.title = NSLocalizedStringFromTableInBundle(@"albums.title", @"QBImagePicker", self.imagePickerController.assetBundle, nil);
    self.navigationItem.prompt = self.imagePickerController.prompt;
    
    // Show/hide 'Done' button
    if (self.imagePickerController.allowsMultipleSelection) {
        [self.navigationItem setRightBarButtonItem:self.doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
    
    [self updateControlState];
    [self updateSelectionInfo];
}


#pragma mark - Actions

- (void)cancel:(id)sender
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerControllerDidCancel:)]) {
        [self.imagePickerController.delegate qb_imagePickerControllerDidCancel:self.imagePickerController];
    }
}

- (void)done:(id)sender
{
    if ([self.imagePickerController.delegate respondsToSelector:@selector(qb_imagePickerController:didFinishPickingAssets:)]) {
        [self.imagePickerController.delegate qb_imagePickerController:self.imagePickerController
                                               didFinishPickingAssets:self.imagePickerController.selectedAssets.array];
    }
}


#pragma mark - Toolbar

- (void)setUpToolbarItems
{
    // Space
    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem *rightSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    
    // Info label
    NSDictionary *attributes = @{ NSForegroundColorAttributeName: [UIColor blackColor] };
    UIBarButtonItem *infoButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:NULL];
    infoButtonItem.enabled = NO;
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [infoButtonItem setTitleTextAttributes:attributes forState:UIControlStateDisabled];
    
    self.toolbarItems = @[leftSpace, infoButtonItem, rightSpace];
}

- (void)updateSelectionInfo
{
    NSMutableOrderedSet *selectedAssets = self.imagePickerController.selectedAssets;
    
    if (selectedAssets.count > 0) {
        NSBundle *bundle = self.imagePickerController.assetBundle;
        NSString *format;
        if (selectedAssets.count > 1) {
            format = NSLocalizedStringFromTableInBundle(@"assets.toolbar.items-selected", @"QBImagePicker", bundle, nil);
        } else {
            format = NSLocalizedStringFromTableInBundle(@"assets.toolbar.item-selected", @"QBImagePicker", bundle, nil);
        }
        
        NSString *title = [NSString stringWithFormat:format, selectedAssets.count];
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:title];
    } else {
        [(UIBarButtonItem *)self.toolbarItems[1] setTitle:@""];
    }
}


#pragma mark - Fetching Asset Collections

- (void)updateAssetCollections
{
    NSMutableArray<AMPhotoAlbum *> *mutArray = [NSMutableArray array];
    
    [[AMPhotoLibrary sharedPhotoLibrary] enumerateAlbums:^(AMPhotoAlbum *album, BOOL *stop) {
        [mutArray addObject:album];
    } resultBlock:^(BOOL success, NSError *error) {
        
    }];
    
    self.photoAlbums = mutArray;
}

- (UIImage *)placeholderImageWithSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *backgroundColor = [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(244.0 / 255.0) alpha:1.0];
    UIColor *iconColor = [UIColor colorWithRed:(179.0 / 255.0) green:(179.0 / 255.0) blue:(182.0 / 255.0) alpha:1.0];
    
    // Background
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    
    // Icon (back)
    CGRect backIconRect = CGRectMake(size.width * (16.0 / 68.0),
                                     size.height * (20.0 / 68.0),
                                     size.width * (32.0 / 68.0),
                                     size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, backIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(backIconRect, 1.0, 1.0));
    
    // Icon (front)
    CGRect frontIconRect = CGRectMake(size.width * (20.0 / 68.0),
                                      size.height * (24.0 / 68.0),
                                      size.width * (32.0 / 68.0),
                                      size.height * (24.0 / 68.0));
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, -1.0, -1.0));
    
    CGContextSetFillColorWithColor(context, [iconColor CGColor]);
    CGContextFillRect(context, frontIconRect);
    
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, CGRectInset(frontIconRect, 1.0, 1.0));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - Checking for Selection Limit

- (BOOL)isMinimumSelectionLimitFulfilled
{
    return (self.imagePickerController.minimumNumberOfSelection <= self.imagePickerController.selectedAssets.count);
}

- (BOOL)isMaximumSelectionLimitReached
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.imagePickerController.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.imagePickerController.maximumNumberOfSelection) {
        return (self.imagePickerController.maximumNumberOfSelection <= self.imagePickerController.selectedAssets.count);
    }
    
    return NO;
}

- (void)updateControlState
{
    self.doneButton.enabled = [self isMinimumSelectionLimitFulfilled];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoAlbums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:kAlbumCellIdentifier];
    cell.tag = indexPath.row;
    cell.borderWidth = 1.0 / [[UIScreen mainScreen] scale];
    
    // Thumbnail
    AMPhotoAlbum *album = self.photoAlbums[indexPath.row];
        
    switch (self.imagePickerController.mediaType) {
        case QBImagePickerMediaTypeImage:
            album.assetsFilterOption = kAMAssetsFilterOptionImage;
            break;
            
        case QBImagePickerMediaTypeVideo:
            album.assetsFilterOption = kAMAssetsFilterOptionVideo;
            break;
            
        default:
            break;
    }
    
    NSArray<AMPhotoAsset *> *fetchAssets = album.fetchAssets;
    
    CGSize imageSize = CGSizeMake(60, 60);
    
    if (fetchAssets.count >= 3) {
        cell.imageView3.hidden = NO;
        
        [AMPhotoAsset requestImage:fetchAssets[fetchAssets.count - 3]
                     withImageType:AMAssetImageTypeAspectRatioThumbnail
                         beforeRun:^(CGSize *targetSizePointer, AMAssetImageContentMode *contentModePointer, BOOL *shouldCachePointer) {
                             *targetSizePointer = imageSize;
                             *contentModePointer = AMAssetImageContentModeAspectFill;
                         } imageResult:^(UIImage *image) {
                             if (cell.tag == indexPath.row) {
                                 cell.imageView3.image = image;
                             }
                         }];

    } else {
        cell.imageView3.hidden = YES;
    }
    
    if (fetchAssets.count >= 2) {
        cell.imageView2.hidden = NO;
        
        [AMPhotoAsset requestImage:fetchAssets[fetchAssets.count - 2]
                     withImageType:AMAssetImageTypeAspectRatioThumbnail
                         beforeRun:^(CGSize *targetSizePointer, AMAssetImageContentMode *contentModePointer, BOOL *shouldCachePointer) {
                             *targetSizePointer = imageSize;
                             *contentModePointer = AMAssetImageContentModeAspectFill;
                         } imageResult:^(UIImage *image) {
                             if (cell.tag == indexPath.row) {
                                 cell.imageView2.image = image;
                             }
                         }];
        
    } else {
        cell.imageView2.hidden = YES;
    }
    
    if (fetchAssets.count >= 1) {
        [AMPhotoAsset requestImage:fetchAssets[fetchAssets.count - 1]
                     withImageType:AMAssetImageTypeAspectRatioThumbnail
                         beforeRun:^(CGSize *targetSizePointer, AMAssetImageContentMode *contentModePointer, BOOL *shouldCachePointer) {
                             *targetSizePointer = imageSize;
                             *contentModePointer = AMAssetImageContentModeAspectFill;
                         } imageResult:^(UIImage *image) {
                             if (cell.tag == indexPath.row) {
                                 cell.imageView1.image = image;
                             }
                         }];
    }
    
    if (fetchAssets.count == 0) {
        cell.imageView3.hidden = NO;
        cell.imageView2.hidden = NO;
        
        // Set placeholder image
        UIImage *placeholderImage = [self placeholderImageWithSize:imageSize];
        cell.imageView1.image = placeholderImage;
        cell.imageView2.image = placeholderImage;
        cell.imageView3.image = placeholderImage;
    }
    
    // Album title
    cell.titleLabel.text = album.title;
    
    // Number of photos
    cell.countLabel.text = [NSString stringWithFormat:@"%lu", (long)fetchAssets.count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2;
    flowLayout.itemSize = CGSizeMake(77.5, 77.5);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    
    QBAssetsViewController *assetsViewController = [[QBAssetsViewController alloc] initWithCollectionViewLayout:flowLayout];
    assetsViewController.imagePickerController = self.imagePickerController;
    assetsViewController.photoAlbum = self.photoAlbums[indexPath.row];
    [self.navigationController pushViewController:assetsViewController animated:YES];
}


#pragma mark - AMPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(AMPhotoChange *)changeInstance {
    NSMutableArray<AMPhotoAlbum *> *photoAlbums = [self.photoAlbums mutableCopy];
    
    __block BOOL changed = NO;
    [photoAlbums enumerateObjectsUsingBlock:^(AMPhotoAlbum * _Nonnull album, NSUInteger idx, BOOL * _Nonnull stop) {
        AMPhotoChangeDetails *detail = [changeInstance changeDetailsForObject:album];
        if (nil != detail && detail.objectWasChanged) {
            [photoAlbums replaceObjectAtIndex:idx withObject:detail.objectAfterChanges];
            changed = YES;
        }
    }];
    
    if (changed) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoAlbums = photoAlbums;
            [self updateAssetCollections];
            [self.tableView reloadData];
        });
    }
    
}


@end
