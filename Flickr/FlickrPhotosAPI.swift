//
//  FlickrPhotosAPI.swift
//  Flickr
//
//  Created by Brian Sunter on 7/21/16.
//  Copyright © 2016 Brian Sunter. All rights reserved.
//

import Foundation
import RxSwift
import Argo

protocol FlickrPhotosAPI {
    func getRecentPhotos() -> Observable<[FlickrPhoto]>
    func getPhotoSearchResults(query: String) -> Observable<[FlickrPhoto]>
}

struct DefaultFlickrAPI: FlickrPhotosAPI {

    private func flickrAPIKey() -> String {
        fatalError("Please return your Flickr API key here!  https://www.flickr.com/services/apps/create/apply")
    }

    private func flickrBaseURL() -> NSURLComponents {
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.flickr.com"
        urlComponents.path = "/services/rest"
        let apiKey = NSURLQueryItem(name: "api_key", value: flickrAPIKey())
        let extras = NSURLQueryItem(name: "extras", value: "url_o,owner_name")
        let format = NSURLQueryItem(name: "format", value: "json")
        let noJsonCallback = NSURLQueryItem(name: "nojsoncallback", value: "1")
        urlComponents.queryItems = [apiKey, extras, format, noJsonCallback]
        return urlComponents
    }

    private func getRecentURL() -> NSURL {
        let method = NSURLQueryItem(name: "method", value: "flickr.photos.getRecent")
        let recentPhotosURLComponents = flickrBaseURL()
        recentPhotosURLComponents.queryItems?.append(method)
        return recentPhotosURLComponents.URL!
    }

    private func searchPhotosURL(query: String) -> NSURL {
        let method = NSURLQueryItem(name: "method", value: "flickr.photos.search")
        let textQuery = NSURLQueryItem(name: "text", value: query)
        let recentPhotosURLComponents = flickrBaseURL()
        recentPhotosURLComponents.queryItems?.appendContentsOf([method, textQuery])
        return recentPhotosURLComponents.URL!
    }

    private func getPhotosAtURL(url: NSURL) -> Observable<[FlickrPhoto]> {
        let request = NSURLRequest(URL: url)
        let responseJSON = NSURLSession.sharedSession().rx_JSON(request)
        return responseJSON.map { json in
            if let photos = json["photos"]??["photo"] as? [AnyObject] {
                return photos.flatMap({ p in Argo.decode(p)})
            } else {
                throw NSError(domain: "Parse Error", code: 1, userInfo: [NSLocalizedDescriptionKey: "response: \(json)"])
            }
        }
    }

    func getRecentPhotos() -> Observable<[FlickrPhoto]> {
        return getPhotosAtURL(getRecentURL())
    }

    func getPhotoSearchResults(query: String) -> Observable<[FlickrPhoto]> {
        return getPhotosAtURL(searchPhotosURL(query))
    }
}
