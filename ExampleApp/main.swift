//
//  File.swift
//  
//
//  Created by Pablo Carcelén on 2/1/23.
//

import Foundation
import ObjectiveRocks


func main() {
    if #available(iOS 16.0, *) {
        let tmp = FileManager.default.temporaryDirectory.appending(component: "\(UUID().uuidString).db").path
        print(tmp)
        let db = RocksDB.database(atPath: tmp) { options in
            options.createIfMissing = true
        }!

        try! db.setData("123".data(using: .utf8)!, forKey: "456".data(using: .utf8)!)
        let data = try! db.data(forKey: "456".data(using: .utf8)!)
        print("Hello World \(String(data: data, encoding: .utf8))")

    }
}
main()
