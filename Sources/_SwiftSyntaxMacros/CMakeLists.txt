# This source file is part of the Swift.org open source project
#
# Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for Swift project authors

add_swift_host_library(_SwiftSyntaxMacros
  DeclarationMacro.swift
  ExpressionMacro.swift
  FreestandingDeclarationMacro.swift
  Macro.swift
  MacroExpansionContext.swift
  MacroSystem.swift
  PeerDeclarationMacro.swift
  Syntax+MacroEvaluation.swift
)

target_link_libraries(_SwiftSyntaxMacros PUBLIC
  SwiftParser
  SwiftSyntaxBuilder
  )
