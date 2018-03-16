require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Auctex < EmacsFormula
  desc "Emacs package for writing and formatting TeX"
  homepage "https://www.gnu.org/software/auctex/"
  url "https://ftp.gnu.org/gnu/auctex/auctex-12.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/auctex/auctex-12.1.tar.gz"
  sha256 "c95cca4d70a9783617f7b5035c5e2c77438fa35d2505555d40190ac2652a5db4"

  head do
    url "https://git.savannah.gnu.org/git/auctex.git"
    depends_on "autoconf" => :build
  end

  # depends_on :tex
  depends_on EmacsRequirement => "21.1"

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
    <<~EOS
      texmf files have been installed into:
        #{HOMEBREW_PREFIX}/share/texmf
       You can add it to your TEXMFHOME using:
        sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"
    EOS
  end

  test do
    (testpath/".emacs").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (require 'tex-site)
    EOS
    (testpath/"test.tex").write <<~EOS
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
