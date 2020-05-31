//
//  XWWWFormUrlEncoder.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/05/30.
//

import Foundation

// refs. https://stackoverflow.com/questions/45169254/custom-swift-encoder-decoder-for-the-strings-resource-format?rq=1
final class XWWWFormUrlEncoder {
    func encode<T>(_ value: T) throws -> Data where T : Encodable {
        let encoding = XWWWFormUrlEncoding()
        try value.encode(to: encoding)
        return format(from: encoding.storage.strings)
    }

    private func format(from keyValues: [String: String]) -> Data {
        keyValues
            .map { (key, value) in "\(key)=\(value)" }
            .joined(separator: "&")
            .data(using: .utf8)!
    }
}

fileprivate struct XWWWFormUrlEncoding: Encoder {
    fileprivate final class Storage {
        private(set) var strings: [String: String] = [:]

        func push(key codingKey: [CodingKey], value: String) {
            let key = codingKey.map { $0.stringValue }.joined(separator: ".")
            strings[key] = value
        }
    }
    fileprivate var storage: Storage

    init(storage: Storage = Storage()) {
        self.storage = storage
    }

    var codingPath: [CodingKey] = []

    var userInfo: [CodingUserInfoKey : Any] = [:]

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = XWWWFormUrlKeyedEncoding<Key>(storage: storage, codingPath: codingPath)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        XWWWFormUrlUnkeyedEncoding(storage: storage, codingPath: codingPath)
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        XWWWFormUrlSingleValueEncoding(storage: storage, codingPath: codingPath)
    }
}

fileprivate struct XWWWFormUrlKeyedEncoding<Key: CodingKey>: KeyedEncodingContainerProtocol {

    private let storage: XWWWFormUrlEncoding.Storage
    var codingPath: [CodingKey]

    init(storage: XWWWFormUrlEncoding.Storage, codingPath: [CodingKey]) {
        self.storage = storage
        self.codingPath = codingPath
    }

    mutating func encodeNil(forKey key: Key) throws {}
    mutating func encode(_ value: Bool,   forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: String, forKey key: Key) throws { storage.push(key: codingPath + [key], value: value) }
    mutating func encode(_ value: Double, forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Float,  forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Int,    forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Int8,   forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Int16,  forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Int32,  forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: Int64,  forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: UInt,   forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: UInt8,  forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: UInt16, forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: UInt32, forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }
    mutating func encode(_ value: UInt64, forKey key: Key) throws { storage.push(key: codingPath + [key], value: String(describing: value)) }

    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        var encoding = XWWWFormUrlEncoding(storage: storage)
        encoding.codingPath.append(key)
        try value.encode(to: encoding)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let container = XWWWFormUrlKeyedEncoding<NestedKey>(storage: storage, codingPath: codingPath + [key])
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        XWWWFormUrlUnkeyedEncoding(storage: storage, codingPath: codingPath + [key])
    }

    mutating func superEncoder() -> Encoder {
        let superKey = Key(stringValue: "super")!
        return superEncoder(forKey: superKey)
    }

    mutating func superEncoder(forKey key: Key) -> Encoder {
        var encoding = XWWWFormUrlEncoding(storage: storage)
        encoding.codingPath.append(key)
        return encoding
    }
}

fileprivate struct XWWWFormUrlUnkeyedEncoding: UnkeyedEncodingContainer {

    private let storage: XWWWFormUrlEncoding.Storage
    var codingPath: [CodingKey]
    private(set) var count: Int = 0

    init(storage: XWWWFormUrlEncoding.Storage, codingPath: [CodingKey]) {
        self.storage = storage
        self.codingPath = codingPath
    }

    private struct IndexedCodingKey: CodingKey {
        var intValue: Int?
        var stringValue: String

        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = String(describing: intValue)
        }

        init?(stringValue: String) { nil }
    }

    private mutating func nextIndexedKey() -> CodingKey {
        defer { count += 1 }
        return IndexedCodingKey(intValue: count)!
    }

    mutating func encodeNil() throws { _ = nextIndexedKey() }
    mutating func encode(_ value: Bool)   throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: String) throws { storage.push(key: codingPath + [nextIndexedKey()], value: value) }
    mutating func encode(_ value: Double) throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Float)  throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Int)    throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Int8)   throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Int16)  throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Int32)  throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: Int64)  throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: UInt)   throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: UInt8)  throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: UInt16) throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: UInt32) throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }
    mutating func encode(_ value: UInt64) throws { storage.push(key: codingPath + [nextIndexedKey()], value: String(describing: value)) }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        var encoding = XWWWFormUrlEncoding(storage: storage)
        encoding.codingPath = codingPath
        try value.encode(to: encoding)
    }

    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let container = XWWWFormUrlKeyedEncoding<NestedKey>(storage: storage, codingPath: codingPath + [nextIndexedKey()])
        return KeyedEncodingContainer(container)
    }

    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        XWWWFormUrlUnkeyedEncoding(storage: storage, codingPath: codingPath + [nextIndexedKey()])
    }

    mutating func superEncoder() -> Encoder {
        var encoding = XWWWFormUrlEncoding(storage: storage)
        encoding.codingPath.append(nextIndexedKey())
        return encoding
    }
}

fileprivate struct XWWWFormUrlSingleValueEncoding: SingleValueEncodingContainer {

    private let storage: XWWWFormUrlEncoding.Storage
    var codingPath: [CodingKey]
    private(set) var count: Int = 0

    init(storage: XWWWFormUrlEncoding.Storage, codingPath: [CodingKey]) {
        self.storage = storage
        self.codingPath = codingPath
    }

    mutating func encodeNil() throws {}
    mutating func encode(_ value: Bool)   throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: String) throws { storage.push(key: codingPath, value: value) }
    mutating func encode(_ value: Double) throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Float)  throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Int)    throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Int8)   throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Int16)  throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Int32)  throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: Int64)  throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: UInt)   throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: UInt8)  throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: UInt16) throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: UInt32) throws { storage.push(key: codingPath, value: String(describing: value)) }
    mutating func encode(_ value: UInt64) throws { storage.push(key: codingPath, value: String(describing: value)) }

    mutating func encode<T>(_ value: T) throws where T : Encodable {
        var encoding = XWWWFormUrlEncoding(storage: storage)
        encoding.codingPath = codingPath
        try value.encode(to: encoding)
    }
}
