
# 字体安装

安装好字体后，再打开 Windows terminal 终端，不然会报出找不到字体的错误
注意选择字体名称时，要与文件夹名字一致，不要忘记 NF ！

# init.sh

在首次安装时若无法正常加载插件，则运行这个

# 高亮问题

`tree-sitter CLI not found: `tree-sitter` is not executable!`
执行命令: sudo npm install -g tree-sitter-cli

# Font

https://github.com/microsoft/cascadia-code/release

# nodjs 

## 安装

```shell
# 更新包列表
sudo apt-get update

# 安装依赖
sudo apt-get install -y curl

# 下载并运行 NodeSource 的安装脚本
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# 安装 Node.js
sudo apt-get install -y nodejs
```

# 安装 pyright

```shell
更换华为源
npm config set registry https://mirrors.huaweicloud.com/repository/npm/

## 安装 pyright
sudo npm i -g pyright 
```

# 安装 ripgrep for telescope

``` shell
sudo apt-get install ripgrep
```

# 安装 ctags for telescope

```shell
sudo apt-get install exuberant-ctags
```

# 安装 pynvim

```shell
pip3 install pynvim
```

# 安装 GDB for dap cpp

need gdb version >= 14.1 from source code build

source code for gdb 15+ -> https://www.linuxfromscratch.org/blfs/view/git/general/gdb.html

# 安装编译工具 for dap and cmake-tool

```shell
sudo apt install clang clang++ gcc g++ make cmake
```

# OpenAiKey for avant

export OPENAI_API_KEY=sk-***
