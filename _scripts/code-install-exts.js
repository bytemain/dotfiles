const fs = require("fs");
const { serial } = require("../utils/promises");
const childProcess = require("child_process");
const { promisify } = require("util");
const path = require("path");
const exec = promisify(childProcess.exec);

const exts = fs.readFileSync(path.join(__dirname, "../_rc/exts.txt"));

const list = exts.toString().split("\n");

serial(
  list.map((v) => async () => {
    if (!v) {
      return;
    }
    console.log(`code --install-extension ` + v);
    const result = await exec(`code --install-extension ` + v);
    console.log(
      `🚀 ~ file: code-install-exts.js ~ line 20 ~ return ~ result`,
      result
    );
  })
);
