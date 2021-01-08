#!/bin/sh

# 当一个命令返回一个非零退出状态时退出
set -e

# 0. 初始化文件夹, npm和git
targetPath="$1"
if [ -e $targetPath ]; then
  echo "File or directory is already existing! Init fail."
  exit 1
fi
mkdir $targetPath
cd $targetPath
npm init -y
git init

# 1. 配置husky
npm i husky -D
echo "module.exports = {
  hooks: {
    'commit-msg': './node_modules/.bin/commitlint -E HUSKY_GIT_PARAMS', // 校验提交的message的规范性
    'pre-commit': './node_modules/.bin/lint-staged', // 校验提交的代码的规范性
  },
};" >.huskyrc.js

# 2. 配置commitlint
npm i @commitlint/cli @commitlint/config-conventional -D
echo "module.exports = { extends: ['@commitlint/config-conventional'] };" >.commitlintrc.js

# 3. 配置lint-staged
npm i lint-staged -D
echo "module.exports = {
  'src/**/*.{js,ts}': [
    './node_modules/.bin/eslint --fix',
    './node_modules/.bin/prettier -w',
    // 'git add', // lint-staged从v10开始不再需要添加git add命令
  ],
};" >.lintstagedrc.js

# 4. 配置poetic(里面包含了eslint和prettier)
npm i poetic -D
echo "serviceWorker.*\n*.d.ts\ndist" >.eslintignore
echo "module.exports = { extends: ['./node_modules/poetic/config/eslint/eslint-config.js'] };" >.eslintrc.js
echo "module.exports = { ...require('poetic').prettierConfig };" >.prettierrc.js

# 5. 配置editorconfig
echo "# Editor configuration, see http://editorconfig.org
root = true\n
[*.{js, ts}]
charset = utf-8
indent_style = space
indent_size = 2
insert_final_newline = true
end_of_line = lf
trim_trailing_whitespace = true" >.editorconfig

# 6. 配置commitizen
npm i commitizen cz-conventional-changelog -D
echo '{ "path": "./node_modules/cz-conventional-changelog" }' >.czrc

# 7. 配置ts
npm i typescript -D
echo '{
  /* Poetic base style configuration */
  "extends": "./node_modules/poetic/config/typescript/tsconfig.json",
  /* Add your custom configuration after this */
  "include": [
    "src"
  ],
  "compilerOptions": {
    "target": "es2017",
    "outDir": "dist",
    "lib": [
      "esnext"
    ],
    "skipLibCheck": true,
    "esModuleInterop": true,
    "module": "commonjs",
    "moduleResolution": "node",
    "isolatedModules": true,
    "resolveJsonModule": true,
    "allowSyntheticDefaultImports": true,
    "allowJs": true,
    "experimentalDecorators": true,
    "rootDir": "src",
    "sourceMap": true,
    "emitDecoratorMetadata": true
  }
}
' >tsconfig.json

# 8. 配置gitingore
echo "# Created by .ignore support plugin (hsz.mobi)
### JetBrains template
# Covers JetBrains IDEs: IntelliJ, RubyMine, PhpStorm, AppCode, PyCharm, CLion, Android Studio and WebStorm
# Reference: https://intellij-support.jetbrains.com/hc/en-us/articles/206544839

.idea/**/*

# User-specific stuff
.idea/**/workspace.xml
.idea/**/tasks.xml
.idea/**/usage.statistics.xml
.idea/**/dictionaries
.idea/**/shelf

# Generated files
.idea/**/contentModel.xml

# Sensitive or high-churn files
.idea/**/dataSources/
.idea/**/dataSources.ids
.idea/**/dataSources.local.xml
.idea/**/sqlDataSources.xml
.idea/**/dynamic.xml
.idea/**/uiDesigner.xml
.idea/**/dbnavigator.xml

# Gradle
.idea/**/gradle.xml
.idea/**/libraries

# Gradle and Maven with auto-import
# When using Gradle or Maven with auto-import, you should exclude module files,
# since they will be recreated, and may cause churn.  Uncomment if using
# auto-import.
# .idea/artifacts
# .idea/compiler.xml
# .idea/modules.xml
# .idea/*.iml
# .idea/modules
# *.iml
# *.ipr

# CMake
cmake-build-*/

# Mongo Explorer plugin
.idea/**/mongoSettings.xml

# File-based project format
*.iws

# IntelliJ
out/

# mpeltonen/sbt-idea plugin
.idea_modules/

# JIRA plugin
atlassian-ide-plugin.xml

# Cursive Clojure plugin
.idea/replstate.xml

# Crashlytics plugin (for Android Studio and IntelliJ)
com_crashlytics_export_strings.xml
crashlytics.properties
crashlytics-build.properties
fabric.properties

# Editor-based Rest Client
.idea/httpRequests

# Android studio 3.1+ serialized cache file
.idea/caches/build_file_checksums.ser

### VisualStudioCode template
.vscode/*
.vscode/settings.json
.vscode/tasks.json
.vscode/launch.json
.vscode/extensions.json
*.code-workspace

### Node template
# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# Diagnostic reports (https://nodejs.org/api/report.html)
report.[0-9]*.[0-9]*.[0-9]*.[0-9]*.json

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Directory for instrumented libs generated by jscoverage/JSCover
lib-cov

# Coverage directory used by tools like istanbul
coverage
*.lcov

# nyc test coverage
.nyc_output

# Grunt intermediate storage (https://gruntjs.com/creating-plugins#storing-task-files)
.grunt

# Bower dependency directory (https://bower.io/)
bower_components

# node-waf configuration
.lock-wscript

# Compiled binary addons (https://nodejs.org/api/addons.html)
build/Release

# Dependency directories
node_modules/
jspm_packages/

# TypeScript v1 declaration files
typings/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Microbundle cache
.rpt2_cache/
.rts2_cache_cjs/
.rts2_cache_es/
.rts2_cache_umd/

# Optional REPL history
.node_repl_history

# Output of 'npm pack'
*.tgz

# Yarn Integrity file
.yarn-integrity

# dotenv environment variables file
.env
.env.test

# parcel-bundler cache (https://parceljs.org/)
.cache

# Next.js build output
.next

# Nuxt.js build / generate output
.nuxt
dist

# Gatsby files
.cache/
# Comment in the public line in if your project uses Gatsby and *not* Next.js
# https://nextjs.org/blog/next-9-1#public-directory-support
# public

# vuepress build output
.vuepress/dist

# Serverless directories
.serverless/

# FuseBox cache
.fusebox/

# DynamoDB Local files
.dynamodb/

# TernJS port file
.tern-port

### Windows template
# Windows thumbnail cache files
Thumbs.db
Thumbs.db:encryptable
ehthumbs.db
ehthumbs_vista.db

# Dump file
*.stackdump

# Folder config file
[Dd]esktop.ini

# Recycle Bin used on file shares
\$RECYCLE.BIN/

# Windows Installer files
*.cab
*.msi
*.msix
*.msm
*.msp

# Windows shortcuts
*.lnk

### macOS template
# General
.DS_Store
.AppleDouble
.LSOverride

# Icon must end with two \r
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

### Vim template
# Swap
[._]*.s[a-v][a-z]
!*.svg  # comment out if you don't need vector files
[._]*.sw[a-p]
[._]s[a-rt-v][a-z]
[._]ss[a-gi-z]
[._]sw[a-p]

# Session
Session.vim
Sessionx.vim

# Temporary
.netrwhist
*~
# Auto-generated tag files
tags
# Persistent undo
[._]*.un~
" >.gitignore

# 9. 安装`pm2`
npm i pm2 -D

# 10. 创建src目录, 创建index.ts文件
mkdir src
echo "" >src/index.ts

# 11. git init
git add .
git commit -m "chore: init"
