//
//  RawRepresentable.swift
//  MonchCLI
//
//  Created by 安宅正之 on 2020/06/13.
//

import Foundation

extension RawRepresentable where Self.RawValue: Collection {
    var isEmpty: Bool { rawValue.isEmpty }
}
