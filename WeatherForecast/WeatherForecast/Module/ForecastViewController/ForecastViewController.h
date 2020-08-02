//
//  ForecastViewController.h
//  WeatherForecast
//
//  Created by Hanan Ahmed on 01/08/2020.
//  Copyright © 2020 WeatherForecast. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;
#import "WeatherForecast-Bridging-Header.h"
NS_ASSUME_NONNULL_BEGIN

@interface ForecastViewController : UIViewController {
    UICollectionView *_collectionView;
//    ForecastTemperature *forecastData;
}
//@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
//- (void)findCurrentLocation;


@end

NS_ASSUME_NONNULL_END
