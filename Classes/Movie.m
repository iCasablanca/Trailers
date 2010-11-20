//
//  Movie.m
//  Trailers
//

#import "Movie.h"
#import "Trailer.h"
#import "CJSONDeserializer.h"


@implementation Movie

@synthesize title, movieURL, imageURL, releaseDate, genre, director, cast, description, trailers, view;

+ (NSArray*)moviesWithMode:(MovieMode)mode;
{
    NSURL *url;
	if(mode == MovieModePopular){
		url = [NSURL URLWithString:@"http://trailers.apple.com/trailers/home/feeds/most_pop.json"];
	}else{
		url = [NSURL URLWithString:@"http://trailers.apple.com/trailers/home/feeds/just_added.json"];
	}
    
    return [Movie moviesFromURL:url];
}

+ (NSArray*)moviesWithTerm:(NSString*)term;
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://trailers.apple.com/trailers/home/scripts/quickfind.php?q=%@",[term stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [Movie moviesFromURL:url];
}

+ (NSArray*)moviesFromURL:(NSURL*)url;
{
    NSMutableArray *result = [NSMutableArray array];
    NSData *data = [NSData dataWithContentsOfURL:url];
	
	CJSONDeserializer *jsonDeserializer = [CJSONDeserializer deserializer];
	NSArray *movies = [jsonDeserializer deserialize:data error:nil];
	
	BOOL isSearch = NO;
	if( [movies isKindOfClass:[NSDictionary class]] ){
		movies = [(NSDictionary*)movies objectForKey:@"results"];
		isSearch = YES;
	}
	
    for (NSDictionary *movie in movies) {
        [result addObject:[Movie movieWithDictionary:movie]];
	}
    
    return (NSArray*)result;
}

+ (Movie*)movieWithDictionary:(NSDictionary*)dict;
{
	return [[[[self class] alloc] initWithDictionary:dict] autorelease];
}
-(id)initWithDictionary:(NSDictionary*)dict;{
	if ( self = [super init] )
	{
		self.title = [dict objectForKey:@"title"];
		self.movieURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://apple.com%@",[dict objectForKey:@"location"]]];
		self.imageURL = [NSURL URLWithString:[dict objectForKey:@"poster"]];
		if( [self.imageURL host] == NULL ){
			NSString *newURL = [NSString stringWithFormat:@"http://trailers.apple.com%@",[self.imageURL path]];
			NSLog(@"%@",newURL);
			self.imageURL = [NSURL URLWithString:newURL];
		}
		[self setReleaseDateWithString:[dict objectForKey:@"releasedate"]];
		
		self.director = [dict objectForKey:@"directors"];
		self.genre = [dict objectForKey:@"genre"];
		if( [self.genre isKindOfClass:[NSArray class]] ){
			//WIERD SEARCH BUG
			if( [[(NSArray*)self.genre lastObject] intValue] != 0 ){
				self.genre = NULL;
			}else{
				self.genre = [(NSArray*)self.genre componentsJoinedByString:@", "];
			}
		}
		
		self.cast = [dict objectForKey:@"actors"];
		if( [self.cast isKindOfClass:[NSArray class]] )
			self.cast = [(NSArray*)self.cast componentsJoinedByString:@", "];
		
		
	}
	return self;
} 

- (void)setReleaseDateWithString:(NSString*)s;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, d LLL u H:m:s"];
    self.releaseDate = [dateFormatter dateFromString:s];
}

- (void)loadMoreInfo;
{
    pageConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:self.movieURL] delegate:self];
    [pageConnection start];
    pageData = [[NSMutableData alloc] init];
	
    NSRange range = [[self.movieURL relativeString] rangeOfString:@"/trailers"];
    NSString *path = [[self.movieURL relativeString] substringFromIndex:range.location];
    NSURL *trailersURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://trailers.apple.com%@includes/playlists/web.inc",path]];
    
    trailersConnection = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:trailersURL] delegate:self];
    [trailersConnection start];
    trailersData = [[NSMutableData alloc] init];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == pageConnection ){
        [pageData appendData:data];
    }else if(connection == trailersConnection ){
        [trailersData appendData:data];
    }
}
- (void) connectionDidFinishLoading: (NSURLConnection*) connection {	
    if (connection == pageConnection){
        NSString *html = [[NSString alloc] initWithData:pageData encoding:NSASCIIStringEncoding];
        [html retain];
        
        //DESCRIPTION
        NSRange range = [html rangeOfString:@"<div id=\"more-description\" class=\"read-more-container\">"];
        if(range.location==NSNotFound){
            range = [html rangeOfString:@"<div id=\"movie-description\""];
        }
        if(range.location==NSNotFound){
            /*
             [detail setDescription:@"Movie not supported."];
             [detail layoutSubviews];
             [detail stopAnimating];
             return;
             */
        }
        range.location += range.length;
        range = [html rangeOfString:@"<p>" options:0 range:NSMakeRange(range.location, [html length]-range.location)];
        range.location += range.length;
        range.length = [html rangeOfString:@"</p>" options:0 range:NSMakeRange(range.location, [html length]-range.location)].location - range.location;
        
        self.description = [self decodeHTMLEntitiesFromString:[html substringWithRange:range]];
        
        if( self.genre == NULL ){
            
            NSMutableArray *genreSplit = [NSMutableArray arrayWithArray:[[self parseHTML:html from:@"<dt>Genre:" to:@"<dt"] componentsSeparatedByString:@"<a href=\""]];
            
            if( [genreSplit count] > 1 ){
                [genreSplit removeObjectAtIndex:0];
            }else{
                genreSplit = [NSMutableArray arrayWithArray:[[self parseHTML:html from:@"<strong>Genre:</strong><span" to:@"</li>"] componentsSeparatedByString:@"<a href=\""]];
                if( [genreSplit count] > 1 ){
                    [genreSplit removeObjectAtIndex:0];
                }
            }
            for(int i=0;i<[genreSplit count];i++){
                NSString *genreHtml = [genreSplit objectAtIndex:i];
                [genreSplit removeObjectAtIndex:i];
                [genreSplit insertObject:[self parseHTML:genreHtml from:@">" to:@"<"] atIndex:i];
            }
            
            self.genre = [genreSplit componentsJoinedByString:@", "];
            
            if( [self.genre isEqual:@""] ){
                self.genre = [self parseHTML:html from:@"<dt>Genre:</dt><dd>" to:@"</dd"];
            }
            
        }
        
        if( self.director == NULL ){
            self.director = [self parseHTML:html from:@"<strong>Director:</strong><span>" to:@"</span>"];
            
            if( [self.director isEqual:@""] ){
                self.director = [self parseHTML:html from:@"<dt>Director:</dt><dd>" to:@"</dd>"];
            }
            
        }
        
        [self.view updateDetailDescription];
		
    }else if (connection == trailersConnection){
        NSArray *trailersDicts = [self parseTrailersData:trailersData];
        NSMutableArray *trailersArray = [NSMutableArray array];
        
        for(NSDictionary *dict in trailersDicts){
            [trailersArray addObject:[Trailer trailerWithDictionary:dict]];
        }
        
        self.trailers = trailersArray;
        
        [self.view updateDetailTrailers];
    }
}

#pragma mark parser helpers
- (NSArray*)parseTrailersData:(NSData*)data{
	NSString *html = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
	NSMutableArray *trailersArray = [NSMutableArray array]; 
	
	if( [html rangeOfString:@"<div class=\"top\">"].location != NSNotFound ){
		
		if( [html rangeOfString:@"<ul class=\"trailer-nav\">"].location != NSNotFound ){
			
			NSMutableArray *titlesSplit = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:@"<span class=\"text\""]];
			NSMutableArray *trailersSplit = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:@"<div class=\"section"]];
			
			if( [titlesSplit count] > 1 && [trailersSplit count] > 1 ){
				
				[titlesSplit removeObjectAtIndex:0];
				[trailersSplit removeObjectAtIndex:0];
				
				
				for(NSString *titlesHTML in titlesSplit){
					NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
					
					[dict setObject:[self parseHTML:titlesHTML from:@">" to:@"<"] forKey:@"title"];
					[trailersArray addObject:dict];
				}
				
				for(int i=0;i<[trailersSplit count];i++){
					NSString *trailersHTML = [trailersSplit objectAtIndex:i];
					
					NSMutableArray *resolutionSplit = [NSMutableArray arrayWithArray:[trailersHTML componentsSeparatedByString:@"<li>"]];
					
					if( [resolutionSplit count] > 1 ){
						
						[resolutionSplit removeObjectAtIndex:0];
						
						NSMutableArray *resolutionArray = [[NSMutableArray alloc] init];
						
						for(NSString *resolutionHTML in resolutionSplit){
							NSMutableDictionary *resolutionDict = [[NSMutableDictionary alloc] init];
							
							[resolutionDict setObject:[self parseHTML:resolutionHTML from:@"href=\"" to:@"\""] forKey:@"link"];
							
							NSString *resolution = [self parseHTML:resolutionHTML from:@"height=" to:@"\""];
							
							if( [resolution isEqual:@""] ){
								resolution = [self parseHTML:resolutionHTML from:@"alt=\"" to:@"\""];
							}else{
								resolution = [NSString stringWithFormat:@"%@p",resolution];
							}
							[resolutionDict setObject:resolution forKey:@"resolution"];
							
							[resolutionArray addObject:resolutionDict];
						}
						
						[[trailersArray objectAtIndex:i] setObject:resolutionArray forKey:@"versions"];
					}
				}
				
			}
			
		}else{
			
			NSMutableDictionary *trailerDict = [[NSMutableDictionary alloc] init];
			
			[trailerDict setObject:[self parseHTML:html from:@"<h3>" to:@"</h3>"] forKey:@"title"];		
			
			NSMutableArray *resolutionSplit = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:@"<li>"]];
			
			if( [resolutionSplit count] > 1 ){
				
				[resolutionSplit removeObjectAtIndex:0];
				
				NSMutableArray *resolutionArray = [[NSMutableArray alloc] init];
				
				for(NSString *resolutionHTML in resolutionSplit){
					NSMutableDictionary *resolutionDict = [[NSMutableDictionary alloc] init];
					
					[resolutionDict setObject:[self parseHTML:resolutionHTML from:@"href=\"" to:@"\""] forKey:@"link"];
					
					NSString *resolution = [self parseHTML:resolutionHTML from:@"height=" to:@"\""];
					
					if( [resolution isEqual:@""] ){
						resolution = [self parseHTML:resolutionHTML from:@"alt=\"" to:@"\""];
					}else{
						resolution = [NSString stringWithFormat:@"%@p",resolution];
					}
					[resolutionDict setObject:resolution forKey:@"resolution"];
					
					[resolutionArray addObject:resolutionDict];
				}
				
				[trailerDict setObject:resolutionArray forKey:@"versions"];
				
				[trailersArray addObject:trailerDict];
				
			}			
			
		}
		
	}else if( [html rangeOfString:@"<div id=\"trailers-dropdown\">"].location != NSNotFound ){
		
		NSMutableArray *trailersSplit = [NSMutableArray arrayWithArray:[html componentsSeparatedByString:@"<div class=\"column first\">"]];
		
		if( [trailersSplit count] > 1 ){
			
			[trailersSplit removeObjectAtIndex:0];
			
		}
		if( [html rangeOfString:@"<span id=\"single-trailer-info\">"].location != NSNotFound ){
			
			trailersSplit = [[NSMutableArray alloc] init];
			[trailersSplit addObject:html];
			
		}
		
		for(NSString *trailersHTML in trailersSplit){
			
			NSMutableDictionary *trailerDict = [[NSMutableDictionary alloc] init];
			
			[trailerDict setObject:[self parseHTML:trailersHTML from:@"<h3>" to:@"</h3>"] forKey:@"title"];
			[trailerDict setObject:[self parseHTML:trailersHTML from:@"<br />Runtime: " to:@"</p>"] forKey:@"runtime"];
			[trailerDict setObject:[self parseHTML:trailersHTML from:@"<img src=\"" to:@"\""] forKey:@"image"];
			
			NSMutableArray *resolutionSplit = [NSMutableArray arrayWithArray:[[self parseHTML:trailersHTML from:@"<li><h4>Download</h4></li>" to:@"</ul>"] componentsSeparatedByString:@"<li class=\"hd\">"]];
			
			if( [resolutionSplit count] > 1 ){
				
				[resolutionSplit removeObjectAtIndex:0];
				
				NSMutableArray *resolutionArray = [[NSMutableArray alloc] init];
				
				for(NSString *resolutionHTML in resolutionSplit){
					NSMutableDictionary *resolutionDict = [[NSMutableDictionary alloc] init];
					
					[resolutionDict setObject:[self parseHTML:resolutionHTML from:@"<a href=\"" to:@"\""] forKey:@"link"];
					[resolutionDict setObject:[self parseHTML:resolutionHTML from:@"\"target-quicktimeplayer\">" to:@" "] forKey:@"resolution"];
					[resolutionDict setObject:[self parseHTML:resolutionHTML from:@" (" to:@")"] forKey:@"size"];
					
					[resolutionArray addObject:resolutionDict];
				}
				
				[trailerDict setObject:resolutionArray forKey:@"versions"];
				
				[trailersArray addObject:trailerDict];
				
			}
		}
		
	}
	
	return trailersArray;
}
- (NSString *)parseHTML:(NSString*)html from:(NSString*)from to:(NSString*)to{
	NSRange range = [html rangeOfString:from];
	NSString *result = NULL;
	
	if(range.location != NSNotFound){
		range.location += range.length;
		
		NSRange rangeEnd = [html rangeOfString:to options:0 range:NSMakeRange(range.location, [html length]-range.location)];
		
		if(rangeEnd.location != NSNotFound){
			range.length = rangeEnd.location - range.location;
			result = [html substringWithRange:range];
		}
	}
	
	if( result == NULL ){
		result = [NSString stringWithString:@""];
	}
	
	return result;
}
- (NSString *)decodeHTMLEntitiesFromString:(NSString*)string{
	NSUInteger myLength = [string length];
	NSUInteger ampIndex = [string rangeOfString:@"&" options:NSLiteralSearch].location;
	
	// Short-circuit if there are no ampersands.
	if (ampIndex == NSNotFound) {
		return string;
	}
	// Make result string with some extra capacity.
	NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
	
	// First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
	NSScanner *scanner = [NSScanner scannerWithString:string];
	
	[scanner setCharactersToBeSkipped:nil];
	
	NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
	
	do {
		// Scan up to the next entity or the end of the string.
		NSString *nonEntityString;
		if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
			[result appendString:nonEntityString];
		}
		if ([scanner isAtEnd]) {
			goto finish;
		}
		// Scan either a HTML or numeric character entity reference.
		if ([scanner scanString:@"&#x2019;" intoString:NULL])
			[result appendString:@"'"];
		else if ([scanner scanString:@"&amp;" intoString:NULL])
			[result appendString:@"&"];
		else if ([scanner scanString:@"&acute;" intoString:NULL])
			[result appendString:@"'"];
		else if ([scanner scanString:@"&eacute;" intoString:NULL])
			[result appendString:@"é"];
		else if ([scanner scanString:@"&rsquo;" intoString:NULL])
			[result appendString:@"'"];
		else if ([scanner scanString:@"&hellip;" intoString:NULL])
			[result appendString:@"..."];
		else if ([scanner scanString:@"&ldquo;" intoString:NULL])
			[result appendString:@"\""];
		else if ([scanner scanString:@"&rdquo;" intoString:NULL])
			[result appendString:@"\""];
		else if ([scanner scanString:@"&mdash;" intoString:NULL])
			[result appendString:@"-"];
		else if ([scanner scanString:@"&apos;" intoString:NULL])
			[result appendString:@"'"];
		else if ([scanner scanString:@"&quot;" intoString:NULL])
			[result appendString:@"\""];
		else if ([scanner scanString:@"&ndash;" intoString:NULL])
			[result appendString:@"-"];
		else if ([scanner scanString:@"&lt;" intoString:NULL])
			[result appendString:@"<"];
		else if ([scanner scanString:@"&gt;" intoString:NULL])
			[result appendString:@">"];
		else if ([scanner scanString:@"&#" intoString:NULL]) {
			BOOL gotNumber;
			unsigned charCode;
			NSString *xForHex = @"";
			
			// Is it hex or decimal?
			if ([scanner scanString:@"x" intoString:&xForHex]) {
				gotNumber = [scanner scanHexInt:&charCode];
			}
			else {
				gotNumber = [scanner scanInt:(int*)&charCode];
			}
			
			if (gotNumber) {
				[result appendFormat:@"%C", charCode];
				[scanner scanString:@";" intoString:NULL];
			}
			else {
				NSString *unknownEntity = @"";                         
				[scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
				[result appendFormat:@"&#%@%@", xForHex, unknownEntity];
				//[scanner scanUpToString:@";" intoString:&unknownEntity];
				//[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
			}
			
		}
		else {
			NSString *amp;
			//an isolated & symbol
			[scanner scanString:@"&" intoString:&amp];
			[result appendString:amp];
		}
	}
	while (![scanner isAtEnd]);
	
finish:
	return result;
}


- (void)dealloc {
    [title release];
    [movieURL release];
    [imageURL release];
    [releaseDate release];
    [genre release];
    [director release];
    [cast release];
    [description release];
    [trailers release];
    [view release];
    [trailersData release];
    [pageData release];
    [trailersConnection release];
    [pageConnection release];
    [super dealloc];
}

@end
