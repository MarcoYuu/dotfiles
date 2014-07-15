python
import sys
sys.path.insert(0, '/share/home/momma/bin/gdb/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

python
import sys
sys.path.insert(0, '/share/home/momma/bin/gdb/Boost-Pretty-Printer')
from boost.printers import register_boost_printers
register_boost_printers(None)
end

set history save on
set history size 10000
set history filename /share/home/momma/.gdb_history
set print pretty on
set print static-members off
