const js = require("@eslint/js");
const globals = require("globals");
const vuePlugin = require("eslint-plugin-vue");

module.exports = [
    // Règles JS de base
    js.configs.recommended,

    // Config Vue minimaliste
    ...vuePlugin.configs["flat/essential"],

    // Contexte + règles custom
    {
        files: ["src/**/*.{js,vue}"],
        languageOptions: {
            ecmaVersion: 2021,
            sourceType: "module",
            globals: {
                ...globals.browser,
            },
        },
        rules: {
            "vue/max-attributes-per-line": "off",
            "vue/attributes-order": "off",
            "vue/singleline-html-element-content-newline": "off",
            "vue/multiline-html-element-content-newline": "off",
        },
    },
];
