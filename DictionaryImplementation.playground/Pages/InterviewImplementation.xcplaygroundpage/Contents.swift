/*
 This is what I wrote during interview
 This only implement
 - Both key and value are String
 - Use array to store key and value
 - get, set, delete time is O(n)
 See complete implementation for all the requirement
 */
//: [Previous](@previous)

import Foundation

// implement a structure to store key
// implement a structure to store value
// implement a structure to link key & value

// Set<KeyStruct>

/*
 struct DictStruct{
    key
    value
 }
 
 Array<DictStruct>

 HOw do we know it is conflict and jump to next index when fetch for it?
 
 */

class MyDictionary {
    
    class DictStructure {
        let key: String
        var value: String
        
        init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    private static let dictSize = 10
    var keyAndValue: [DictStructure?] = Array(repeating: nil, count: dictSize)
    
    func index(from key: String) -> Int {
        return abs(key.hashValue) % MyDictionary.dictSize
    }
    
    func get(key: String) -> String? {
        
        let idx = index(from: key)
        return keyAndValue[idx]?.value
//        var foundValue: String? = nil
//        keyAndValue.forEach { dict in
//            if key == dict.key {
//                foundValue = dict.value
//            }
//        }
//        return foundValue
    }
    
    func set(key: String, value: String) {
        var foundDict: DictStructure? = nil
            
        var idx = index(from: key)

        if let dict = keyAndValue[idx] {
            if dict.key == key {
                dict.value = value
            } else {
                // handle conflict here
                print("conflict with \(dict.key) and \(dict.value)")
            }
        } else {
            keyAndValue[idx] = DictStructure(key: key, value: value)
        }
//        keyAndValue.forEach { dict in
//            if key == dict.key {
//                foundDict = dict
//            }
//        }
        
//        if let dict = foundDict {
//            dict.value = value
//        }  else {
//            keyAndValue.append(DictStructure(key: key, value: value))
//        }
    }
    
    func delete(key: String) {
        
        let idx = index(from: key)
        if let dict = keyAndValue[idx] {
            keyAndValue[idx] = nil
        }

//        var foundIndex: Int? = nil
//
//        for (i, dict) in keyAndValue.enumerated() {
//            if key == dict.key {
//                foundIndex = i
//            }
//        }
//        if let idx = foundIndex {
//            keyAndValue.remove(at: idx)
//        }
    }
}

var dict = MyDictionary()
dict.set(key: "abc", value: "def")
var str = String(describing: dict.get(key: "abc"))
print(str)
dict.delete(key: "abc")
str = String(describing: dict.get(key: "abc"))
print(str)
print()

// same key , different value
dict.set(key: "abc", value: "def")
dict.set(key: "abc", value: "ghi")
str = String(describing: dict.get(key: "abc"))
print(str)

