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

public protocol PeerDeclarationMacro: DeclarationMacro {
  /// Expand a macro described by the given custom attribute and
  /// attached to the given declaration and evaluated within a
  /// particular expansion context.
  ///
  /// The macro expansion can introduce "peer" declarations that sit alongside
  /// the
  static func expansion(
    of node: CustomAttributeSyntax,
    attachedTo declaration: DeclSyntax,
    in context: inout MacroExpansionContext
  ) throws -> [DeclSyntax]
}
