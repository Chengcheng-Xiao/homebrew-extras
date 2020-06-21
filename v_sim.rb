class VSim < Formula
  desc "GUI toolkit"
  homepage "https://gitlab.com/l_sim/v_sim/"
  # revision 9

  # keg_only :versioned_formula, "thi is X11 compatiable. See github.com/Chengcheng-Xiao/homebrew-extras"

  stable do
    url "https://gitlab.com/l_sim/v_sim/-/archive/version-3.7/v_sim-version-3.7.tar.gz"
    sha256 "19563a6a9b831f9058e5b927f52c5df2c70550b084e89dea5e38d7dc83b9b411"
  end

  depends_on "gcc"
  depends_on "autoconf"
  depends_on "automake"
  depends_on "gtk-doc"
  depends_on "libtool"
  depends_on "intltool"
  depends_on "pkg-config"
  depends_on "gtk"
  # depends_on "glib"
  # depends_on "cairo"
  # depends_on "pango"
  depends_on :x11


  def install
    args = ["--prefix=#{prefix}"]

    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"

  end

  def caveats
    <<~EOS
      This is the X11 compatiable version.
      depends on:
        gcc, autoconf, automake, gtk-doc, libtool
        intltool, pkg-config, gtk(private X11 version)
    EOS
  end
end
