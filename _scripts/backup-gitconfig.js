const fs = require("fs");
const os = require("os");
const gitconfig = require("./utils/git-config");
const path = require("path");

const exts = fs.readFileSync(path.join(os.homedir(), ".gitconfig"));
console.log(`🚀 ~ file: backup-gitconfig.js ~ line 10 ~ exts`, exts.toString());

const data = gitconfig.sync();
console.log(`🚀 ~ file: backup-gitconfig.js ~ line 16 ~ data`, data);

// generate git command from sectionAllowed
// git config --global url.ssh://git@github.com/.insteadOf https://github.com/
// `git config` --[scope] [section].[key] [value]
function getKeyValues(obj, prefix = "", keyValues = []) {
  for (let key in obj) {
    const fullKey = prefix + key;
    if (typeof obj[key] === "object") {
      getKeyValues(obj[key], fullKey + ".", keyValues);
    } else {
      keyValues.push([fullKey, obj[key]]);
    }
  }
  return keyValues;
}

function generateGitCommand(data) {
  const keyValues = getKeyValues(data);
  let cmd = "";
  keyValues.forEach(([k, v]) => {
    cmd += `git config --global ${k} "${v}"\n`;
  });
  return cmd;
}

const dotfileDir = path.resolve(__dirname, '..');

const command = generateGitCommand(data);
fs.writeFileSync(
  path.join(dotfileDir, "_scripts/setup-gitconfig.generated.sh"),
  command,
);

const globalIgnoreFile = path.join(os.homedir(), ".gitignore_global");

if (fs.existsSync(globalIgnoreFile)) {
  fs.copyFileSync(
    globalIgnoreFile,
    path.join(dotfileDir, "_rc/gitignore_global"),
  );
}
