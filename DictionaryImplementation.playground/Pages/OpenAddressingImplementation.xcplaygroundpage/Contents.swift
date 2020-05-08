/*
 Open addressing Implementation
 This implements
 - Both key and value are String
 - Use array to store key and value
 - get, set, delete time complexity
 success: 1/alpha * ln(1/(1-alpha))
 unsuccess: 1/(1-alpha)
 alpha = n/m (m: space, n: object number)
 */

import Foundation

class MyDictionary {
    
    class DictStructure {
        var key: String
        var value: String
        var isDeleted: Bool = false
        
        init(key: String, value: String) {
            self.key = key
            self.value = value
        }
    }
    
    private static var initialSize = 5
    private var storage: [DictStructure?] = Array(repeating: nil, count: initialSize)
    private var usageCount = 0.0
    private var thresholdRate = 0.5
    
    private func index(from key: String) -> Int {
        return abs(key.hashValue) % MyDictionary.initialSize
    }
    
    private func nextIndex(from idx: Int) -> Int {
        // There are some common probing method, for example
        // - Linear Probing
        // - Quadratic Probing
        // - Double Hashing
        // We implement Linear Probing here
        var index = idx + 1
        if index == storage.count {
            index = 0
        }
        return index
    }

    /// Return empty or isdeleted == true index
    /// - Parameters:
    ///   - idx: index position
    private func probAvailableIndex(from idx: Int) -> Int? {
        var index = idx
        var count = 1
        while storage[index] != nil && storage[index]?.isDeleted == false {
            index = nextIndex(from: index)
            count += 1
            if count > storage.count {
                // loop through all space, didn't find dictionary or empty space
                return nil
            }
            
        }
        return index
    }

    /// Return DictStructure and index from starting index and key.
    /// If DictStructure exist, index exist.
    /// If DictStructure does not exist and index exist, index represnet empty slot
    /// If both not exist, the storage run out of space and does not find DictStructure
    /// - Parameters:
    ///   - idx: index position
    ///   - key: key of dictionary
    private func probDictAndIndex(for key: String, from idx: Int) -> (DictStructure?, Int?) {
        guard let _ = storage[idx] else {
            // current index is empty and dictionary not exist
            return (nil, idx)
        }

        var index = idx
        var count = 1
        while storage[index] != nil {
            if let dict = storage[index],
                dict.key == key,
                dict.isDeleted == false {
                // found dictionary at index
                return (dict, index)
            }

            index = nextIndex(from: index)
            count += 1
            if count > storage.count {
                // loop through all space, didn't find dictionary or empty space
                return (nil, nil)
            }
            
        }
        //reach empty slot index
        return (nil, index)

    }
    
    /// Double space
    private func expandAndRehash() {
        print(#function)
        let currentStorage = storage
        storage = Array(repeating: nil, count: storage.count * 2)
        usageCount = 0
        for dict in currentStorage {
            if let dic = dict,
                dic.isDeleted == false {
                set(key: dic.key, value: dic.value)
            }
        }
    }

        
    func get(key: String) -> String? {
        let idx = index(from: key)
        let dict = probDictAndIndex(for: key, from: idx).0
        print("get key: \(key), return \(dict?.value)")
        return dict?.value
    }
    
    func set(key: String, value: String) {
        print("set \(key): \(value)")
        
        // expand storage array size if usage rate is over threshold
        if (usageCount / Double(storage.count)) > thresholdRate {
            expandAndRehash()
        }
        
        let idx = index(from: key)
        let dictAndIndex = probDictAndIndex(for: key, from: idx)
        if let dict = dictAndIndex.0 {
            print("key: \(key) exist, replace value: \(dict.value) with \(value) ")
            dict.value = value
        } else if let i = probAvailableIndex(from: idx) {
            print("key: \(key) not exist, store value: \(value) at \(i) ")
            storage[i] = DictStructure(key: key, value: value)
            usageCount += 1
        } else {
            print("Warning: Run out of space!")
        }
    }
    
    func delete(key: String) {
        let idx = index(from: key)
        let dictAndIndex = probDictAndIndex(for: key, from: idx)
        print("delete key: \(key)")
        if dictAndIndex.0?.isDeleted == false,
            let i = dictAndIndex.1 {
            dictAndIndex.0?.isDeleted = true
            usageCount -= 1
            print("Found value: \(dictAndIndex.0?.value), deleted dict at index: \(i)")
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
print()

//test chain delete
dict.delete(key: "1")
dict.delete(key: "2")
dict.delete(key: "3")
dict.set(key: "7", value: "7")
dict.set(key: "8", value: "8")
dict.set(key: "9", value: "9")
dict.set(key: "10", value: "10")
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

