# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Togl < Formula
  desc ""
  homepage ""
  url "https://sourceforge.net/projects/togl/files/Togl/2.0/Togl2.0-src.tar.gz"
  sha256 "b7d4a90bbad3aca618d505ee99e7fd8fb04c829f63231dda2360f557ba3f7610"

  depends_on "gcc"
  depends_on "tcl-tk-x11"
  depends_on :x11

  def install
    ENV.deparallelize  # if your formula fails when building in parallel
    ENV['CC'] = 'gcc'
    ENV['CFLAGS'] = '-I/usr/X11/include -I/usr/local/opt/tcl-tk-x11/include'
    # Remove unrecognized options if warned by configure

    system "./configure", "--enable-shared",
                          "--with-tcl=/usr/local/opt/tcl-tk-x11/lib",
                          "--with-tk=/usr/local/opt/tcl-tk-x11/lib",
                          "--with-x",
                          "--x-includes=/usr/X11/include",
                          "--x-libraries=/usr/X11/lib--enable-shared",
                          "--prefix=#{prefix}",
                          "--exec_prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test Togl`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
