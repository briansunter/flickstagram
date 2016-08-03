//
//  Photo.swift
//  Flickr
//
//  Created by Brian Sunter on 7/21/16.
//  Copyright © 2016 Brian Sunter. All rights reserved.
//

import Foundation
import Argo
import Curry

struct FlickrPhoto {
    let title: String
    let author: String
    let url: NSURL
}

extension NSURL: Decodable {
    public static func decode(j: JSON) -> Decoded<NSURL> {
        switch(j) {
        case let .String(s): return .fromOptional(NSURL(string: s))
        default: return .Failure(.TypeMismatch(expected: "URL", actual: j.description))
        }
    }
}

extension FlickrPhoto: Decodable {
    static func decode(j: JSON) -> Decoded<FlickrPhoto> {
        return curry(FlickrPhoto.init)
            <^> j <| "title"
            <*> j <| "ownername"
            <*> j <| "url_o"
    }
}
