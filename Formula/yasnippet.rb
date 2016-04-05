require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/capitaomorte/yasnippet"
  url "https://github.com/capitaomorte/yasnippet.git",
      :tag => "0.9.1",
      :revision => "6aeccce2f17aca6a59a2790ec08680d52c03f6c0"

  head "https://github.com/capitaomorte/yasnippet.git"

  depends_on :emacs => "23.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "yasnippet.el"
    ert_run_tests "yasnippet-tests.el"
    elisp.install Dir["*.el"], Dir["*.elc"]

    prefix.install "doc"
    (prefix/"contrib").install "snippets", "yasmate"
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
