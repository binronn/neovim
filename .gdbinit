
python
import os
import sys
base_dir = os.getenv('DEVELOP_BASE')
gdbscript_dir = os.path.join(base_dir, 'nvim-win64/nvim-config/nvim/gdbscript')
print('Gdb script dir base: ' + gdbscript_dir)
sys.path.insert(0, gdbscript_dir)
from libcxx.v1.printers import register_libcxx_printers
register_libcxx_printers(None)
#from libstdcxx.v6.printers import register_libstdcxx_printers
#from libstdcxx.v6.xmethods import register_libstdcxx_xmethods
#register_libstdcxx_xmethods(None)
#register_libstdcxx_printers (None)
end

set print pretty on
set print object on

#######################################################
#######################################################
# 必须放在脚本初始化之后
#######################################################

# 设置 GDB 打印数字时默认使用十六进制格式
set output-radix 16

# 强制所有整数类型（包括 char, unsigned char, int, uint64_t 等）以十六进制显示
set print hex
set print unsigned

#######################################################



define hook-run
	b abort
	catch throw
	catch catch

	# SIGINT	中断信号（通常由 Ctrl+C 触发）。在调试时，你可能希望忽略它以避免意外中断。
	# SIGTERM	终止信号（通常由 kill 命令触发）。在调试时，通常不需要捕获它。
	# SIGCHLD	子进程状态改变信号。通常由子进程退出触发，调试时通常可以忽略。
	# SIGWINCH	窗口大小改变信号。通常由终端调整大小触发，调试时通常可以忽略。
	# SIGALRM	定时器信号。通常由定时器触发，调试时通常可以忽略。

	handle all stop print
	handle SIGABRT stop print

	handle SIGINT nostop noprint pass
	handle SIGTERM nostop noprint pass
	handle SIGCHLD nostop noprint pass
	handle SIGWINCH nostop noprint pass
	handle SIGALRM nostop noprint pass
	echo "Catchpoints set for throw exceptions.\n"
end

define hook-stop
# 检查是否是因为信号中断
	if $_siginfo.si_signo != 0
		printf "Signal received: %s\n", $_siginfo.si_signo
		printf "Fault address: 0x%lx\n", $_siginfo._sifields._sigfault.si_addr
	end

# 检查是否是因为捕获异常
	if $_exception != 0
		printf "Exception caught: %s\n", $_exception.what
	end
end

# 定义一个函数来遍历 std::set
define traverse_set
  # 参数：$arg0 是 std::set 的变量名
	if $arg0.size() == 0
		printf "The set is empty.\n"
	else
		set $begin = $arg0.begin()
		set $end = $arg0.end()
		printf "Traversing set (%d elements):\n", $arg0.size()
		while $begin != $end
			p *$begin
			set $begin++
		end
	end
end

# 提示用户函数已加载
printf "Function 'traverse_set' is ready. Use 'traverse_set <set_variable>' to traverse a std::set.\n"
echo "Gdbinit loaded."
