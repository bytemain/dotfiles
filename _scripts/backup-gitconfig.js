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

function escapeValueForShell(value) {
  if (typeof value !== 'string') {
    return value;
  }

  // 检查值是否已经被双引号包围
  const isQuoted = value.startsWith('"') && value.endsWith('"');
  // 如果已经被引号包围，移除外层引号以便处理内容
  if (isQuoted) {
    // 移除外层引号
    value = value.substring(1, value.length - 1);
  }

    // 对于普通值，转义所有特殊字符
    value = value
      .replace(/\\/g, '\\\\')
      .replace(/"/g, '\\"')
      .replace(/\$/g, '\\$')
      .replace(/`/g, '\\`')
      .replace(/!/g, '\\!')
      .replace(/\[/g, '\\[')
      .replace(/\]/g, '\\]');
  // 返回处理后的值，并标记它是否原本就被引号包围
  return { value, isQuoted };
}

function generateGitCommand(data) {
  const keyValues = getKeyValues(data);
  let cmd = "";
  keyValues.forEach(([k, v]) => {
    const result = escapeValueForShell(v);
    cmd += `git config --global ${k} "${result.value}"\n`;
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
