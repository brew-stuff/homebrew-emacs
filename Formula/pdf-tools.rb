require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PdfTools < EmacsFormula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.70.tar.gz"
  sha256 "e7e46d98e9a66aadacc94a5da20c5ae3e592cdf4ba2d43a6e79aabc84dbc0ad4"
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
