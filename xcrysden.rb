# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Xcrysden < Formula
  desc "Crystalline and molecular structure visualisation program"
  homepage "http://www.xcrysden.org/"
  url "http://www.xcrysden.org/download/xcrysden-1.6.2.tar.gz"
  sha256 "811736ee598bec1a5b427fd10e4e063a30dd7cadae96a43a50b36ce90a4f503f"

  depends_on "gcc"
  depends_on "tcl-tk-x11"
  depends_on "togl"
  depends_on "fftw"
  depends_on "wget" => :build
  #depends_on :x11

  # modify Make.sys
  patch :DATA

  def install
    cp "system/Make.sys-semishared-macosx-x11-xquartz-brew", "Make.sys"

    ENV.deparallelize
    system "make", "xcrysden"

    args = %W[
      prefix=#{prefix}
    ]

    system "make", *args, "install"
  end

  def caveats
    <<~EOS
      XCrySDen can be user-customized. Create $HOME/.xcrysden/ directory
      and copy the "custom-definitions" and "Xcrysden_resources" files
      from the Tcl/ subdirectory of the XCrySDen root directory.
      These can be then modified according to user preference.

      For more info about customization, see: http://www.xcrysden.org/doc/custom.html
    EOS
  end

  test do
    system bin/"xcrysden", "--version"
  end
end

__END__
diff -rupN xcrysden-1.6.2/system/Make.sys-semishared-macosx-x11-xquartz-brew xcrysden-1.6.2.my/system/Make.sys-semishared-macosx-x11-xquartz-brew
--- xcrysden-1.6.2/system/Make.sys-semishared-macosx-x11-xquartz-brew	1970-01-01 01:00:00.000000000 +0100
+++ xcrysden-1.6.2.my/system/Make.sys-semishared-macosx-x11-xquartz-brew	2020-04-08 12:46:33.000000000 +0100
@@ -0,0 +1,122 @@
+#########################################################################
+#
+#  Make.sys for X11 semishared compilation on Mac OS X
+#
+#  It will download Tcl, Tk, Togl, and FTTW3 tarballs from the
+#  internet and compile them for use with X11. After compilation they
+#  are installed in external/lib & external/include.
+#
+#
+#  This Make.sys uses the XQuartz.
+#
+########################################################################
+
+
+#------------------------------------------------------------------------
+# if you have a GNU make it is better to set the MAKE variable to point
+# to gnu make
+#------------------------------------------------------------------------
+MAKE = make
+
+
+#------------------------------------------------------------------------
+# compilers & flags
+#------------------------------------------------------------------------
+# C-preprocessor flags
+CPPFLAGS ?=
+# C-compiler flags
+CFLAGS += -ffast-math -funroll-loops -fPIC -pedantic -Wall
+
+CC     = /usr/bin/gcc
+#LDLIB  = -ldl
+MATH   = -lm -lc
+
+
+FFLAGS  += -static-libgfortran -static-libgcc -fdefault-double-8 -fdefault-real-8 -O2
+FC      = gfortran
+
+#-------------------------------------------
+#debug options
+#CFLAGS = -g
+#-------------------------------------------
+
+
+#------------------------------------------------------------------------
+# X-libraries & include files
+#------------------------------------------------------------------------
+
+DARWIN_X11_PREFIX = /usr/X11
+X_LIB     = -L$(DARWIN_X11_PREFIX)/lib -lXmu -lX11 -lXext
+X_INCDIR  = -I$(DARWIN_X11_PREFIX)/include
+
+#X_LIB     = -lXmu -lX11
+#X_INCDIR  = -I/opt/X11/include
+
+#------------------------------------------------------------------------
+# EXTERNAL LIBRARIES: Tcl/Tk/Mesa/Togl/FFTW
+
+# setting to "yes" will compile the corresponding library in external/src/
+COMPILE_TCLTK    = no
+COMPILE_TOGL     = no
+COMPILE_MESA     = no
+COMPILE_FFTW     = no
+# this is only used for some testing purposes
+COMPILE_MESCHACH = no
+
+# Do we want a shared library version of Tcl/Tk/Mesa/Togl?  If we want
+# shared then set the following flags to: --enable-shared else set the
+# following flag to: --disable-shared
+
+TCLTK_OPTIONS  = --enable-shared \
+               --with-x CFLAGS=-I/opt/X11/include --x-includes=/opt/X11/include --x-libraries=/opt/X11/lib
+TOGL_OPTIONS   = --enable-shared --with-tcl=/usr/local/opt/tcl-tk-x11/lib --with-tk=/usr/local/opt/tcl-tk-x11/lib \
+               --with-x CFLAGS="-I/usr/X11/include -I/usr/local/opt/tcl-tk-x11/include" --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib
+MESA_OPTIONS   = --enable-shared
+GLU_OPTIONS    = --enable-shared
+MESA_TARGET    = linux
+FFTW_OPTIONS   = --enable-shared
+
+
+#------------------------------------------------------------------------
+#
+# Libraries
+#
+
+#TCL_LIB      = -L$(TOPDIR)/external/lib -ltcl$(TCL_VER2)
+#TK_LIB       = -ltk$(TCL_VER2)
+#TOGL_LIB     = -L$(TOPDIR)/external/lib -lTogl$(TOGL_VER)
+#GLU_LIB      = -L/opt/X11/lib -lGLU
+#GL_LIB       = -lGL
+#FFTW3_LIB    = -lfftw3
+
+TOGL_LIB     = /usr/local/lib/Togl2.0/libTogl2.0.dylib
+TCL_VER      = $(shell /usr/local/bin/brew list tcl-tk-x11 --versions | sed 's/tcl-tk-x11\ \([0-9.]*\)[a-z.][0-9]*/\1/g')
+TCL_LIB      = -L/usr/local/opt/tcl-tk-x11/lib -ltcl$(TCL_VER)
+TK_LIB       = -L/usr/local/opt/tcl-tk-x11/lib -ltk$(TCL_VER)
+GLU_LIB      = -L$(DARWIN_X11_PREFIX)/lib -lGLU
+GL_LIB       = -L$(DARWIN_X11_PREFIX)/lib -lGL
+FFTW3_LIB    = -L/usr/local/lib -lfftw3
+
+# this is only used for some testing purposes
+#MESCHACH_LIB =  -lmeschach
+
+#
+# Include directories
+#
+
+#TCL_INCDIR      = -I$(TOPDIR)/external/include
+#TK_INCDIR       =
+TOGL_INCDIR     = /usr/local/include
+#GL_INCDIR       = -I/opt/X11/include
+#FFTW3_INCDIR    =
+
+TCL_INCDIR  = -I/usr/local/opt/tcl-tk-x11/include -I$(TOPDIR)/external/include
+TK_INCDIR   = -I/usr/local/opt/tcl-tk-x11/include
+GL_INCDIR   = -I$(DARWIN_X11_PREFIX)/include
+
+FFTW3_INCDIR    = -I/usr/local/include
+
+# this is only used for some testing purposes
+#MESCHACH_INCDIR =
+
+#------------------------------------------------------------------------
