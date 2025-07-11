proj=$1
# echo $proj

mkdir $proj
cd $proj

pnpm init
tsc --init

mkdir public
mkdir src
mkdir src/assets
mkdir src/components
mkdir src/router
mkdir src/stores
mkdir src/utils
mkdir src/views

# touch public/index.html
# touch src/App.vue
# touch src/main.ts
# touch src/router/index.ts
# touch webpack.config.js

# public/index.html
echo '<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <!-- <link rel="icon" href="/favicon.ico" /> -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Webpack App</title>
    <!-- CDN -->
    <!-- <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script> -->
  </head>
  <body>
    <div id="app"></div>
  </body>
</html>' >public/index.html

# src/App.vue
echo '<script setup lang="ts">
console.log("Webpack App");
</script>

<template>
  <div>Webpack App</div>
</template>

<style lang="css" scoped></style>' >src/App.vue

# src/router/index.ts
echo 'import { createRouter, createWebHistory } from "vue-router";

const router = createRouter({
  history: createWebHistory("/"),
  routes: [],
});

export default router;' >src/router/index.ts

# webpack.config.js
echo '// @ts-check
const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const { VueLoaderPlugin } = require("vue-loader");
const FriendlyErrorsWebpackPlugin = require("friendly-errors-webpack-plugin");

const port = 5173;

/**
 * @type import("webpack").Configuration
 */
module.exports = {
  mode: "development",
  entry: "./src/main.ts",
  module: {
    rules: [
      {
        test: /\.ts$/,
        loader: "ts-loader",
        options: {
          configFile: path.resolve(process.cwd(), "./tsconfig.json"),
          appendTsSuffixTo: [/\.vue$/],
        },
      },
      {
        test: /\.vue$/,
        use: "vue-loader",
      },
      {
        test: /\.css$/,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.scss$/,
        use: ["style-loader", "css-loader", "sass-loader"],
      },
    ],
  },
  output: {
    clean: true,
    filename: "[hash].js",
    path: path.resolve(__dirname, "./dist"),
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
    extensions: [".ts", ".tsx", ".vue", ".js", ".jsx"],
  },
  stats: "errors-only",
  devServer: { port },
  plugins: [
    new HtmlWebpackPlugin({
      template: "./public/index.html",
    }),
    new VueLoaderPlugin(),
    new FriendlyErrorsWebpackPlugin({
      compilationSuccessInfo: {
        notes: [`Local:   http://localhost:${port}/`],
        messages: [`Github:   https://github.com/161043261/vue-webpack/`],
      },
    }),
  ],
  // externals: { vue: "Vue" },
};' >webpack.config.js

echo 'declare module "*.vue" {
  import { DefineComponent } from "vue";
  const component: DefineComponent<{}, {}, any>;
  export default component;
}' >src/env.d.ts

# src/main.ts
echo 'import "./assets/base.css";
import "./assets/main.scss";

import { createApp } from "vue";
import { createPinia } from "pinia";

import App from "./App.vue";
import router from "./router";

const app = createApp(App);

app.use(createPinia());
app.use(router);
app.mount("#app");' >src/main.ts

# src/assets/base.css
echo '* {
  margin: 0;
  padding: 0;
}' >src/assets/base.css

# src/assets/main.scss
echo ':root {
  background: skyblue;
}' >src/assets/main.scss

# package.json
pnpm add vue vue-router pinia # vue

pnpm add webpack webpack-cli webpack-dev-server typescript ts-loader vue-loader@next @vue/compiler-sfc css-loader style-loader sass sass-loader html-webpack-plugin friendly-errors-webpack-plugin prettier -D

sed -i '' 's/"test": "echo \\"Error: no test specified\\" && exit 1"/"dev": "webpack-dev-server",\n    "build": "webpack"/' package.json
# package.json
# "dev": "webpack-dev-server",
# "build": "webpack"
