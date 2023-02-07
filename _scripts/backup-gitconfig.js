const fs = require("fs");
const os = require("os");
const gitconfig = require("git-config");
const path = require("path");

const exts = fs.readFileSync(path.join(os.homedir(), ".gitconfig"));
console.log(`🚀 ~ file: backup-gitconfig.js ~ line 10 ~ exts`, exts.toString());

const sectionAllowed = ["pull", "core", "alias", "color"];

const data = gitconfig.sync();
console.log(`🚀 ~ file: backup-gitconfig.js ~ line 16 ~ data`, data);

Object.keys(data).forEach((k) => {
  if (!sectionAllowed.includes(k)) {
    delete data[k];
  }
});

fs.writeFileSync(
  path.join(os.homedir(), "dotfiles/_rc/gitconfig.json"),
  JSON.stringify(data, null, 2)
);

fs.copyFileSync(
  path.join(os.homedir(), ".gitignore_global"),
  path.join(os.homedir(), "dotfiles/_rc/gitignore_global")
);
