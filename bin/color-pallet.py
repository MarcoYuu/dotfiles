#! /usr/bin/python
# -*- coding: utf-8 -*-

# TermColorPalette256 (C) 2009-2010 kakurasan
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.


import sys
try:
  import pygtk
  pygtk.require('2.0')
except:
  pass
try:
  import gobject
  import gtk
except:
  print >> sys.stderr, 'Error: PyGTK is not installed'
  sys.exit(1)


class ColorDrawingButton(gtk.Button):
  """
  button with DrawingArea for color displaying
  """
  def __init__(self, code, color):
    gtk.Button.__init__(self)
    (self.__code, self.__color) = (code, color)
    self.__width = self.__height = 0
    self.__da = gtk.DrawingArea()
    self.add(self.__da)
    self.__da.connect('size-allocate', self.__on_da_size_allocate)
    self.__da.connect('expose-event', self.__on_da_expose_event)
    self.connect('clicked', self.__on_self_clicked)
    self.props.relief = gtk.RELIEF_NONE
    self.props.tooltip_text = 'code:%d color:%s' % (self.__code, self.__color)
  def __on_da_size_allocate(self, widget, allocation):
    """
    size changed
    """
    self.__width = allocation.width
    self.__height = allocation.height
  def __on_da_expose_event(self, widget, event):
    """
    draw/fill rectangle (using Cairo)
    """
    ctx = widget.window.cairo_create()
    ctx.set_source_color(gtk.gdk.Color(self.__color))
    ctx.rectangle(0, 0, self.__width, self.__height)
    ctx.fill()
  def __on_self_clicked(self, widget):
    """
    copy color code/string to clipboard
    """
    copy_type = widget.parent.parent.parent.parent.props.copy_type
    if copy_type == 'code':
      TermColorPalette256.clipboard.set_text(str(self.__code))
    else:
      color = self.__color
      if widget.parent.parent.parent.parent.props.no_numbersign:
        color = color[1:]
      if copy_type == 'upper':
        color = color.upper()
      TermColorPalette256.clipboard.set_text(color)

class ColorCubeColorTab(gtk.Table):
  """
  tab for colorcube color
  """
  table = [0x00, 0x5f, 0x87, 0xaf, 0xd7, 0xff]
  def __init__(self, offset):
    gtk.Table.__init__(self, 7, 7)
    for i in range(6):
      # 0 1 2 3 4 5
      self.attach(gtk.Label(str(i)), i + 1, (i + 1) + 1, 0, 1)
      # offset
      self.attach(gtk.Label('%03d' % (16 + 36 * offset + 6 * i)), 0, 1, i + 1, (i + 1) + 1)
    for i in range(6):
      for j in range(6):
        col = '#%02x%02x%02x' % (ColorCubeColorTab.table[offset], ColorCubeColorTab.table[i], ColorCubeColorTab.table[j])
        button = ColorDrawingButton(16 + 36 * offset + 6 * i + j, col)
        self.attach(button, j + 1, (j + 1) + 1, i + 1, (i + 1) + 1)

class GrayScaleColorTab(gtk.Table):
  """
  tab for grayscale color
  """
  def __init__(self):
    gtk.Table.__init__(self, 7, 7)
    for i in range(6):
      # 0 1 2 3 4 5
      self.attach(gtk.Label(str(i)), i + 1, (i + 1) + 1, 0, 1)
      # offset
      self.attach(gtk.Label('%03d' % (16 + 43 * i)), i + 1, (i + 1) + 1, 5, 6)
    for i in range(4):
      # each color code (16, 59, 102, 145, 188, 231)
      self.attach(gtk.Label('%03d' % (232 + 6 * i)), 0, 1, i + 1, (i + 1) + 1)
    self.attach(gtk.Label('c'), 0, 1, 6, 7)
    col = 0x08
    for i in range(4):
      for j in range(6):
        colstr = '#' + ('%02x' % col) * 3
        button = ColorDrawingButton(232 + 6 * i + j, colstr)
        self.attach(button, j + 1, (j + 1) + 1, i + 1, (i + 1) + 1)
        col += 10
    for i in range(6):
      col = ColorCubeColorTab.table[i]
      colstr = '#' + ('%02x' % col) * 3
      button = ColorDrawingButton(16 + 43 * i, colstr)
      self.attach(button, i + 1, (i + 1) + 1, 6, 7)
      col += 43

class MainWindow(gtk.Window):
  """
  main window
  """
  __gproperties__ = \
  {
    'copy-type' : (gobject.TYPE_STRING,
                   'copy type',
                   'copy type (code, lower, or upper)',
                   '',
                   gobject.PARAM_READABLE),
    'no-numbersign' : (gobject.TYPE_BOOLEAN,
                       'no numsign',
                       'if True, do not copy "#"',
                       False,
                       gobject.PARAM_READABLE),
  }
  def __init__(self, *args, **kwargs):
    gtk.Window.__init__(self, *args, **kwargs)
    self.props.title = 'TermColorPalette256'
    self.set_size_request(450, 250)
    self.resize(450, 260)
    self.__accelgroup = gtk.AccelGroup()
    self.add_accel_group(self.__accelgroup)
    self.__item_quit = gtk.ImageMenuItem(gtk.STOCK_QUIT, self.__accelgroup)
    self.__item_about = gtk.ImageMenuItem(gtk.STOCK_ABOUT, self.__accelgroup)
    self.__menu_file = gtk.Menu()
    self.__menu_file.add(self.__item_quit)
    self.__menu_help = gtk.Menu()
    self.__menu_help.add(self.__item_about)
    self.__item_file = gtk.MenuItem('_File')
    self.__item_help = gtk.MenuItem('_Help')
    self.__item_file.props.submenu = self.__menu_file
    self.__item_help.props.submenu = self.__menu_help
    self.__menubar = gtk.MenuBar()
    self.__menubar.append(self.__item_file)
    self.__menubar.append(self.__item_help)
    self.__radio_copy_colorcode = gtk.RadioButton(label='_code')
    self.__radio_copy_colorstr_lower = gtk.RadioButton(group=self.__radio_copy_colorcode, label='string/_lowercase')
    self.__radio_copy_colorstr_upper = gtk.RadioButton(group=self.__radio_copy_colorcode, label='string/_uppercase')
    self.__check_copy_no_numsign = gtk.CheckButton('no _numbersign(#)')
    self.__check_copy_no_numsign.props.sensitive = False
    # containers
    self.__notebook = gtk.Notebook()
    self.__notebook.props.tab_pos = gtk.POS_LEFT
    for i in range(6):
      child = ColorCubeColorTab(i)
      self.__notebook.append_page(child)
      self.__notebook.set_tab_label_text(child, '%03d-%03d(R=0x%02x)' % ((16 + 36 * i), (16 + 36 * (i + 1) - 1), ColorCubeColorTab.table[i]))
    child = GrayScaleColorTab()
    self.__notebook.append_page(child)
    self.__notebook.set_tab_label_text(child, 'grayscale')
    self.__hbox_copy = gtk.HBox()
    self.__hbox_copy.pack_start(self.__radio_copy_colorcode, expand=False, fill=False)
    self.__hbox_copy.pack_start(self.__radio_copy_colorstr_lower, expand=False, fill=False)
    self.__hbox_copy.pack_start(self.__radio_copy_colorstr_upper, expand=False, fill=False)
    self.__hbox_copy.pack_start(self.__check_copy_no_numsign, expand=False, fill=False)
    self.__vbox = gtk.VBox()
    self.__vbox.pack_start(self.__menubar, expand=False, fill=False)
    self.__vbox.pack_start(self.__notebook)
    self.__vbox.pack_start(self.__hbox_copy)
    self.add(self.__vbox)
    # signals
    self.__item_quit.connect('activate', gtk.main_quit)
    self.__item_about.connect('activate', self.__on_item_about_activate)
    self.__radio_copy_colorcode.connect('toggled', lambda widget: self.__check_copy_no_numsign.set_sensitive(not widget.props.active))
    self.connect('delete_event', gtk.main_quit)
    try:
      self.__icon = gtk.gdk.pixbuf_new_from_file('/usr/share/pixmaps/gnome-color-xterm.png')
      self.props.icon = self.__icon
    except:
      self.__icon = None
  def __on_item_about_activate(self, widget):
    """
    run about dialog
    """
    aboutdlg = gtk.AboutDialog()
    aboutdlg.props.authors = ['kakurasan <kakurasan AT gmail DOT com>',]
    aboutdlg.props.copyright = '〓 2009-2010 kakurasan'
    aboutdlg.props.license = 'This program is licensed under GPL-3 or lator.'
    aboutdlg.props.version = '1.0'
    aboutdlg.props.comments = 'terminal 256 color palette/selector'
    aboutdlg.props.logo = aboutdlg.props.icon = self.__icon
    aboutdlg.set_program_name('TermColorPalette256')
    aboutdlg.run()
    aboutdlg.destroy()
  def do_get_property(self, property):
    """
    get property
    """
    if property.name == 'copy-type':
      if self.__radio_copy_colorcode.props.active:
        return 'code'
      elif self.__radio_copy_colorstr_lower.props.active:
        return 'lower'
      else:
        return 'upper'
    elif property.name == 'no-numbersign':
      return self.__check_copy_no_numsign.props.active

class TermColorPalette256:
  """
  terminal 256 color palette/selector
  """
  clipboard = gtk.Clipboard()
  def main(self):
    """
    main
    """
    win = MainWindow()
    win.show_all()
    gtk.main()


if __name__ == '__main__':
  app = TermColorPalette256()
  app.main()
