# CMake generated Testfile for 
# Source directory: /home/momma/bin/tmux-powerline/tmux-mem-cpu-load
# Build directory: /home/momma/bin/tmux-powerline/tmux-mem-cpu-load
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
ADD_TEST(usage "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load" "-h")
SET_TESTS_PROPERTIES(usage PROPERTIES  WILL_FAIL "TRUE")
ADD_TEST(no_arguments "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load")
ADD_TEST(colors "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load" "--colors")
ADD_TEST(arguments "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load" "--colors" "1" "4")
ADD_TEST(invalid_status_interval "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load" "-1" "4")
SET_TESTS_PROPERTIES(invalid_status_interval PROPERTIES  WILL_FAIL "TRUE")
ADD_TEST(invalid_graph_lines "/home/momma/bin/tmux-powerline/tmux-mem-cpu-load/tmux-mem-cpu-load" "1" "-4")
SET_TESTS_PROPERTIES(invalid_graph_lines PROPERTIES  WILL_FAIL "TRUE")
