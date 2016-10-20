//
//  GPX+MapKit.h
//  GPX
//
//  Created by Maxime Epain on 20/10/2016.
//
//

#import <GPX/GPX.h>
#import <MapKit/MapKit.h>

@interface GPXWaypoint (MapKit) <MKAnnotation>

@end

@interface GPXTrackPoint (MapKit) <MKOverlay>

@end

@interface GPXTrackPointRenderer : MKOverlayRenderer

@property (nonatomic, readonly) GPXTrackPoint *trackPoint;
@property (nonatomic, copy) UIColor *fillColor;

- (instancetype)initWithPoint:(GPXTrackPoint *)point;

@end

@interface GPXTrackSegment (MapKit) <MKOverlay>

@end

@interface GPXTrackSegmentRenderer : MKPolylineRenderer

- (instancetype)initWithSegment:(GPXTrackSegment *)segment;

@end
