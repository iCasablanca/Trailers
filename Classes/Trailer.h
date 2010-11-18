//
//  Trailer.h
//  Trailers
//

#import <Foundation/Foundation.h>


@interface Trailer : NSObject {
    NSString    *title;
    NSURL       *imageURL;
    NSString    *duration;
    NSArray     *versions;
}

@property (nonatomic,retain) NSString    *title;
@property (nonatomic,retain) NSURL       *imageURL;
@property (nonatomic,retain) NSString    *duration;
@property (nonatomic,retain) NSArray     *versions;

- (id)initWithDictionary:(NSDictionary*)dict;
+ (Trailer*)trailerWithDictionary:(NSDictionary*)dict;

@end
