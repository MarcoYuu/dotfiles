python
import sys
sys.path.insert(0, '~/bin/gdb-visualizer/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

python
import sys
sys.path.insert(0, '~/bin/gdb-visualizer/Boost-Pretty-Printer')
from boost.v1_40.printers import register_boost_printers
register_boost_printers(None)
end

set history save on
set history size 10000
set history filename ~/.gdb_history
set print pretty on
set print static-members off
