import path from "path";
import { fileURLToPath } from "url";
import { defineConfig } from "vitest/config";
import { createVuePlugin } from "vite-plugin-vue2";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  plugins: [createVuePlugin()],
  resolve: {
    alias: {
      vue: path.resolve(__dirname, "node_modules/vue/dist/vue.common.js"),
      "@appjs": path.resolve(__dirname, "app/javascript"),
      "@assetsjs": path.resolve(__dirname, "app/assets/javascripts"),
      "@vendorjs": path.resolve(__dirname, "vendor/assets/javascripts"),
      utilities: path.resolve(__dirname, "app/javascript/utilities"),
      sweetalert2: path.resolve(
        __dirname,
        "spec/javascript/mocks/sweetalert2.js"
      ),
    },
    extensions: [".vue", ".mjs", ".js", ".json"],
    modules: [path.resolve(__dirname, "app/javascript"), "node_modules"],
  },
  css: {
    preprocessorOptions: {
      scss: {
        silenceDeprecations: ["legacy-js-api"],
      },
    },
  },
  test: {
    environment: "jsdom",
    include: ["spec/javascript/**/*.spec.js"],
    setupFiles: ["spec/javascript/setup.js"],
    css: false,
    env: {
      NODE_ENV: "production",
    },
    onConsoleLog(log) {
      if (log.includes("Download the Vue Devtools")) return false;
      if (log.includes("You are running Vue in development mode")) return false;
    },
  },
});
