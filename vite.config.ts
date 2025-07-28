import { defineConfig } from 'vite'
import FullReload from "vite-plugin-full-reload"
import RubyPlugin from 'vite-plugin-ruby'
import inject from "@rollup/plugin-inject"
// import StimulusHMR from 'vite-plugin-stimulus-hmr'

export default defineConfig({
  server: {
    hmr: {
      host: 'localhost',  // Add this to force IPv4 only
    }
  },
  clearScreen: false,
  css: {
    devSourcemap: true
  },
  assetsInclude: ['**/*.html', '**/*.woff', '**/*.woff2', '**/*.ttf', '**/*.eot', '**/*.svg', '**/*.png', '**/*.jpg', '**/*.jpeg', '**/*.gif', '**/*.ico'],
  plugins: [
    inject({
      $: 'jquery',
      jQuery: 'jquery',
      include: ['**/*.js', '**/*.ts', '**/*.jsx'],
      exclude: ['**/*.scss', '**/*.sass', '**/*.css'],
    }),
    RubyPlugin(),
    // StimulusHMR(),
    FullReload(["config/routes.rb", "app/views/**/*"], {delay: 300}),
  ],
  optimizeDeps: {
    include: ["jquery", "tinymce"],
  },
  build: {
    commonjsOptions: {transformMixedEsModules: true}
  }
})
