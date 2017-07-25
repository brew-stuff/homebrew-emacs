require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/joaotavora/yasnippet"
  url "https://elpa.gnu.org/packages/yasnippet-0.12.1.tar"
  sha256 "96982462b3468e2b15306a398ca6cdd15b620b3578a5bcd9d1c370c487850107"
  head "https://github.com/joaotavora/yasnippet.git"

  bottle :disable

  option "with-htmlize", "Build HTML docs with htmlize"

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/htmlize" => :optional
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests "yasnippet-tests.el"
    byte_compile "yasnippet.el"

    if build.with? "htmlize"
      system "rake", "doc[#{Formula["htmlize"].opt_elisp}]"
      doc.install "doc/images", "doc/stylesheets", Dir["doc/*.html"]
    end
    elisp.install (Dir["*.el"] - %w[yasnippet-pkg.el]),
                  Dir["*.elc"]
    (prefix/"contrib").install "snippets"
  end

  def caveats
    "Snippets have been installed to #{opt_prefix}/contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "yasnippet")
      (yas-global-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
