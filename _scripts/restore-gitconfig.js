const configJson = require("../_rc/gitconfig.json");
const { exec } = require("./utils/exec");
const { serial } = require("./utils/promises");

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

const keyValues = getKeyValues(configJson);
console.log(keyValues);
serial(
  Object(keyValues).map(
    ([k, v]) =>
      () =>
        exec(`git config --global ${k} "${v}"`)
  )
);
