require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PdfTools < EmacsFormula
  desc "Emacs support library for PDF files"
  homepage "https://github.com/politza/pdf-tools"
  head "https://github.com/politza/pdf-tools.git"

  stable do
    url "https://github.com/politza/pdf-tools/archive/v0.70.tar.gz"
    sha256 "e7e46d98e9a66aadacc94a5da20c5ae3e592cdf4ba2d43a6e79aabc84dbc0ad4"

    # Fixes built against new versions of poppler; see https://github.com/politza/pdf-tools/issues/306
    patch do
      url "https://github.com/politza/pdf-tools/commit/dfa1355a2de2b8ba667ea8f94617c0092d979c97.diff"
      sha256 "876eb16fc2931b470ab4fe5048e54afb259ad50582ff8248e861a3b1c8b91586"
    end
  end

  depends_on :emacs => "24.3"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "cairo"
  depends_on "poppler"
  depends_on "dunn/emacs/let-alist"
  depends_on "dunn/emacs/tablist"

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
