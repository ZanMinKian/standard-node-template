module.exports = {
  'src/**/*.{js,ts}': [
    './node_modules/.bin/eslint --fix',
    './node_modules/.bin/prettier -w',
    // 'git add', // lint-staged从v10开始不再需要添加git add命令
  ],
};
