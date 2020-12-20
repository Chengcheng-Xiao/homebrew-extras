class Togl < Formula
  desc ""
  homepage ""
  url "https://sourceforge.net/projects/togl/files/Togl/2.0/Togl2.0-src.tar.gz"
  sha256 "b7d4a90bbad3aca618d505ee99e7fd8fb04c829f63231dda2360f557ba3f7610"

  #keg_only :versioned_formula, "thi is X11 compatiable. See github.com/Chengcheng-Xiao/homebrew-extras"  

  depends_on "gcc"
  depends_on "chengcheng-xiao/homebrew-extras/tcl-tk-x11"
  #depends_on :x11

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    ENV['CC'] = '/usr/bin/gcc' #homebrew gcc has linking problems...
    ENV['CFLAGS'] = '-I"/usr/X11/include" -I"/usr/local/opt/tcl-tk-x11/include"'
    # Remove unrecognized options if warned by configure

    system "./configure", "--enable-shared",
                          "--with-tcl=/usr/local/opt/tcl-tk-x11/lib",
                          "--with-tk=/usr/local/opt/tcl-tk-x11/lib",
                          "--with-x",
                          "--x-includes=/usr/X11/include",
                          "--x-libraries=/usr/X11/lib",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
