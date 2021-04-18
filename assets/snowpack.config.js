module.exports = {
  mount: {
    src: "/",
  },
  plugins: ["@snowpack/plugin-postcss"],
  optimize: {
    entrypoints: ['src/music.js'],
    bundle: true,
    minify: true,
    target: 'es2018',
  },
};
