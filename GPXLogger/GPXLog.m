//
//  GPXLog.m
//  GPX
//
//  Created by Maxime Epain on 24/10/2016.
//
//

#import "GPXLog.h"

@interface GPXLog : NSObject

@property (nonatomic, readonly) NSString *path;

@property (nonatomic, readonly) GPXRoot *gpx;

- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

+ (GPXLog *)sharedLog;

+ (void)setSharedLog:(GPXLog *)log;

- (void)save;

@end

void GPXSetLogFile(NSString *path) {
    GPXLog *log = [[GPXLog alloc] initWithPath:path];
    [GPXLog setSharedLog:log];
}

NSString *GPXGetLogFile() {
    return [GPXLog sharedLog].path;
}

void GPXSetCreator(NSString *creator) {
    [GPXLog sharedLog].gpx.creator = creator;
}

void GPXSetVersion(NSString *version) {
    [GPXLog sharedLog].gpx.version = version;
}

void GPXSetMetadata(GPXMetadata *metadata) {
    [GPXLog sharedLog].gpx.metadata = metadata;
}

void GPXLogWaypoint(GPXWaypoint *waypoint) {
    [[GPXLog sharedLog].gpx addWaypoint:waypoint];
}

void GPXLogTrack(GPXTrack *track) {
    [[GPXLog sharedLog].gpx addTrack:track];
}

void GPXLogSegment(GPXTrackSegment *segment) {
    GPXRoot *gpx = [GPXLog sharedLog].gpx;
    
    GPXTrack *track = gpx.tracks.lastObject;
    if (!track) {
        track = [gpx newTrack];
    }
    [track addTracksegment:segment];
}

void GPXLogTrackpoint(GPXTrackPoint *trackpoint) {
    GPXRoot *gpx = [GPXLog sharedLog].gpx;
    
    GPXTrack *track = gpx.tracks.lastObject;
    if (!track) {
        track = [gpx newTrack];
    }
    
    GPXTrackSegment *segment = track.tracksegments.lastObject;
    if (!segment) {
        segment = [track newTrackSegment];
    }
    [segment addTrackpoint:trackpoint];
}

void GPXLogRoute(GPXRoute *route) {
    [[GPXLog sharedLog].gpx addRoute:route];
}

void GPXLogRoutepoint(GPXRoutePoint *routepoint) {
    GPXRoot *gpx = [GPXLog sharedLog].gpx;
    
    GPXRoute *route = gpx.routes.lastObject;
    if (!route) {
        route = [gpx newRoute];
    }
    [route addRoutepoint:routepoint];
}

void GPXSave() {
    [[GPXLog sharedLog] save];
}

@implementation GPXLog

static GPXLog *sharedLog = nil;

- (instancetype)init {
    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [directory stringByAppendingPathComponent:@"log.gpx"];
    return [self initWithPath:path];
}

- (instancetype)initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
        _gpx = [GPXParser parseGPXAtPath:path];
    }
    return self;
}

+ (GPXLog *)sharedLog {
    if (!sharedLog) {
        sharedLog = [[GPXLog alloc] init];
    }
    return sharedLog;
}

+ (void)setSharedLog:(GPXLog *)log {
    sharedLog = log;
}

- (void)save {
    [self.gpx saveToPath:self.path error:nil];
}

@end
