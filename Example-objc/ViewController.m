//
//  ViewController.m
//  Example-objc
//
//  Created by Maxime Epain on 20/10/2016.
//
//

#import "ViewController.h"
#import "GPX+MapKit.h"
#import <MapKit/MapKit.h>

@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

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

- (void)addTrack:(GPXTrack *)track {
    [self.mapView addOverlays:track.tracksegments];
    for (GPXTrackSegment *segment in track.tracksegments) {
        [self.mapView addOverlays:segment.trackpoints];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    return nil;
}

- (UIColor *)randColor {
    CGFloat r = arc4random() % 255 / 255.;
    CGFloat g = arc4random() % 255 / 255.;
    CGFloat b = arc4random() % 255 / 255.;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.];
}

@end
