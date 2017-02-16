require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/joaotavora/yasnippet"
  url "https://github.com/joaotavora/yasnippet/archive/0.11.0.tar.gz"
  sha256 "05c7d47be7296add65519e2ed4f588120a60290635ebdb1a3e2b01376735b195"
  head "https://github.com/joaotavora/yasnippet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e232de891a90050a690ed93e196bdc83cf6ca98d041dfe6e6918b806ee2324c0" => :sierra
    sha256 "e232de891a90050a690ed93e196bdc83cf6ca98d041dfe6e6918b806ee2324c0" => :el_capitan
    sha256 "e232de891a90050a690ed93e196bdc83cf6ca98d041dfe6e6918b806ee2324c0" => :yosemite
  end

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

    elisp.install Dir["*.el"], Dir["*.elc"]
    (prefix/"contrib").install "snippets"
  end

  def caveats
    "Snippets have been installed to #{opt_prefix}/contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "yasnippet")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
