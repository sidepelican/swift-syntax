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

import SwiftDiagnostics
import SwiftParser
import SwiftSyntax
import SwiftSyntaxBuilder
import _SwiftSyntaxMacros
import _SwiftSyntaxTestSupport
import XCTest

// MARK: Example macros
public struct StringifyMacro: ExpressionMacro {
  public static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {
    guard let argument = macro.argumentList.first?.expression else {
      // FIXME: Create a diagnostic for the missing argument?
      return ExprSyntax(macro)
    }

    return "(\(argument), \(StringLiteralExprSyntax(content: argument.description)))"
  }
}

/// Replace the label of the first element in the tuple with the given
/// new label.
private func replaceFirstLabel(
  of tuple: TupleExprElementListSyntax,
  with newLabel: String
) -> TupleExprElementListSyntax {
  guard let firstElement = tuple.first else {
    return tuple
  }

  return tuple.replacing(
    childAt: 0,
    with: firstElement.withLabel(.identifier(newLabel))
  )
}

public struct ColorLiteralMacro: ExpressionMacro {
  public static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {
    let argList = replaceFirstLabel(
      of: macro.argumentList,
      with: "_colorLiteralRed"
    )
    let initSyntax: ExprSyntax = ".init(\(argList))"
    if let leadingTrivia = macro.leadingTrivia {
      return initSyntax.withLeadingTrivia(leadingTrivia)
    }
    return initSyntax
  }
}

public struct FileLiteralMacro: ExpressionMacro {
  public static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {
    let argList = replaceFirstLabel(
      of: macro.argumentList,
      with: "fileReferenceLiteralResourceName"
    )
    let initSyntax: ExprSyntax = ".init(\(argList))"
    if let leadingTrivia = macro.leadingTrivia {
      return initSyntax.withLeadingTrivia(leadingTrivia)
    }
    return initSyntax
  }
}

public struct ImageLiteralMacro: ExpressionMacro {
  public static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {
    let argList = replaceFirstLabel(
      of: macro.argumentList,
      with: "imageLiteralResourceName"
    )
    let initSyntax: ExprSyntax = ".init(\(argList))"
    if let leadingTrivia = macro.leadingTrivia {
      return initSyntax.withLeadingTrivia(leadingTrivia)
    }
    return initSyntax
  }
}

public struct FileIDMacro: ExpressionMacro {
  public static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {
    // FIXME: Compiler has more sophisticated file ID computation
    let fileID = "\(context.moduleName)/\(context.fileName)"
    let fileLiteral: ExprSyntax = "\(literal: fileID)"
    if let leadingTrivia = macro.leadingTrivia {
      return fileLiteral.withLeadingTrivia(leadingTrivia)
    }
    return fileLiteral
  }
}

/// Macro whose only purpose is to ensure that we cannot see "out" of the
/// macro expansion syntax node we were given.
struct CheckContextIndependenceMacro: ExpressionMacro {
  static func expansion(
    of macro: MacroExpansionExprSyntax,
    in context: inout MacroExpansionContext
  ) -> ExprSyntax {

    // Should not have a parent.
    XCTAssertNil(macro.parent)

    // Absolute starting position should be zero.
    XCTAssertEqual(macro.position.utf8Offset, 0)

    return ExprSyntax(macro)
  }
}

enum CustomError: Error, CustomStringConvertible {
  case message(String)

  var description: String {
    switch self {
    case .message(let text):
      return text
    }
  }
}

struct SimpleDiagnosticMessage: DiagnosticMessage {
  let message: String
  let diagnosticID: MessageID
  let severity: DiagnosticSeverity
}

extension SimpleDiagnosticMessage: FixItMessage {
  var fixItID: MessageID { diagnosticID }
}

public struct ErrorMacro: FreestandingDeclarationMacro {
  public static func expansion(
    of node: MacroExpansionDeclSyntax,
    in context: inout MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let firstElement = node.argumentList.first,
      let stringLiteral = firstElement.expression
        .as(StringLiteralExprSyntax.self),
      stringLiteral.segments.count == 1,
      case let .stringSegment(messageString) = stringLiteral.segments[0]
    else {
      throw CustomError.message("#error macro requires a string literal")
    }

    context.diagnose(
      Diagnostic(
        node: Syntax(node),
        message: SimpleDiagnosticMessage(
          message: messageString.content.description,
          diagnosticID: MessageID(domain: "test", id: "error"),
          severity: .error
        )
      )
    )

    return []
  }
}

struct DefineBitwidthNumberedStructsMacro: FreestandingDeclarationMacro {
  static func expansion(
    of node: MacroExpansionDeclSyntax,
    in context: inout MacroExpansionContext
  ) throws -> [DeclSyntax] {
    guard let firstElement = node.argumentList.first,
      let stringLiteral = firstElement.expression
        .as(StringLiteralExprSyntax.self),
      stringLiteral.segments.count == 1,
      case let .stringSegment(prefix) = stringLiteral.segments[0]
    else {
      throw CustomError.message(
        "#bitwidthNumberedStructs macro requires a string literal"
      )
    }

    return [8, 16, 32, 64].map { bitwidth in
      """

      struct \(raw: prefix)\(raw: String(bitwidth)) { }
      """
    }
  }
}

public struct AddCompletionHandler: PeerDeclarationMacro {
  public static func expansion(
    of node: CustomAttributeSyntax,
    attachedTo declaration: DeclSyntax,
    in context: inout MacroExpansionContext
  ) throws -> [DeclSyntax] {
    // Only on functions at the moment. We could handle initializers as well
    // with a bit of work.
    guard let funcDecl = declaration.as(FunctionDeclSyntax.self) else {
      throw CustomError.message("@addCompletionHandler only works on functions")
    }

    // This only makes sense for async functions.
    if funcDecl.signature.asyncOrReasyncKeyword == nil {
      throw CustomError.message(
        "@addCompletionHandler requires an async function"
      )
    }

    // Form the completion handler parameter.
    let resultType: TypeSyntax? = funcDecl.signature.output?.returnType.withoutTrivia()

    let completionHandlerParam =
      FunctionParameterSyntax(
        firstName: .identifier("completionHandler"),
        colon: .colonToken(trailingTrivia: .space),
        type: "(\(resultType ?? "")) -> Void" as TypeSyntax
      )

    // Add the completion handler parameter to the parameter list.
    let parameterList = funcDecl.signature.input.parameterList
    let newParameterList: FunctionParameterListSyntax
    if let lastParam = parameterList.last {
      // We need to add a trailing comma to the preceding list.
      newParameterList = parameterList.removingLast()
        .appending(
          lastParam.withTrailingComma(
            .commaToken(trailingTrivia: .space)
          )
        )
        .appending(completionHandlerParam)
    } else {
      newParameterList = parameterList.appending(completionHandlerParam)
    }

    let callArguments: [String] = try parameterList.map { param in
      guard let argName = param.secondName ?? param.firstName else {
        throw CustomError.message(
          "@addCompletionHandler argument must have a name"
        )
      }

      if let paramName = param.firstName, paramName.text != "_" {
        return "\(paramName.withoutTrivia()): \(argName.withoutTrivia())"
      }

      return "\(argName.withoutTrivia())"
    }

    let call: ExprSyntax =
      "\(funcDecl.identifier)(\(raw: callArguments.joined(separator: ", ")))"

    // FIXME: We should make CodeBlockSyntax ExpressibleByStringInterpolation,
    // so that the full body could go here.
    let newBody: ExprSyntax =
      """

        Task {
          completionHandler(await \(call))
        }

      """

    // Drop the @addCompletionHandler attribute from the new declaration.
    let newAttributeList = AttributeListSyntax(
      funcDecl.attributes?.filter {
        guard case let .customAttribute(customAttr) = $0 else {
          return true
        }

        return customAttr != node
      } ?? []
    )

    let newFunc =
      funcDecl
      .withSignature(
        funcDecl.signature
          .withAsyncOrReasyncKeyword(nil)  // drop async
          .withOutput(nil)  // drop result type
          .withInput(  // add completion handler parameter
            funcDecl.signature.input.withParameterList(newParameterList)
              .withoutTrailingTrivia()
          )
      )
      .withBody(
        CodeBlockSyntax(
          leftBrace: .leftBraceToken(leadingTrivia: .space),
          statements: CodeBlockItemListSyntax(
            [CodeBlockItemSyntax(item: .expr(newBody))]
          ),
          rightBrace: .rightBraceToken(leadingTrivia: .newline)
        )
      )
      .withAttributes(newAttributeList)
      .withLeadingTrivia(.newlines(2))

    return [DeclSyntax(newFunc)]
  }
}

// MARK: Assertion helper functions

/// Assert that expanding the given macros in the original source produces
/// the given expanded source code.
///
/// - Parameters:
///   - macros: The macros that should be expanded, provided as a dictionary
///     mapping macro names (e.g., `"stringify"`) to implementation types
///     (e.g., `StringifyMacro.self`).
///   - testModuleName: The name of the test module to use.
///   - testFileName: The name of the test file name to use.
///   - originalSource: The original source code, which is expected to contain
///     macros in various places (e.g., `#stringify(x + y)`).
///   - expandedSource: The source code that we expect to see after performing
///     macro expansion on the original source.
public func AssertMacroExpansion(
  macros: [String: Macro.Type],
  testModuleName: String = "TestModule",
  testFileName: String = "test.swift",
  _ originalSource: String,
  _ expandedSource: String,
  diagnosticStrings: [String] = [],
  file: StaticString = #file,
  line: UInt = #line
) {
  // Parse the original source file.
  let origSourceFile = Parser.parse(source: originalSource)

  // Expand all macros in the source.
  var context = MacroExpansionContext(
    moduleName: testModuleName,
    fileName: testFileName
  )
  let expandedSourceFile = origSourceFile.expand(macros: macros, in: &context)

  AssertStringsEqualWithDiff(
    expandedSourceFile.description,
    expandedSource,
    file: file,
    line: line
  )

  let diags = context.diagnostics
  XCTAssertEqual(diags.count, diagnosticStrings.count)
  for (actualDiag, expectedDiag) in zip(diags, diagnosticStrings) {
    let actualMessage = actualDiag.message
    XCTAssertEqual(actualMessage, expectedDiag)
  }
}

// MARK: Tests

/// The set of test macros we use here.
public let testMacros: [String: Macro.Type] = [
  "checkContext": CheckContextIndependenceMacro.self,
  "colorLiteral": ColorLiteralMacro.self,
  "fileID": FileIDMacro.self,
  "imageLiteral": ImageLiteralMacro.self,
  "stringify": StringifyMacro.self,
  "myError": ErrorMacro.self,
  "bitwidthNumberedStructs": DefineBitwidthNumberedStructsMacro.self,
  "addCompletionHandler": AddCompletionHandler.self,
]

final class MacroSystemTests: XCTestCase {
  func testExpressionExpansion() {
    AssertMacroExpansion(
      macros: testMacros,
      """
      let b = #stringify(x + y)
      #colorLiteral(red: 0.5, green: 0.5, blue: 0.25, alpha: 1.0)
      """,
      """
      let b = (x + y, "x + y")
      .init(_colorLiteralRed: 0.5, green: 0.5, blue: 0.25, alpha: 1.0)
      """
    )
  }

  func testStringifyExpression() {
    AssertMacroExpansion(
      macros: ["stringify": StringifyMacro.self],
      """
      _ = #stringify({ () -> Bool in
        print("hello")
        return true
      })
      """,
      """
      _ = ({ () -> Bool in
        print("hello")
        return true
      }, #"{ () -> Bool in\\#n  print("hello")\\#n  return true\\#n}"#)
      """
    )
  }

  func testFileExpansions() {
    AssertMacroExpansion(
      macros: testMacros,
      testModuleName: "MyModule",
      testFileName: "taylor.swift",
      """
      let b = #fileID
      """,
      """
      let b = "MyModule/taylor.swift"
      """
    )
  }

  func testContextUniqueLocalNames() {
    var context = MacroExpansionContext(
      moduleName: "MyModule",
      fileName: "taylor.swift"
    )

    let t1 = context.createUniqueLocalName()
    let t2 = context.createUniqueLocalName()
    XCTAssertNotEqual(t1.description, t2.description)
    XCTAssertEqual(t1.description, "__macro_local_0")
  }

  func testContextIndependence() {
    AssertMacroExpansion(
      macros: ["checkContext": CheckContextIndependenceMacro.self],
      """
      let b = #checkContext
      """,
      """
      let b = #checkContext
      """
    )
  }

  func testErrorExpansion() {
    AssertMacroExpansion(
      macros: testMacros,
      """
      #myError("please don't do that")
      struct X {
        func f() { }
        #myError(bad)
        func g() {
          #myError("worse")
        }
      }
      """,
      """

      struct X {
        func f() { }
        func g() {
        }
      }
      """,
      diagnosticStrings: [
        "please don't do that",
        "#error macro requires a string literal",
        "worse",
      ]
    )
  }

  func testBitwidthNumberedStructsExpansion() {
    AssertMacroExpansion(
      macros: testMacros,
      """
      #bitwidthNumberedStructs("MyInt")
      """,
      """

      struct MyInt8 { }
      struct MyInt16 { }
      struct MyInt32 { }
      struct MyInt64 { }
      """
    )
  }

  func testAddCompletionHandler() {
    AssertMacroExpansion(
      macros: testMacros,
      """
      @addCompletionHandler
      func f(a: Int, for b: String, _ value: Double) async -> String { }
      """,
      """

      func f(a: Int, for b: String, _ value: Double) async -> String { }

      func f(a: Int, for b: String, _ value: Double, completionHandler: (String) -> Void) {
        Task {
          completionHandler(await f(a: a, for: b, value))
        }
      }
      """
    )
  }
}
