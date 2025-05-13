// SPDX-FileCopyrightText: © 2024 Sebastian Davids <sdavids@gmx.de>
// SPDX-License-Identifier: Apache-2.0

// https://eslint.org/docs/latest/use/configure/configuration-files

import globals from "globals";
import js from "@eslint/js";
import json from "@eslint/json";
import { configs as dependConfigs } from "eslint-plugin-depend";
import { flatConfigs as importConfigs } from "eslint-plugin-import-x";

// noinspection JSUnusedGlobalSymbols
export default [
  {
    ignores: ["dist/*"],
    name: "global/ignores",
  },
  {
    files: ["**/*.json"],
    ignores: ["package-lock.json"],
    language: "json/json",
    plugins: {
      json,
    },
    rules: {
      ...json.configs.recommended.rules,
    },
    name: "eslint/json/recommended",
  },
  {
    files: ["**/*.mjs"],
    ...js.configs.all,
    name: "eslint/js/all",
  },
  importConfigs.recommended,
  {
    files: ["**/*.mjs"],
    rules: {
      "import-x/exports-last": "error",
      "import-x/extensions": ["error", "ignorePackages"],
      "import-x/first": "error",
      "import-x/group-exports": "error",
      "import-x/newline-after-import": "error",
      "import-x/no-absolute-path": "error",
      "import-x/no-deprecated": "error",
      "import-x/no-empty-named-blocks": "error",
      "import-x/no-mutable-exports": "error",
      "import-x/no-named-as-default": "error",
      "import-x/no-named-as-default-member": "error",
      "import-x/no-named-default": "error",
      "import-x/no-namespace": "error",
      "import-x/no-self-import": "error",
      "import-x/no-unassigned-import": "error",
      "import-x/no-useless-path-segments": "error",
      "import-x/order": "error",
    },
    name: "eslint/js/import",
  },
  dependConfigs["flat/recommended"],
  {
    files: ["**/*.mjs"],
    rules: {
      "capitalized-comments": "off",
      "func-names": ["error", "always", { generators: "as-needed" }],
      "id-length": "off",
      "line-comment-position": "off",
      "max-lines": "off",
      "max-lines-per-function": "off",
      "max-params": "off",
      "max-statements": "off",
      "multiline-comment-style": "off",
      "no-continue": "off",
      "no-inline-comments": "off",
      "no-magic-numbers": "off",
      "no-param-reassign": "off",
      "no-plusplus": "off",
      "no-shadow": "off",
      "no-ternary": "off",
      "no-unused-vars": ["error", { argsIgnorePattern: "^_" }],
      "no-warning-comments": "off",
      "one-var": "off",
      "prefer-destructuring": ["error", { object: true, array: false }],
      radix: "off",
      "sort-keys": "off",
      "sort-imports": ["error", { ignoreDeclarationSort: true }],
      "sort-vars": "off",
    },
    name: "sdavids/js/defaults",
  },
  {
    files: ["**/*.mjs"],
    languageOptions: {
      globals: {
        ...globals.node,
      },
      parserOptions: {
        ecmaVersion: "latest",
      },
    },
    rules: {
      "import-x/no-extraneous-dependencies": [
        "error",
        {
          optionalDependencies: false,
          peerDependencies: false,
        },
      ],
      "no-console": "off",
    },
    name: "sdavids/js/node",
  },
];
