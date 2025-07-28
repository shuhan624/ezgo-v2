# README

## 各套件使用版本 Versions

* Ruby 版本: 3.3.5

* Rails 版本: 7.2.2

* 資料庫 PostgreSQL 版本: v10 以上

* Node 版本: v18 以上

* Ruby 版本控制套件建議使用: [rbenv](https://github.com/rbenv/rbenv)

## 環境設定（macOS）

### 【注意】安裝 XCode Command Line Tools 的命令列開發者工具 (不是 XCode App)

```
  $ xcode-select --install
```

注意事項：請以上方指令方式手動安裝，勿從 App Store 新增安裝 XCode App。 XCode Command Line Tools 不等於 XCode App。

### 安裝 Homebrew

輸入網址： https://brew.sh/index_zh-tw

複製「安裝 Homebrew」指令並執行。

### 安裝 rbenv 用來切換 Ruby 版本

```
  $ brew install rbenv
```

安裝完畢後，需要初始化：

```
  $ rbenv init
  # 執行「rbenv init」指令後，會顯示以下資訊。
  # Load rbenv automatically by appending
  # the following to ~/.zshrc:

  eval "$(rbenv init -)"
```

操作說明：將 `eval "$(rbenv init -)"` 內容，貼到 `~/.zshrc` 檔案中。
  > `~/.zshrc` 是 ZSH 的設定檔，如果你的電腦 Shell 是 bash shell, 則設定檔位置為 `~/.bashrc` 或是 `~/.bash_profile`

列出可安裝的 Ruby 版本：

```
  $ rbenv install -l
  或是
  $ rbenv install -L
```

列出本機已安裝的 Ruby 版本：

```
  $ rbenv versions
```

### 安裝 Ruby

若本機沒有欲安裝的 Ruby 版本：

```
  $ git -C "$(rbenv root)"/plugins/ruby-build pull
```

指定一個 Ruby 版本來安裝：

```
  $ rbenv install 3.3.5
```

指定系統預設使用的 Ruby 版本：

```
  $ rbenv global 3.3.5
```

在專案目錄下，指定專案使用的 Ruby 版本：

```
  $ rbenv local 3.3.5
```

### 更新 RubyGems (會順便安裝 bundler)

```
  $ gem update --system 3.5.22
```

### 安裝 Rails

指定安裝的 Rails 版本 7.2.2

```
  $ gem install rails -v 7.2.2
```

### 安裝 Node

使用 NVM 安裝 Node 20

```
  $ nvm install 20
```

切換到 Node 20

```
  $ nvm use 20
```

### 安裝 yarn (JavaScript 套件管理軟體)

```
  $ brew install yarn
```

### (非必須) 建立工作專案資料夾，放置所有的開發專案，例如：projects

先確認自己所在資料夾，再執行：

```
  $ mkdir projects
```

### 安裝 PostgreSQL 資料庫:

可參考 [Installing Postgres via Brew](https://gist.github.com/ibraheem4/ce5ccd3e4d7a65589ce84f2a3b7c23a3)

```
  $ brew install postgresql
```

檢視安裝版本：

```
  $ pg_ctl -V
```

初始化：

```
  $ initdb /usr/local/var/postgres
```

啟動服務：

```
  $ pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
```


建立自己同名的資料庫：

```
  $ createdb
```

### 專案環境設定（建立 Repository 後）

切換到專案目錄下：

```
  $ cd ~/projects/ezgo
```

安裝專案所使用的 Ruby 套件 `(Gemfile)`：

```
  $ bundle install
```

安裝專案所使用的 JavaScript 套件 `(package.json)`：

```
  $ npm i
```

複製專案內的 `/config/database.yml.example` 範例檔，到 `/config/database.yml`
修改必要資訊：資料庫名稱、資料庫帳號 username

```
database: ezgo_dev
username: 你的 macOS 的帳號，就是 iTerm2 提示符號前方的那個
```

確定 `/config/database.yml` 檔案好了之後，開始建立資料庫：

```
  $ bin/rails db:create
```

建立資料表：

```
  $ bin/rails db:migrate
```

新增基礎資料進資料庫：

```
  $ bin/rails db:seed
```

### 專案 Git 設定

* 確認遠端版本庫。

`$ git remote -v`

```Git 原始專案
# 若 Git Clone 的來源為原始的檔案，則會顯示以下資訊。
origin  git@github.com:CianWang/ezgo.git (fetch)
origin  git@github.com:CianWang/ezgo.git (push)
```

```Git Fork 專案
# 若 Git Clone 的來源為 Fork 的檔案，則會顯示以下資訊，username 為 GitHub 帳號名稱。
origin  git@github.com:username/ezgo.git (fetch)
origin  git@github.com:username/ezgo.git (push)
```

* 若是使用 Fork 的檔案，則需進行此步驟，設定遠端同步。

`$ git remote add upstream git@github.com:CianWang/ezgo.git`

  > 指令說明：
  > upstream：只是一個代名詞，指的是在 GitHub 伺服器原始檔案遠端的位置；因此如不用 upstream 也可以。

* 確認遠端版本庫。

`$ git remote -v`

```Git 原始專案
# 完成設定後，會顯示以下資訊。
origin  git@github.com:username/ezgo.git (fetch)
origin  git@github.com:username/ezgo.git (push)
upstream  git@github.com:CianWang/ezgo.git (fetch)
upstream  git@github.com:CianWang/ezgo.git (push)
```

## 一般開發設定

每次要開發新功能或是修改功能「之前」，在自己要開發的 branch 上，先跑以下幾個指令：

```
  $ git pull upstream master --rebase  # 把最新的程式碼拉下來
  $ bundle install              # 安裝更新的 Ruby 套件
  $ yarn install --check-files  # 安裝更新的 JS 套件
  $ rails db:migrate            # 跑 database migration, 確保資料庫同步
```

## 啟動專案：

在開發時，需同時跑以下兩個視窗 (當然 PostgreSQL 資料庫服務也必須開著)：

### 1.啟動 Rails Server：

```
  $ bin/rails s
```

### 2.啟動 Vite Server：

```
  $ bin/vite dev
```

## 測試 Testing (Using RSpec)

本專案使用 [RSpec](https://relishapp.com/rspec/rspec-rails/v/5-0/docs) 測試

一般執行測試程式：

```
  $ bundle exec rspec
```

### Model 測試

目前本專案先撰寫 Model 測試，之後有機會再補上其他的測試

### FactoryBot 產生測試假資料結構 (Model Instance)

本專案的 Model 測試資料都由 [factory_bot](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md) 產生，在 `rails g model` 的同時，會產生相對應的 `spec/factories/[MODEL_NAME].rb` 假資料檔案，可進行修改編輯至合適的資料內容

### 使用 FFaker 產生假內容

可參考：[FFaker 參考資料](https://github.com/ffaker/ffaker/blob/main/REFERENCE.md)

### 使用 Guard 自動跑測試

在開發功能的時候，開啟另一個 Terminal 視窗，在專案目錄下，執行
`$ bundle exec guard`, 這個視窗即會監控 Rails 專案內的程式變動，一發現有變動 (修改了檔案，存檔)，就會自動執行相對應的測試程式。

### 使用多個 CPU 同時跑測試

可參考：[Parallel Tests 參考資料](https://github.com/grosser/parallel_tests)

事前準備：

在 `database.yml` 檔案內，修改測試資料庫：

```
test:
  <<: *default
  database: ezgo_test<%= ENV.fetch('TEST_ENV_NUMBER') { '2' } %>
```

準備(多個)測試資料庫：

```
  $ rake parallel:create
```

Copy DB Schema：

```
  $ rake parallel:prepare
```

測試資料庫 Migration：

```
  $ rake parallel:migrate
```

執行以下指令，即可同時多線跑測試 (加速)：

```
  $ RAILS_ENV=test rake parallel:spec
```


## 佈署上線 Deployment

Server 設定好 SSH key 之後，可在專案目錄下，執行以下指令佈署到 EZGO 正式站（production）：

```
  $ mina pro deploy
```

或是執行以下指令佈署到 EZGO 測試站（staging）：

```
  $ mina staging deploy
```


## 手動產生 Sitemap (在本機 Dev 端，與線上 Production 無關)

```
  $ bundle exec rake sitemap:refresh:no_ping
```
