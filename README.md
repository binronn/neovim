
# 字体安装

安装好字体后，再打开 Windows terminal 终端，不然会报出找不到字体的错误
注意选择字体名称时，要与文件夹名字一致，不要忘记 NF ！

# init.sh
在首次安装时若无法正常加载插件，则运行这个

# COC 问题
1. 若 coc 加载不正常，
2. 删除 ~/.config/coc 文件夹
3. 删除插件目录中的 coc.nvim 文件夹 (~/.local/share/nvim/site/pack/packer/start/coc.nvim)
4. 打开 nvim 运行 :PackerSync 会重新安装 coc 插件

手动安装 clangd 插件，要拷贝目录至 插件目录，否则将出现找不到头文件的情况
或使用 coc 安装最新的 clangd :CocCommand clangd.install

路径在 coc-setting.json 中，可手动下载复制

# LeaderF 问题
使用之前需先编译，编译时需要 python3.x-dev 包，编译命令: LeaderfInstallCExtension
若编译失败，需进入到插件目录内，修改 install.sh 中的 python2 代码块后 重新编译

# 高亮问题
`tree-sitter CLI not found: `tree-sitter` is not executable!`
执行命令: sudo npm install -g tree-sitter-cli

# Vista 安装
sudo apt-get install libjansson-dev

then compile and install universal-ctags.

NOTE: Don't use `sudo apt install ctags`, which will install exuberant-ctags and it's not guaranteed to work with vista.vim.

git clone https://github.com/universal-ctags/ctags.git --depth=1

cd ctags

./autogen.sh

./configure

make

sudo make install

# LazyGit install

LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

tar xf lazygit.tar.gz lazygit

sudo install lazygit /usr/local/bin

