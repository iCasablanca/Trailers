//
//  Movie.h
//  Trailers
//

#import <Foundation/Foundation.h>
#import "MovieView.h"

typedef enum {
	MovieModePopular,
	MovieModeRecent
} MovieMode;

@interface Movie : NSObject {
    NSString    *title;
    NSURL       *movieURL;
    NSURL       *imageURL;
    NSDate      *releaseDate;
    NSString    *genre;
    NSString    *director;
    NSString    *cast;
    NSString    *description;
    NSArray     *trailers;
    
    MovieView       *view;
    
    NSMutableData *trailersData;
    NSMutableData *pageData;
    NSURLConnection *trailersConnection;
    NSURLConnection *pageConnection;
}

@property (nonatomic,retain) NSString    *title;
@property (nonatomic,retain) NSURL       *movieURL;
@property (nonatomic,retain) NSURL       *imageURL;
@property (nonatomic,retain) NSDate      *releaseDate;
@property (nonatomic,retain) NSString    *genre;
@property (nonatomic,retain) NSString    *director;
@property (nonatomic,retain) NSString    *cast;
@property (nonatomic,retain) NSString    *description;
@property (nonatomic,retain) NSArray     *trailers;

@property (nonatomic,retain) MovieView  *view;

- (id)initWithDictionary:(NSDictionary*)dict;
+ (Movie*)movieWithDictionary:(NSDictionary*)dict;

+ (NSArray*)moviesWithMode:(MovieMode)mode;
+ (NSArray*)moviesWithTerm:(NSString*)term;
+ (NSArray*)moviesFromURL:(NSURL*)url;

- (void)loadMoreInfo;

- (void)setReleaseDateWithString:(NSString*)s;

- (NSArray*)parseTrailersData:(NSData*)data;
- (NSString*)parseHTML:(NSString *)html from:(NSString *)from to:(NSString *)to;
- (NSString *)decodeHTMLEntitiesFromString:(NSString*)string;

@end
