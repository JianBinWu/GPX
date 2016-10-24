//
//  GPXLog.h
//  GPX
//
//  Created by Maxime Epain on 24/10/2016.
//
//

#import <Foundation/Foundation.h>
#import <GPX/GPX.h>

NS_ASSUME_NONNULL_BEGIN

extern void GPXSetPath(NSString *path) NS_SWIFT_NAME(GPX.set(path:));

extern NSString * _Nullable GPXPath(void) NS_SWIFT_NAME(GPX.path());

extern void GPXSetCreator(NSString *creator) NS_SWIFT_NAME(GPX.set(creator:));

extern void GPXSetVersion(NSString *version) NS_SWIFT_NAME(GPX.set(version:));

extern void GPXSetMetadata(GPXMetadata *metadata) NS_SWIFT_NAME(GPX.set(metadata:));

extern void GPXLogWaypoint(GPXWaypoint *waypoint) NS_SWIFT_NAME(GPX.log(waypoint:));

extern void GPXLogTrack(GPXTrack *track) NS_SWIFT_NAME(GPX.log(track:));

extern void GPXLogSegment(GPXTrackSegment *segment) NS_SWIFT_NAME(GPX.log(segment:));

extern void GPXLogTrackpoint(GPXTrackPoint *trackpoint) NS_SWIFT_NAME(GPX.log(trackpoint:));

extern void GPXLogRoute(GPXRoute *route) NS_SWIFT_NAME(GPX.log(route:));

extern void GPXLogRoutepoint(GPXRoutePoint *routepoint) NS_SWIFT_NAME(GPX.log(routepoint:));

extern void GPXSave(void) NS_SWIFT_NAME(GPX.save());

NS_ASSUME_NONNULL_END
