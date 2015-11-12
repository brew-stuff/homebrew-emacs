require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PdfTools < EmacsFormula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.60.tar.gz"
  sha256 "3deff1183d69e942a9b9d94897e7aab73550574f953823815f5df925852d13f9"
  head "https://github.com/politza/pdf-tools.git"

  depends_on :emacs => "24.3"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "poppler"
  depends_on "homebrew/emacs/let-alist"
  depends_on "homebrew/emacs/tablist"

  def install
    system "make", "server/epdfinfo"
    bin.install "server/epdfinfo"

    byte_compile Dir["lisp/pdf*"]
    elisp.install Dir["lisp/pdf*.el"], Dir["lisp/pdf*.elc"]
  end

  def caveats; <<-EOS.undent
    Set the variable `pdf-info-epdfinfo-program' to
      #{HOMEBREW_PREFIX}/bin/epdfinfo
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/let-alist"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/tablist"].opt_elisp}")
      (setq pdf-info-epdfinfo-program "#{bin}/epdfinfo")
      (load "pdf-tools")
      (pdf-tools-toggle-debug)
      (print (minibuffer-prompt-width))
    EOS
    assert_match "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
