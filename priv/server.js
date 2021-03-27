const readline = require("readline");

const WRITE_CHUNK_SIZE = parseInt(process.env.WRITE_CHUNK_SIZE, 10);

const mod = require(process.argv[2]);

async function callFunction(moduleFunction, args) {
  try {
    return JSON.stringify([true, await mod[moduleFunction].apply(this, args)]);
  } catch ({ message, stack }) {
    return JSON.stringify([false, `${message}\n${stack}`]);
  }
}

async function onLine(line) {
  const [prefix, moduleFunction, args] = JSON.parse(line);
  const response = await callFunction(moduleFunction, args);
  const buffer = Buffer.from(`${response}\n`);

  process.stdout.write("\n");

  for (let i = 0; i < buffer.length; i += WRITE_CHUNK_SIZE) {
    let chunk = buffer.slice(i, Math.min(i + WRITE_CHUNK_SIZE, buffer.length));

    process.stdout.write(prefix);
    process.stdout.write(chunk);
    process.stdout.write("\n");
  }
}

function start() {
  process.stdin.on("end", () => process.exit());

  const readLineInterface = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });

  readLineInterface.on("line", onLine);
}

module.exports.start = start;

if (require.main === module) {
  start();
}
