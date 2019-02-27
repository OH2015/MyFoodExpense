//
//  extension.swift
//  MyFoodExpense
//
//  Created by 123 on 2019/02/27.
//  Copyright © 2019 123. All rights reserved.
//

import Foundation

extension String {
    func splitInto(_ length: Int) -> [String] {
        var str = self
        for i in 0 ..< (str.count - 1) / max(length, 1) {
            str.insert(",", at: str.index(str.startIndex, offsetBy: (i + 1) * max(length, 1) + i))
        }
        return str.components(separatedBy: ",")
    }
}
