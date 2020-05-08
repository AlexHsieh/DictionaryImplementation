/*
 Chaining Implementation
 This implements
 - Both key and value are String
 - Use array to store key and value
 - get, set, delete time complexity is O(1 + alpha), alpha = n/m (m: space, n: object number)
 
 */

import Foundation

class MyDictionary {
    
    class DictStructure {
        let key: String
        var value: String
        var next: DictStructure?
        
        init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    private static let dictSize = 5
    var keyAndValue: [DictStructure?] = Array(repeating: nil, count: dictSize)
    
    private func index(from key: String) -> Int {
        return abs(key.hashValue) % MyDictionary.dictSize
    }
    
    private func object(from idx: Int, with key: String) -> DictStructure? {
        var ds: DictStructure? = keyAndValue[idx]
        while ds != nil {
            if ds?.key == key {
                return ds
            }
            ds = ds?.next
        }
        return nil
    }
    
    private func lastObject(at: Int) -> DictStructure? {
        var ds: DictStructure? = keyAndValue[at]
        while ds?.next != nil {
            ds = ds?.next
        }
        return ds
    }
    
    private func chain(obj: DictStructure, at: Int) {
        guard let lastObj = lastObject(at: at) else {
            // no obj at current index
            print("no obj at current index: \(at), save [\(obj.key): \(obj.value)]")
            keyAndValue[at] = obj
            return
        }
        // conflict at sam eindex. chain the obj at the end
        print("conflict at current index: \(at)")
        lastObj.next = obj
    }
    
    func get(key: String) -> String? {
        let idx = index(from: key)
        let value = object(from: idx, with: key)?.value
        print("get key: \(key), return \(value)")
        return value
    }
    
    func set(key: String, value: String) {
        print("set \(key): \(value)")
        let idx = index(from: key)
        if let dict = object(from: idx, with: key) {
            // key exist
            print("key: \(key) exist, replace value: \(dict.value) with \(value) ")
            dict.value = value
        } else {
            // key does not exist
            chain(obj: DictStructure(key: key, value: value), at: idx)
        }
    }
    
    func delete(key: String) {
        print("delete \(key)")
        let idx = index(from: key)
        if var dict = keyAndValue[idx] {
            if dict.key == key {
                keyAndValue[idx] = dict.next
            } else {
                while dict.next != nil {
                    if dict.next?.key == key {
                        dict.next = dict.next?.next
                        return
                    }
                    dict = dict.next!
                }
            }
        }

    }
}

// Test case
// set dict
var dict = MyDictionary()
dict.set(key: "1", value: "1")
dict.get(key: "1")
print()

// delete dict
dict.delete(key: "1")
dict.get(key: "1")
print()

// same key , different value
dict.set(key: "1", value: "1")
dict.set(key: "1", value: "1.1")
dict.get(key: "1")
print()

// conflict
dict.set(key: "2", value: "2")
dict.set(key: "3", value: "3")
dict.set(key: "4", value: "4")
dict.set(key: "5", value: "5")
dict.set(key: "6", value: "6")
dict.set(key: "7", value: "7")
dict.set(key: "8", value: "8")
dict.set(key: "9", value: "9")
dict.set(key: "10", value: "10")
print()

//test chain delete
dict.delete(key: "1")
dict.delete(key: "2")
dict.delete(key: "3")
dict.delete(key: "4")
dict.delete(key: "5")
dict.get(key: "1")
dict.get(key: "2")
dict.get(key: "3")
dict.get(key: "4")
dict.get(key: "5")
dict.get(key: "6")
dict.get(key: "7")
dict.get(key: "8")
dict.get(key: "9")
dict.get(key: "10")
