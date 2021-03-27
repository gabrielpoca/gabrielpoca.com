const path = require('path');
const snowpack = require("snowpack");

const { startServer, createConfiguration, getUrlForFile, build } = snowpack;

let server;

module.exports.start = async (opts) => {
  process.chdir(opts.inputPath);
  const config = createConfig(opts);

  server = await startServer({ config });

  return true;
};

module.exports.devServerGetUrlForFile = async (file, opts) => {
  if (server) {
    const response = server.getUrlForFile(file);
    snowpack.logger.error(response);
    return response;
  }
};

module.exports.stop = async () => {
  if (server) await server.shutdown();
};

module.exports.build = async (opts) => {
  process.chdir(opts.inputPath);
  const config = createConfig(opts);

  const { result } = await build({ config });

  const slimResult = Object.keys(result).reduce((memo, key) => {
    memo[result[key]["source"]] = key;
    return memo;
  }, {});

  return slimResult;
};

module.exports.getUrlForFile = (file, opts) => {
  const config = createConfig(opts);

  return getUrlForFile(file, config);
};

function createConfig({ inputPath, outputPath }) {
  return createConfiguration({
    root: inputPath,
    mount: {
      src: "/",
    },
    devOptions: {
      port: 3001,
      hmrPort: 3002,
      open: "none",
    },
    plugins: ["@snowpack/plugin-postcss"],
    packageOptions: {
      source: "remote",
    },
    buildOptions: {
      out: outputPath,
    },
  });
}
