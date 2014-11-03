python
import sys
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

python
import sys
from boost.printers import register_printer_gen
register_printer_gen(None)
end

set history save on
set history size 10000
set history filename $HOME/.gdb_history
set print pretty on
set print static-members off
