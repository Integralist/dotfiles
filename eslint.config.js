/*
 * Rule docs: http://eslint.org/docs/rules/
 * 1 = warn, 2 = error
 *
 * Rules are split into two categories, stylistic and errorPrevention.
 * The stylistic ruleset is inentionally short.
 */

const stylisticRules = {
    'brace-style': [2, '1tbs', {'allowSingleLine': true}],
    'camelcase': 2,
    'comma-spacing': 2,
    'comma-style': 2,
    'curly': 2,
    'eol-last': 2,
    'indent': [2, 2],
    'key-spacing': 2,
    'new-cap': 2,
    'new-parens': 2,
    'no-lonely-if': 2,
    'no-multi-spaces': 2,
    'no-multiple-empty-lines': [2, {'max': 2}],
    'func-call-spacing': 2,
    'no-trailing-spaces': 2,
    'quotes': [2, 'single', {'allowTemplateLiterals': true}],
    'semi': 2,
    'semi-spacing': 2,
    'space-before-blocks': 2,
    'space-in-parens': 2,
    'space-infix-ops': 2,
    'space-unary-ops': 2
};

const errorPreventionRules = {
    'array-callback-return': 2,
    'block-scoped-var': 2,
    'consistent-return': 2,
    'eqeqeq': 2,
    'guard-for-in': 2,
    'no-array-constructor': 2,
    'no-caller': 2,
    'no-cond-assign': 2,
    'no-const-assign': 2,
    'no-control-regex': 2,
    'no-delete-var': 2,
    'no-dupe-args': 2,
    'no-dupe-class-members': 2,
    'no-dupe-keys': 2,
    'no-duplicate-case': 2,
    'no-empty-character-class': 2,
    'no-empty-pattern': 2,
    'no-eval': 2,
    'no-ex-assign': 2,
    'no-extend-native': 2,
    'no-extra-bind': 2,
    'no-fallthrough': 2,
    'no-func-assign': 2,
    'no-implied-eval': 2,
    'no-invalid-regexp': 2,
    'no-iterator': 2,
    'no-lone-blocks': 2,
    'no-loop-func': 2,
    'no-mixed-operators': [2, {
      groups: [
        ['&', '|', '^', '~', '<<', '>>', '>>>'],
        ['==', '!=', '===', '!==', '>', '>=', '<', '<='],
        ['&&', '||'],
        ['in', 'instanceof']
      ],
      allowSamePrecedence: false
    }],
    'no-multi-str': 2,
    'no-native-reassign': 2,
    'no-unneeded-ternary': 2,
    'no-unsafe-negation': 2,
    'no-new-func': 2,
    'no-new-object': 2,
    'no-new-symbol': 2,
    'no-new-wrappers': 2,
    'no-obj-calls': 2,
    'no-octal': 2,
    'no-octal-escape': 2,
    'no-redeclare': 2,
    'no-regex-spaces': 2,
    'no-script-url': 2,
    'no-self-assign': 2,
    'no-self-compare': 2,
    'no-sequences': 2,
    'no-shadow-restricted-names': 2,
    'no-shadow': 2,
    'no-sparse-arrays': 2,
    'no-template-curly-in-string': 2,
    'no-this-before-super': 2,
    'no-throw-literal': 2,
    'no-undef': 2,
    'no-unexpected-multiline': 2,
    'no-unreachable': 2,
    'no-unused-expressions': [2, {
      'allowShortCircuit': true,
      'allowTernary': true
    }],
    'no-unused-vars': 2,
    'no-use-before-define': [2, 'nofunc'],
    'no-useless-computed-key': 2,
    'no-useless-concat': 2,
    'no-useless-constructor': 2,
    'no-useless-escape': 2,
    'no-useless-rename': 2,
    'no-with': 2,
    'radix': 2,
    'require-yield': 2,
    'use-isnan': 2,
    'valid-typeof': 2,
    'wrap-iife': [2, 'any']
}

module.exports = {
  'parser': 'babel-eslint',
  'env': {
    'browser': true,
    'node': true
  },
  'rules': Object.assign(stylisticRules, errorPreventionRules)
};
