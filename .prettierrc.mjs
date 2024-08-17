// prettier.config.js, .prettierrc.js, prettier.config.mjs, or .prettierrc.mjs

/**
 * @see https://prettier.io/docs/en/configuration.html
 * @type {import("prettier").Config}
 */
const config = {
  trailingComma: "es5",
  semi: false,
  singleQuote: true,
  plugins: [
    "prettier-plugin-sh"
  ],
  "overrides": [
    {
      "files": "**/*.sh",
      "excludeFiles": [
        "**/*.dict"
      ],
      "options": {
        "parser": "sh"
      }
    }
  ]
};

export default config;
