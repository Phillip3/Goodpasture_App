//
//  FlickrFetcher.m
//
//  Created for Stanford CS193p Winter 2013.
//  Copyright 2013 Stanford University
//  All rights reserved.
//

#import "FlickrFetcher.h"
#import "FlickrAPIKey_Secret.h"


#define FLICKR_PLACE_ID @"place_id"

@implementation FlickrFetcher

+ (NSDictionary *)executeFlickrFetch:(NSString *)query
{
    query = [NSString stringWithFormat:@"%@&format=json&nojsoncallback=1&api_key=%@", query, FLICKR_KEY];
    query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (NSLOG_FLICKR) NSLog(@"[%@ %@] sent %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), query);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:query] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    if (NSLOG_FLICKR) NSLog(@"[%@ %@] received %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), results);
    return results;
}

+ (NSArray *)topPlaces
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.places.getTopPlacesList&place_type_id=7"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"places.place"];
}
//---------------------------------------
//For Goodpasture:
//---------------------------------------
+ (NSArray *) getPhotoSetsForApplicationCollection //returns array of just sets for Goodpasture app
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.collections.getTree&user_id=%@&collection_id=%@", FLICKR_USER_ID, FLICKR_APPLICATION_COLLECTION_ID];
    NSArray *returnValue = [[self executeFlickrFetch:request] valueForKeyPath:@"collections.collection"];
    return [[returnValue lastObject] objectForKey:@"set"];
}
+(NSArray *) getPhotosForPhotoSet:(NSString *) id_string
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&photoset_id=%@", id_string];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photoset.photo"];
}
+(NSArray *) getPhotosForPhotoSet: (NSString *) photosetID withNumberOfPhotos: (int) numberOfPhotos andPageNumber: (int) pageNumber
{    
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photosets.getPhotos&photoset_id=%@&per_page=%i&page=%i", photosetID,numberOfPhotos,pageNumber];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photoset.photo"];
}
//---------------------------------------


+ (NSArray *)photosInPlace:(NSDictionary *)place maxResults:(int)maxResults
{
    NSArray *photos = nil;
    NSString *placeId = [place objectForKey:FLICKR_PLACE_ID];
    if (placeId) {
        NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&place_id=%@&per_page=%d&extras=original_format,tags,description,geo,date_upload,owner_name,place_url", placeId, maxResults];
        NSString *placeName = [place objectForKey:FLICKR_PLACE_NAME];
        photos = [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
        for (NSMutableDictionary *photo in photos) {
            [photo setObject:placeName forKey:FLICKR_PHOTO_PLACE_NAME];
        }
    }
    return photos;
}

+ (NSArray *)latestGeoreferencedPhotos
{
    NSString *request = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&per_page=500&license=1,2,4,7&has_geo=1&extras=original_format,tags,description,geo,date_upload,owner_name,place_url"];
    return [[self executeFlickrFetch:request] valueForKeyPath:@"photos.photo"];
}

+ (NSString *)urlStringForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
	id farm = [photo objectForKey:@"farm"];
	id server = [photo objectForKey:@"server"];
	id photo_id = [photo objectForKey:@"id"];
	id secret = [photo objectForKey:@"secret"];
	if (format == FlickrPhotoFormatOriginal) secret = [photo objectForKey:@"originalsecret"];
    
	NSString *fileType = @"jpg";
	if (format == FlickrPhotoFormatOriginal) fileType = [photo objectForKey:@"originalformat"];
	
	if (!farm || !server || !photo_id || !secret) {
        return nil;
        NSLog(@"****ERROR:: no Photo, returned nil");
    };
	
	NSString *formatString = @"s";
	switch (format) {
		case FlickrPhotoFormatSquare:    formatString = @"s"; break;
		case FlickrPhotoFormatLarge:     formatString = @"b"; break;
        // case FlickrPhotoFormatThumbnail: formatString = @"t"; break;
        case FlickrPhotoFormatLargeSquare: formatString = @"q"; break;
		// case FlickrPhotoFormatSmall:     formatString = @"m"; break;
		// case FlickrPhotoFormatMedium500: formatString = @"-"; break;
		// case FlickrPhotoFormatMedium640: formatString = @"z"; break;
		case FlickrPhotoFormatOriginal:  formatString = @"o"; break;
	}
    
	return [NSString stringWithFormat:@"https://farm%@.static.flickr.com/%@/%@_%@_%@.%@", farm, server, photo_id, secret, formatString, fileType];
}

+ (NSURL *)urlForPhoto:(NSDictionary *)photo format:(FlickrPhotoFormat)format
{
    return [NSURL URLWithString:[self urlStringForPhoto:photo format:format]];
}

@end
