//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax
import SwiftParser
import XCTest

final class TypeMetatypeTests: XCTestCase {
  func testBaseType() {
    let cases: [UInt: String] = [
      // Identifiers and member types
      #line: "X",
      #line: "X<T>",
      #line: "X.Y",
      #line: "X.Y<T>",

      // Metatypes
      #line: "X.Type",
      #line: "X.Protocol",
      #line: "X.Type.Type",
      #line: "Any.Type.Type",
      #line: "Self.Type.Type",

      // Sugared optionals
      #line: "X?",
      #line: "X!",

      // Sugared collections
      #line: "[X]",
      #line: "[X : Y]",

      // Tuples and paren type
      #line: "()",
      #line: "(X)",
      #line: "(X, X)",

      // Keywords
      #line: "Any",
      #line: "Self",
    ]

    for (line, baseType) in cases {
      var parser = Parser(baseType)
      let baseTypeSyntax = TypeSyntax.parse(from: &parser)

      for metaKind in ["Type", "Protocol"] {
        AssertParse(
          "\(baseType).\(metaKind)",
          TypeSyntax.parse,
          substructure: Syntax(
            MetatypeTypeSyntax(
              baseType: baseTypeSyntax,
              typeOrProtocol: .contextualKeyword(metaKind)
            )
          ),
          line: line
        )
      }
    }
  }
}
