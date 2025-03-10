

//// Automatically Generated by generate-swiftsyntax
//// Do Not Edit Directly!
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

@frozen // FIXME: Not actually stable, works around a miscompile
public enum SyntaxKind {
  case token
  
  case accessLevelModifier
  
  case accessPathComponent
  
  case accessPath
  
  case accessorBlock
  
  case accessorDecl
  
  case accessorList
  
  case accessorParameter
  
  case actorDecl
  
  case arrayElementList
  
  case arrayElement
  
  case arrayExpr
  
  case arrayType
  
  case arrowExpr
  
  case asExpr
  
  case asTypePattern
  
  case assignmentExpr
  
  case associatedtypeDecl
  
  case attributeList
  
  case attribute
  
  case attributedType
  
  case availabilityArgument
  
  case availabilityCondition
  
  case availabilityEntry
  
  case availabilityLabeledArgument
  
  case availabilitySpecList
  
  case availabilityVersionRestriction
  
  case awaitExpr
  
  case backDeployAttributeSpecList
  
  case backDeployVersionArgument
  
  case backDeployVersionList
  
  case binaryOperatorExpr
  
  case booleanLiteralExpr
  
  case borrowExpr
  
  case breakStmt
  
  case caseItemList
  
  case caseItem
  
  case catchClauseList
  
  case catchClause
  
  case catchItemList
  
  case catchItem
  
  case classDecl
  
  case classRestrictionType
  
  case closureCaptureItemList
  
  case closureCaptureItem
  
  case closureCaptureSignature
  
  case closureExpr
  
  case closureParamList
  
  case closureParam
  
  case closureSignature
  
  case codeBlockItemList
  
  case codeBlockItem
  
  case codeBlock
  
  case compositionTypeElementList
  
  case compositionTypeElement
  
  case compositionType
  
  case conditionElementList
  
  case conditionElement
  
  case conformanceRequirement
  
  case constrainedSugarType
  
  case continueStmt
  
  case conventionAttributeArguments
  
  case conventionWitnessMethodAttributeArguments
  
  case customAttribute
  
  case declModifierDetail
  
  case declModifier
  
  case declNameArgumentList
  
  case declNameArgument
  
  case declNameArguments
  
  case declName
  
  case declarationStmt
  
  case deferStmt
  
  case deinitializerDecl
  
  case derivativeRegistrationAttributeArguments
  
  case designatedTypeElement
  
  case designatedTypeList
  
  case dictionaryElementList
  
  case dictionaryElement
  
  case dictionaryExpr
  
  case dictionaryType
  
  case differentiabilityParamList
  
  case differentiabilityParam
  
  case differentiabilityParamsClause
  
  case differentiabilityParams
  
  case differentiableAttributeArguments
  
  case discardAssignmentExpr
  
  case doStmt
  
  case editorPlaceholderExpr
  
  case enumCaseDecl
  
  case enumCaseElementList
  
  case enumCaseElement
  
  case enumCasePattern
  
  case enumDecl
  
  case exprList
  
  case expressionPattern
  
  case expressionSegment
  
  case expressionStmt
  
  case extensionDecl
  
  case fallthroughStmt
  
  case floatLiteralExpr
  
  case forInStmt
  
  case forcedValueExpr
  
  case functionCallExpr
  
  case functionDeclName
  
  case functionDecl
  
  case functionParameterList
  
  case functionParameter
  
  case functionSignature
  
  case functionType
  
  case genericArgumentClause
  
  case genericArgumentList
  
  case genericArgument
  
  case genericParameterClause
  
  case genericParameterList
  
  case genericParameter
  
  case genericRequirementList
  
  case genericRequirement
  
  case genericWhereClause
  
  case guardStmt
  
  case hasSymbolCondition
  
  case identifierExpr
  
  case identifierPattern
  
  case ifConfigClauseList
  
  case ifConfigClause
  
  case ifConfigDecl
  
  case ifStmt
  
  case implementsAttributeArguments
  
  case implicitlyUnwrappedOptionalType
  
  case importDecl
  
  case inOutExpr
  
  case infixOperatorExpr
  
  case inheritedTypeList
  
  case inheritedType
  
  case initializerClause
  
  case initializerDecl
  
  case integerLiteralExpr
  
  case isExpr
  
  case isTypePattern
  
  case keyPathComponentList
  
  case keyPathComponent
  
  case keyPathExpr
  
  case keyPathOptionalComponent
  
  case keyPathPropertyComponent
  
  case keyPathSubscriptComponent
  
  case labeledSpecializeEntry
  
  case labeledStmt
  
  case layoutRequirement
  
  case macroDecl
  
  case macroExpansionDecl
  
  case macroExpansionExpr
  
  case matchingPatternCondition
  
  case memberAccessExpr
  
  case memberDeclBlock
  
  case memberDeclListItem
  
  case memberDeclList
  
  case memberTypeIdentifier
  
  case metatypeType
  
  case missingDecl
  
  case missingExpr
  
  case missingPattern
  
  case missingStmt
  
  case missing
  
  case missingType
  
  case modifierList
  
  case moveExpr
  
  case multipleTrailingClosureElementList
  
  case multipleTrailingClosureElement
  
  case namedAttributeStringArgument
  
  case namedOpaqueReturnType
  
  case nilLiteralExpr
  
  case nonEmptyTokenList
  
  case objCSelectorPiece
  
  case objCSelector
  
  case opaqueReturnTypeOfAttributeArguments
  
  case operatorDecl
  
  case operatorPrecedenceAndTypes
  
  case optionalBindingCondition
  
  case optionalChainingExpr
  
  case optionalPattern
  
  case optionalType
  
  case packElementExpr
  
  case packExpansionExpr
  
  case packExpansionType
  
  case packReferenceType
  
  case parameterClause
  
  case patternBindingList
  
  case patternBinding
  
  case postfixIfConfigExpr
  
  case postfixUnaryExpr
  
  case poundAssertStmt
  
  case poundColumnExpr
  
  case poundErrorDecl
  
  case poundSourceLocationArgs
  
  case poundSourceLocation
  
  case poundWarningDecl
  
  case precedenceGroupAssignment
  
  case precedenceGroupAssociativity
  
  case precedenceGroupAttributeList
  
  case precedenceGroupDecl
  
  case precedenceGroupNameElement
  
  case precedenceGroupNameList
  
  case precedenceGroupRelation
  
  case prefixOperatorExpr
  
  case primaryAssociatedTypeClause
  
  case primaryAssociatedTypeList
  
  case primaryAssociatedType
  
  case protocolDecl
  
  case qualifiedDeclName
  
  case regexLiteralExpr
  
  case repeatWhileStmt
  
  case returnClause
  
  case returnStmt
  
  case sameTypeRequirement
  
  case sequenceExpr
  
  case simpleTypeIdentifier
  
  case sourceFile
  
  case specializeAttributeSpecList
  
  case specializeExpr
  
  case stringLiteralExpr
  
  case stringLiteralSegments
  
  case stringSegment
  
  case structDecl
  
  case subscriptDecl
  
  case subscriptExpr
  
  case superRefExpr
  
  case switchCaseLabel
  
  case switchCaseList
  
  case switchCase
  
  case switchDefaultLabel
  
  case switchStmt
  
  case symbolicReferenceExpr
  
  case targetFunctionEntry
  
  case ternaryExpr
  
  case throwStmt
  
  case tokenList
  
  case tryExpr
  
  case tupleExprElementList
  
  case tupleExprElement
  
  case tupleExpr
  
  case tuplePatternElementList
  
  case tuplePatternElement
  
  case tuplePattern
  
  case tupleTypeElementList
  
  case tupleTypeElement
  
  case tupleType
  
  case typeAnnotation
  
  case typeExpr
  
  case typeInheritanceClause
  
  case typeInitializerClause
  
  case typealiasDecl
  
  case unavailabilityCondition
  
  case unexpectedNodes
  
  case unresolvedAsExpr
  
  case unresolvedIsExpr
  
  case unresolvedPatternExpr
  
  case unresolvedTernaryExpr
  
  case valueBindingPattern
  
  case variableDecl
  
  case versionTuple
  
  case whereClause
  
  case whileStmt
  
  case wildcardPattern
  
  case yieldExprListElement
  
  case yieldExprList
  
  case yieldList
  
  case yieldStmt
  
  public var isSyntaxCollection: Bool {
    switch self {
    case .accessPath: 
      return true
    case .accessorList: 
      return true
    case .arrayElementList: 
      return true
    case .attributeList: 
      return true
    case .availabilitySpecList: 
      return true
    case .backDeployVersionList: 
      return true
    case .caseItemList: 
      return true
    case .catchClauseList: 
      return true
    case .catchItemList: 
      return true
    case .closureCaptureItemList: 
      return true
    case .closureParamList: 
      return true
    case .codeBlockItemList: 
      return true
    case .compositionTypeElementList: 
      return true
    case .conditionElementList: 
      return true
    case .declNameArgumentList: 
      return true
    case .designatedTypeList: 
      return true
    case .dictionaryElementList: 
      return true
    case .differentiabilityParamList: 
      return true
    case .enumCaseElementList: 
      return true
    case .exprList: 
      return true
    case .functionParameterList: 
      return true
    case .genericArgumentList: 
      return true
    case .genericParameterList: 
      return true
    case .genericRequirementList: 
      return true
    case .ifConfigClauseList: 
      return true
    case .inheritedTypeList: 
      return true
    case .keyPathComponentList: 
      return true
    case .memberDeclList: 
      return true
    case .modifierList: 
      return true
    case .multipleTrailingClosureElementList: 
      return true
    case .nonEmptyTokenList: 
      return true
    case .objCSelector: 
      return true
    case .patternBindingList: 
      return true
    case .precedenceGroupAttributeList: 
      return true
    case .precedenceGroupNameList: 
      return true
    case .primaryAssociatedTypeList: 
      return true
    case .specializeAttributeSpecList: 
      return true
    case .stringLiteralSegments: 
      return true
    case .switchCaseList: 
      return true
    case .tokenList: 
      return true
    case .tupleExprElementList: 
      return true
    case .tuplePatternElementList: 
      return true
    case .tupleTypeElementList: 
      return true
    case .unexpectedNodes: 
      return true
    case .yieldExprList: 
      return true
    default: 
      return false
    }
  }
  
  public var isMissing: Bool {
    switch self {
    case .missingDecl: 
      return true
    case .missingExpr: 
      return true
    case .missingPattern: 
      return true
    case .missingStmt: 
      return true
    case .missingType: 
      return true
    default: 
      return false
    }
  }
}
