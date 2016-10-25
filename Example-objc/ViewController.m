//
//  ViewController.m
//  Example-objc
//
//  Created by Maxime Epain on 20/10/2016.
//
//

#import <GPXLogger/GPXLogger.h>

#import "ViewController.h"
#import "GPX+MapKit.h"

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) BOOL recording;
@end

@implementation ViewController {
    NSMutableArray<CLLocation *> *_locations;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"gpx"];
    GPXRoot *root = [GPXParser parseGPXAtPath:path];
    
    [self.mapView addAnnotations:root.waypoints];
    [self.mapView showAnnotations:root.waypoints animated:YES];
    
    for (GPXTrack *track in root.tracks) {
        [self addTrack:track];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)rec:(UIButton *)sender {
    self.recording = !self.recording;
    
    UIImage *image = self.recording? [UIImage imageNamed:@"player_record_stop"] : [UIImage imageNamed:@"player_record"];
    [sender setImage:image forState:UIControlStateNormal];
    
    if (self.recording) {
        _locations = [NSMutableArray array];
        
        GPXTrackSegment *segment = [GPXTrackSegment new];
        GPXLogSegment(segment);
    } else {
        GPXSave();
        NSLog(@"GPX file has been saved to %@", GPXPath());
    }
}

#pragma mark <MKMapViewDelegate>

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[GPXTrackSegment class]]) {
        GPXTrackSegmentRenderer *renderer = [[GPXTrackSegmentRenderer alloc] initWithSegment:overlay];
        renderer.strokeColor = [self randColor];
        renderer.lineWidth = 3;
        return renderer;
    }
    
    if ([overlay isKindOfClass:[GPXTrackPoint class]]) {
        GPXTrackPointRenderer *renderer = [[GPXTrackPointRenderer alloc] initWithPoint:overlay];
        renderer.fillColor = [UIColor greenColor];
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = self.view.tintColor;
        renderer.lineWidth = 3;
        return renderer;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.recording) {
        
        CLLocationCoordinate2D coordinate = userLocation.coordinate;
        GPXTrackPoint *point = [GPXTrackPoint trackpointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        point.time = [NSDate date];
        
        GPXLogTrackpoint(point);
        
        [self.mapView setCenterCoordinate:coordinate animated:YES];
        
        if (_locations.count > 0){
            NSInteger sourceIndex = _locations.count - 1;
            
            MKMapPoint points[2];
            points[0] = MKMapPointForCoordinate(_locations[sourceIndex].coordinate);
            points[1] = MKMapPointForCoordinate(coordinate);
            MKPolyline *polyline = [MKPolyline polylineWithPoints:points count:2];
            [self.mapView addOverlay:polyline];
        }
        
        [_locations addObject:userLocation.location];
    }
}

#pragma mark Private

- (void)addTrack:(GPXTrack *)track {
    [self.mapView addOverlays:track.tracksegments];
    
    for (GPXTrackSegment *segment in track.tracksegments) {
        [self.mapView addOverlays:segment.trackpoints];
    }
}

- (UIColor *)randColor {
    CGFloat r = arc4random() % 255 / 255.;
    CGFloat g = arc4random() % 255 / 255.;
    CGFloat b = arc4random() % 255 / 255.;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.];
}

@end
