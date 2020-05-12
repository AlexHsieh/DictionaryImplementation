/*
 Any key Implementation
 This implements
 - Key can be struct. value can be anything
 - Use array to store dictionary structure
 - Conflict resolution use chaining
 - Implement For loop
 */

import Foundation

struct MyDictionary<Key: Hashable, Value> {
    
    class DictStructure {
        let key: Key
        var value: Value
        var next: DictStructure?
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    private let storageSize: Int = 5
    
    fileprivate var storage: [DictStructure?]

    init() {
        storage = Array(repeating: nil, count: storageSize)
    }
        
    private func index(from key: Key) -> Int {
        return abs(key.hashValue) % storageSize
    }
    
    private mutating func object(from idx: Int, with key: Key) -> DictStructure? {
        var ds: DictStructure? = storage[idx]
        while ds != nil {
            if ds?.key == key {
                return ds
            }
            ds = ds?.next
        }
        return nil
    }
    
    private mutating func lastObject(at: Int) -> DictStructure? {
        var ds: DictStructure? = storage[at]
        while ds?.next != nil {
            ds = ds?.next
        }
        return ds
    }
    
    private mutating func chain(obj: DictStructure, at: Int) {
        guard let lastObj = lastObject(at: at) else {
            // no obj at current index
            print("no obj at current index: \(at), save [\(obj.key): \(obj.value)]")
            storage[at] = obj
            return
        }
        // conflict at sam eindex. chain the obj at the end
        print("conflict at current index: \(at)")
        lastObj.next = obj
    }
    
    mutating func get(key: Key) -> Value? {
        let idx = index(from: key)
        let value = object(from: idx, with: key)?.value
        print("get key: \(key), return \(String(describing: value))")
        return value
    }
    
    mutating func set(key: Key, value: Value) {
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
    
    mutating func delete(key: Key) {
        print("delete \(key)")
        let idx = index(from: key)
        if var dict = storage[idx] {
            if dict.key == key {
                storage[idx] = dict.next
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

extension MyDictionary: ExpressibleByDictionaryLiteral {
    init(dictionaryLiteral elements: (Key, Value)...) {
        self.init()
        for (key, value) in elements {
            set(key: key, value: value)
        }
    }
}

extension MyDictionary {
    subscript(key: Key) -> Value? {
        mutating get {
            return get(key: key)
        }
        mutating set(newValue) {
            if let x = newValue {
                set(key: key, value: x)
            } else {
                delete(key: key)
            }
        }
    }
}

extension MyDictionary: Sequence {
    
    func makeIterator() -> Iterator {
        return Iterator(storage)
    }
    
    struct Iterator: IteratorProtocol {
        var array: [(Key, Value?)] = []
        var index = 0
        
        init(_ storage: [DictStructure?]) {
            for dictionary in storage {
                var d = dictionary
                while d != nil {
                    array.append((d!.key, d!.value))
                    d = d!.next
                }
            }
        }

        mutating func next() -> (Key, Value?)? {
            if index < array.count {
                let kv = array[index]
                index += 1
                return kv
            }
            return nil
        }
    }
    
}


// Test case
// Literial Test

// set dict
var dict: MyDictionary<String, String?> = ["1": "1"]
dict["1"]
print()

// delete dict
dict.delete(key: "1")
dict["1"]
print()

// same key , different value
dict["1"] = "1"
dict["1"] = "1.1"
dict["1"]
print()

// nil test
dict = ["1": nil]
dict["1"]
dict["1"] = nil
dict["1"]
print()

// conflict
dict["2"] = "2"
dict["3"] = "3"
dict["4"] = "4"
dict["5"] = "5"
dict["6"] = "6"
print()

//test chain delete
dict.delete(key: "1")
dict.delete(key: "2")
dict.delete(key: "3")

for (key, value) in dict {
    print("Key: \(key) with Value:\(String(describing: value))")
}
