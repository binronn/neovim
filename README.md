
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
