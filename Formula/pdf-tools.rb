require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PdfTools < EmacsFormula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  url "https://github.com/politza/pdf-tools/archive/v0.80.tar.gz"
  sha256 "663d22ce4a56c1eb75a329fa4ab5f77d92c030fcc1deaf4ec95b24356cf3351a"
  head "https://github.com/politza/pdf-tools.git"

  depends_on EmacsRequirement => "24.4"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "poppler"
  depends_on "dunn/emacs/let-alist"
  depends_on "dunn/emacs/tablist"

  def install
    system "make", "server/epdfinfo", "CC=/usr/bin/gcc", "CXX=/usr/bin/gcc", "AR=/usr/bin/ar", "RANLIB=/usr/bin/ranlib"
    bin.install "server/epdfinfo"

    byte_compile Dir["lisp/pdf*"]
    elisp.install Dir["lisp/pdf*.el"], Dir["lisp/pdf*.elc"]
  end

  def caveats; <<~EOS
    Set the variable `pdf-info-epdfinfo-program' to
      #{HOMEBREW_PREFIX}/bin/epdfinfo
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/let-alist"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/tablist"].opt_elisp}")
      (setq pdf-info-epdfinfo-program "#{bin}/epdfinfo")
      (load "pdf-tools")
      (pdf-tools-toggle-debug)
      (print (minibuffer-prompt-width))
    EOS
    assert_match "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
