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
import XCTest

final class ExpressionTypeTests: XCTestCase {
  func testTypeExpression() {
    AssertParse("_ = (any Sequence<Int>).self")
  }

  /// Test that `canParseType()` succeeds for these generic arguments.
  // FIXME: This is suboptimal. Instead, we should verify that 'canParseType()'
  // succeeds for all types in a valid parse.
  func testCanParseType() {
    let cases: [UInt: String] = [
      // Identifiers and member types
      #line: "1️⃣X",
      #line: "Y<1️⃣X>",
      #line: "1️⃣X.Y<T>",
      #line: "Y<1️⃣X>.Z<W>",
      #line: "1️⃣X.Y<T>.Z",
      #line: "V<W>.Y.Z<1️⃣X>",
      #line: "1️⃣X?.Y",
      #line: "1️⃣X!.Y",
      #line: "[1️⃣X].Y",
      #line: "[1️⃣X : Y].Z",
      #line: "().Y<1️⃣X>",
      #line: "(1️⃣X).Y",
      #line: "(1️⃣X, Y).Z",
      #line: "Any.Y<1️⃣X>",
      #line: "Self.Y<1️⃣X>",

      // Metatypes
      #line: "1️⃣X.Type",
      #line: "1️⃣X.Protocol",

      // Sugared optionals
      #line: "1️⃣X?",
      #line: "1️⃣X!",

      // Sugared collections
      #line: "[1️⃣X]",
      #line: "[1️⃣X : Y]",

      // Tuples
      #line: "(1️⃣X)",
      #line: "(1️⃣X, X)",

      // Protocol compositions
      #line: "1️⃣X & Y",
      #line: "Any & 1️⃣X",
      #line: "Self & 1️⃣X",
      #line: "any 1️⃣X & Y",
      #line: "any 1️⃣X?.Y & (Y, Z)",

      // Functions
      // FIXME: 'canParseType' cannot handle these.
      //#line: "@convention(witness_method: Y) (1️⃣X) -> ()",
      //#line: #"@convention(c, cType: "intptr_t (*)(size_t)") (1️⃣X) -> Y"#,
      #line: "(1️⃣X) -> Y",
      #line: "(1️⃣X, Y) -> P & Q",
    ]

    for (line, type) in cases {
      AssertParse(
        "G<\(type)>.self",
        ExprSyntax.parse,
        substructure: Syntax(SimpleTypeIdentifierSyntax(name: .identifier("X"))),
        substructureAfterMarker: "1️⃣",
        line: line
      )
    }

    // Void
    AssertParse(
      "G<1️⃣()>.self",
      ExprSyntax.parse,
      substructure: Syntax(TupleTypeSyntax(elements: .init([]))),
      substructureAfterMarker: "1️⃣"
    )

    // Any
    AssertParse(
      "G<1️⃣Any>.self",
      ExprSyntax.parse,
      substructure: Syntax(SimpleTypeIdentifierSyntax(name: .anyKeyword())),
      substructureAfterMarker: "1️⃣"
    )

    // Self
    AssertParse(
      "G<1️⃣Self>.self",
      ExprSyntax.parse,
      substructure: Syntax(SimpleTypeIdentifierSyntax(name: .capitalSelfKeyword())),
      substructureAfterMarker: "1️⃣"
    )
  }
}
