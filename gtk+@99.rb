class GtkxAT99 < Formula
  desc "GUI toolkit"
  homepage "https://gtk.org/"
  revision 99

  keg_only :versioned_formula, "thi is X11 compatiable. See github.com/Chengcheng-Xiao/homebrew-extras"

  stable do
    url "https://download.gnome.org/sources/gtk+/2.24/gtk+-2.24.32.tar.xz"
    sha256 "b6c8a93ddda5eabe3bfee1eb39636c9a03d2a56c7b62828b359bf197943c582e"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/gtk.git", :branch => "gtk-2-24"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "chengcheng-xiao/extras/glib@99"
  depends_on "chengcheng-xiao/extras/cairo@99"
  depends_on "chengcheng-xiao/extras/pango@99"
  depends_on "atk"
  depends_on "gdk-pixbuf"
  depends_on "hicolor-icon-theme"
  #depends_on :x11


  # Patch to allow Eiffel Studio to run in Cocoa / non-X11 mode, as well as Freeciv's freeciv-gtk2 client
  # See:
  # - https://bugzilla.gnome.org/show_bug.cgi?id=757187
  # referenced from
  # - https://bugzilla.gnome.org/show_bug.cgi?id=557780
  # - Homebrew/homebrew-games#278
  # patch do
  #   url "https://bug757187.bugzilla-attachments.gnome.org/attachment.cgi?id=331173"
  #   sha256 "ce5adf1a019ac7ed2a999efb65cfadeae50f5de8663638c7f765f8764aa7d931"
  # end

  def install
    args = ["--disable-dependency-tracking",
            "--disable-silent-rules",
            "--prefix=#{prefix}",
            "--enable-static",
            "--disable-glibtest",
            "--enable-introspection=yes",
            # "--with-gdktarget=quartz",
            # "--disable-visibility"]
            "--with-gdktarget=x11",
            "--enable-x11-backend",
            "--x-includes=/usr/X11/include",
            "--x-libraries=/usr/X11/lib"]

    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      ENV["NOCONFIGURE"] = "yes"
      system "./autogen.sh"
    end
    # Soft link pango share folder to local/share. this part needs improvement.
    # -------------------------------------------------------------------------
#    system "ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/Pango-1.0.gir      /usr/local/share/gir-1.0/Pango-1.0.gir"
#    system "ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoCairo-1.0.gir /usr/local/share/gir-1.0/PangoCairo-1.0.gir"
#    system "ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoFT2-1.0.gir   /usr/local/share/gir-1.0/PangoFT2-1.0.gir"
#    system "ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoXft-1.0.gir   /usr/local/share/gir-1.0/PangoXft-1.0.gir"
    system "./configure", *args
    system "make", "install"

    inreplace bin/"gtk-builder-convert", %r{^#!/usr/bin/env python$}, "#!/usr/bin/python"
  end

  def caveats
    <<~EOS
      This is the X11 compatiable version.
    EOS
  end


  test do
    (testpath/"test.c").write <<~EOS
      #include <gtk/gtk.h>

      int main(int argc, char *argv[]) {
        GtkWidget *label = gtk_label_new("Hello World!");
        return 0;
      }
    EOS
    atk = Formula["atk"]
    cairo = Formula["cairo-x11"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gdk_pixbuf = Formula["gdk-pixbuf"]
    gettext = Formula["gettext"]
    glib = Formula["glib-x11"]
    harfbuzz = Formula["harfbuzz"]
    libpng = Formula["libpng"]
    pango = Formula["pango-x11"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{atk.opt_include}/atk-1.0
      -I#{cairo.opt_include}/cairo
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gdk_pixbuf.opt_include}/gdk-pixbuf-2.0
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{harfbuzz.opt_include}/harfbuzz
      -I#{include}/gtk-2.0
      -I#{libpng.opt_include}/libpng16
      -I#{lib}/gtk-2.0/include
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{atk.opt_lib}
      -L#{cairo.opt_lib}
      -L#{gdk_pixbuf.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -L#{pango.opt_lib}
      -latk-1.0
      -lcairo
      -lgdk-quartz-2.0
      -lgdk_pixbuf-2.0
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lgtk-quartz-2.0
      -lintl
      -lpango-1.0
      -lpangocairo-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
