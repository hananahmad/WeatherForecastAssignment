//
//  ForecastViewController.m
//  WeatherForecast
//
//  Created by Hanan Ahmed on 01/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

#import "ForecastViewController.h"

@interface ForecastViewController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *forecastData;
//ForecastTemperature *forecastData;

@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _locationManager = [[CLLocationManager alloc] init];
//    _locationManager.delegate = self;
//    LocationManager *location = [LocationManager shared];
//    [location getLocation( completionHandler: ^(CLLocation * _Nullable, NSError * _Nullable)) {
//
//    }];
    
    
    
//    [[LocationManager shared] getLocationWithCompletionHandler:^(CLLocation * _Nullable location, NSError * _Nullable error) {
//
//    }];
}
/*
- (void) configureCollectionView {
             
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"ForecastTableViewCell" bundle:nil] forCellWithReuseIdentifier:@"ForecastTableViewCell"];
    _collectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight);
    
//    [_collectionView setDataSource:self];
//    [_collectionView setDelegate:self];
    
    [self.view addSubview:_collectionView];
}

//- (UICollectionViewLayout *) createCompositionalLayout {
//
//    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger section, id<NSCollectionLayoutEnvironment> _Nonnull provider) {
//        printf("");
//        [self createForecastSection];
////        UICollectionViewCompositionalLayoutConfiguration *config = [[UICollectionViewCompositionalLayoutConfiguration alloc] init];
////        layout.configuration = config;
////
////        return layout;
//    }];
//
//    return layout;
//
////    let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
////        self.createForecastSection()
////    }
////
////    let config = UICollectionViewCompositionalLayoutConfiguration()
////    layout.configuration = config
////    return layout
//}

//- (NSCollectionLayoutSection *) createForecastSection {
//    NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension: [NSCollectionLayoutDimension fractionalWidthDimension:1] heightDimension: [NSCollectionLayoutDimension fractionalHeightDimension:1]];
//    NSCollectionLayoutItem *layoutItem = [NSCollectionLayoutItem initialize]
//}

//- (void)findCurrentLocation {
//    self.isFirstUpdate = YES;
//    [self.locationManager startUpdatingLocation];
//}
//
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
//    // 1
//    if (self.isFirstUpdate) {
//        self.isFirstUpdate = NO;
//        return;
//    }
//
//    CLLocation *location = [locations lastObject];
//
//    // 2
//    if (location.horizontalAccuracy > 0) {
//        // 3
//        self.currentLocation = location;
//        [self.locationManager stopUpdatingLocation];
//    }
//}

#pragma UICollectionViewDataSource
 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.forecastData.count;
}
*/
@end
