require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/joaotavora/yasnippet"
  url "https://elpa.gnu.org/packages/yasnippet-0.13.0.tar"
  sha256 "bf6850175b7cc4e376501085e41edde92635495370ddec4f3c707c85bcdf96ce"
  head "https://github.com/joaotavora/yasnippet.git"

  bottle :disable

  option "with-htmlize", "Build HTML docs with htmlize"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/htmlize" => :optional
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  resource "snippets" do
    url "https://github.com/AndreaCrotti/yasnippet-snippets/archive/0.3.tar.gz"
    sha256 "96ed67308be785dd1a661658f123a88b0757794639afb246a5c6acbc758fe342"
  end

  def install
    ert_run_tests "yasnippet-tests.el"
    byte_compile "yasnippet.el"

    if build.with? "htmlize"
      system "rake", "doc[#{Formula["htmlize"].opt_elisp}]"
      doc.install "doc/images", "doc/stylesheets", Dir["doc/*.html"]
    end
    elisp.install (Dir["*.el"] - %w[yasnippet-pkg.el]),
                  Dir["*.elc"]
    (prefix/"contrib").install resource("snippets")
  end

  def caveats
    "Snippets have been installed to #{opt_prefix}/contrib"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "yasnippet")
      (yas-global-mode 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
