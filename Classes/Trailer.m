//
//  Trailer.m
//  Trailers
//

#import "Trailer.h"


@implementation Trailer

@synthesize title,imageURL, duration, versions;


+ (Trailer*)trailerWithDictionary:(NSDictionary*)dict;
{
    return [[[[self class] alloc] initWithDictionary:dict] autorelease];
}
-(id)initWithDictionary:(NSDictionary*)dict;{
    if ( self = [super init] )
    {
        self.title = [dict objectForKey:@"title"];
        self.duration = [dict objectForKey:@"runtime"];
        self.imageURL = [NSURL URLWithString:[dict objectForKey:@"image"]];
        self.versions = [dict objectForKey:@"versions"];
        NSLog(@"%@",self.title);
    }
    return self;
} 

- (void)dealloc {
    [title release];
    [imageURL release];
    [duration release];
    [versions release];
    [super dealloc];
}

@end
