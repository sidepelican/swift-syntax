//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import SwiftSyntax
import SwiftParser

/// Describes a macro that forms declarations.
public protocol FreestandingDeclarationMacro: DeclarationMacro {
  /// Expand a macro described by the given freestanding macro expansion
  /// declaration within the given context to produce a set of declarations.
  static func expansion(
    of node: MacroExpansionDeclSyntax,
    in context: inout MacroExpansionContext
  ) throws -> [DeclSyntax]
}
