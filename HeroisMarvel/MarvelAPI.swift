//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by Israel3D on 18/06/2018.
//  Copyright © 2018 Israel3D. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    
    static private let basepath = "https://gateway.marvel.com/v1/public/characters?"
    static private let privateKey = "cd00c969a6285e3cc4992ff41ea4f4c8b3a42ddc"
    static private let publicKey = "2bb07766e1619e2a92851dab2427de2b"
    static private let limit = 50
    
    class func loadHeroes(name:String?, page:Int = 0, onComplete: @escaping (MarvelInfo?) -> Void){
        let offset = page * limit
        let startsWith:String
        
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))&"
        }else{
            startsWith = ""
        }
        
        let url = basepath + "offset=\(offset)&limit=\(limit)&" + startsWith + getCredentials()
        print(url)
        Alamofire.request(url).responseJSON { (response) in
            let decode: JSONDecoder = JSONDecoder()
            guard let data = response.data,
                  let marvelInfo = try? decode.decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
        }
        
    }
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey)
        return "ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
    
}
