from .Child import Child  # noqa: I201
from .Utils import error
from .kinds import SYNTAX_BASE_KINDS, kind_to_type, lowercase_first_word


class Node(object):
    """
    A Syntax node, possibly with children.
    If the kind is "SyntaxCollection", then this node is considered a Syntax
    Collection that will expose itself as a typedef rather than a concrete
    subclass.
    """

    def __init__(self, name, name_for_diagnostics, description=None, kind=None,
                 traits=None, parser_function=None, children=[], element=None, 
                 element_name=None, element_choices=None, omit_when_empty=False,
                 elements_separated_by_newline=False):
        self.syntax_kind = name
        self.element_name = element_name
        self.swift_syntax_kind = lowercase_first_word(name)
        self.name = kind_to_type(self.syntax_kind)
        self.kind = kind
        self.name_for_diagnostics = name_for_diagnostics
        self.description = description
        self.parser_function = parser_function

        self.traits = traits or []
        self.children = []
        # Add implicitly generated UnexpectedNodes children in between any two
        # defined children
        if kind != 'SyntaxCollection' and len(children) > 0:
            for i in range(2 * len(children) + 1):
                if i % 2 == 0:
                    if i == 0:
                        name = 'UnexpectedBefore' + children[0].name
                    elif i == 2 * len(children):
                        name = 'UnexpectedAfter' + children[-1].name
                    else:
                        name = 'UnexpectedBetween%sAnd%s' % \
                            (children[int(i / 2) - 1].name, children[int(i / 2)].name)
                    self.children.append(Child(
                        name,
                        kind='UnexpectedNodes',
                        collection_element_name=name,
                        is_optional=True
                    ))
                else:
                    self.children.append(children[int((i - 1) / 2)])

        self.non_unexpected_children = \
            [child for child in children if not child.is_unexpected_nodes()]

        self.base_kind = kind
        if self.base_kind == 'SyntaxCollection':
            self.base_type = 'Syntax'
        else:
            self.base_type = kind_to_type(self.base_kind)

        if self.base_kind not in SYNTAX_BASE_KINDS:
            error("unknown base kind '%s' for node '%s'" %
                  (self.base_kind, self.syntax_kind))

        self.omit_when_empty = omit_when_empty
        self.collection_element = element or ""
        # For SyntaxCollections make sure that the element_name is set.
        assert not self.is_syntax_collection() or element_name or element
        # If there's a preferred name for the collection element that differs
        # from its supertype, use that.
        self.collection_element_name = element_name or self.collection_element
        self.collection_element_type = kind_to_type(self.collection_element)
        self.collection_element_choices = element_choices or []
        self.elements_separated_by_newline = elements_separated_by_newline

    def is_base(self):
        """
        Returns `True` if this node declares one of the base syntax kinds.
        """
        return self.syntax_kind in SYNTAX_BASE_KINDS

    def is_syntax_collection(self):
        """
        Returns `True` if this node is a subclass of SyntaxCollection.
        """
        return self.base_kind == "SyntaxCollection"

    def requires_validation(self):
        """
        Returns `True` if this node should have a `validate` method associated.
        """
        return self.is_buildable()

    def is_unknown(self):
        """
        Returns `True` if this node is an `Unknown` syntax subclass.
        """
        return "Unknown" in self.syntax_kind

    def is_missing(self):
        """
        Returns `True` if this node is a `Missing` syntax subclass.
        """
        return "Missing" in self.syntax_kind

    def is_buildable(self):
        """
        Returns `True` if this node should have a builder associated.
        """
        return not self.is_base() and \
            not self.is_unknown() and \
            not self.is_missing() and \
            not self.is_syntax_collection()

    def shall_be_omitted_when_empty(self):
        """
        Returns 'True' if this node shall not be created while parsing if it
        has no children.
        """
        return self.omit_when_empty

    def is_token(self):
        """
        Returns true if this child has a token kind.
        """
        return 'Token' in self.syntax_kind or \
            'Token' in self.collection_element

    def has_optional_base_type_child(self):
      return any(child.has_optional_base_type() for child in self.children)

    def generate_initializer_decl(self, optional_base_as_missing, current_indentation=""):
      if not self.children:
        return "public init()"

      generic_param_names = {}
      generic_params = []
      params = []

      if self.children:
        params.append("leadingTrivia: Trivia? = nil")
      for child in self.children:
        if child.node_choices:
          param_type = child.name
        elif child.has_base_type():
          if optional_base_as_missing:
            param_type = f"Missing{child.type_name}"
          else:
            # If we have a base type, make the initializer generic over its
            # protocol instead.
            param_type = child.swift_name[0].upper()

            param_count = generic_param_names.get(param_type, 0) + 1
            generic_param_names[param_type] = param_count
            if param_count > 1:
              param_type += str(param_count)

            generic_params.append(f"{param_type}: {child.type_name}Protocol")
        else:
          param_type = child.type_name

        if child.is_optional:
          param_type += "?"
        label = "_ " if child.is_unexpected_nodes() else ""

        params.append(f"{label}{child.swift_name}: {param_type}{child.generate_default_initialization()}")
      if self.children:
        params.append("trailingTrivia: Trivia? = nil")

      param_indentation = current_indentation + "  "
      separator = ",\n" + param_indentation
      generics = ""
      if generic_params:
        generics = f"<{', '.join(generic_params)}>"
      return f"public init{generics}(\n{param_indentation}{separator.join(params)}\n{current_indentation})"
