class Auctex < Formula
  desc "Emacs package for writing and formatting TeX"
  homepage "https://www.gnu.org/software/auctex/"
  url "https://ftpmirror.gnu.org/auctex/auctex-11.90.tar.gz"
  mirror "https://ftp.gnu.org/gnu/auctex/auctex-11.90.tar.gz"
  sha256 "3c232fd8e57780edea28cd3035afcc2b6ed965b5954e96b34a258cacfcaaf18f"

  head do
    url "http://git.savannah.gnu.org/cgit/auctex.git"
    depends_on "autoconf" => :build
  end

  depends_on :tex
  depends_on :emacs => "21.1"

  def install
    # configure fails if the texmf dir is not there yet
    (share/"texmf").mkpath

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-texmf-dir=#{share}/texmf",
                          "--with-emacs=#{which "emacs"}",
                          "--with-lispdir=#{elisp}"
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    texmf files have been installed into:
      #{HOMEBREW_PREFIX}/share/texmf

    You can add it to your TEXMFHOME using:
      sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"
    EOS
  end

  test do
    (testpath/".emacs").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'tex-site)
    EOS
    (testpath/"test.tex").write <<-'EOS'.undent
      \documentclass{article}
      \begin{document}
      This file is incomplete.
    EOS
    system "emacs", "-l", testpath/".emacs", "--batch", "test.tex",
      "--eval=(goto-char (point-max))", "--eval=(LaTeX-close-environment)",
      "-f", "save-buffer"
    assert_equal '\end{document}', File.read("test.tex").lines.last.chomp
  end
end
