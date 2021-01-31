module.exports = {
  hooks: {
    'commit-msg': './node_modules/.bin/commitlint -E HUSKY_GIT_PARAMS', // 校验提交的message的规范性
    'pre-commit': './node_modules/.bin/lint-staged', // 校验提交的代码的规范性
  },
};
