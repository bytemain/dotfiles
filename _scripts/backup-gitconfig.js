const fs = require("fs");
const os = require("os");
const gitconfig = require("./utils/git-config");
const path = require("path");

const data = gitconfig.sync();

// generate git command from sectionAllowed
// git config --global url.ssh://git@github.com/.insteadOf https://github.com/
// `git config` --[scope] [section].[key] [value]
function getKeyValues(obj, prefix = "", keyValues = []) {
  for (let key in obj) {
    if (typeof obj[key] === "object") {
      // 处理带引号的 section，如 `url "git@github.com:"` -> `url."git@github.com:"`
      let sectionKey = key;
      if (key.includes(' ')) {
        const parts = key.split(' ');
        if (parts.length > 1) {
          sectionKey = parts[0] + '.' + parts.slice(1).join(' ');
        }
      }
      getKeyValues(obj[key], prefix ? prefix + sectionKey + "." : sectionKey + ".", keyValues);
    } else {
      let fullKey = prefix + key;
      // 移除不必要的转义
      keyValues.push([fullKey, obj[key]]);
    }
  }
  return keyValues;
}

function escapeValueForShell(value) {
  if (typeof value !== 'string') {
    return value;
  }

  // 移除多余的转义字符
  value = value.replace(/\\\\/g, '\\');

  return value;
}

function generateGitCommand(data) {
  const keyValues = getKeyValues(data);
  let cmd = "";
  keyValues.forEach(([k, v]) => {
    const escapedValue = escapeValueForShell(v);
    cmd += `git config --global ${k} "${escapedValue}"\n`;
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
