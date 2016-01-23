require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/capitaomorte/yasnippet"
  url "https://github.com/capitaomorte/yasnippet.git",
      :tag => "0.8.0",
      :revision => "f28a3df702c62f1b045ea5b57d1344c90ebc9731"

  head "https://github.com/capitaomorte/yasnippet.git"

  devel do
    url "https://github.com/capitaomorte/yasnippet.git",
        :tag => "0.9.1-snapshot",
        :revision => "80941c077f8248ee1e8dcc64b3b57e741b9e5755"
  end

  depends_on :emacs => "23.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "yasnippet.el"
    ert_run_tests "yasnippet-tests.el" unless build.stable?
    elisp.install Dir["*.el"], Dir["*.elc"]

    if build.stable?
      (prefix/"contrib").install "extras"
    else
      (prefix/"contrib").install "snippets", "yasmate"
    end
  end

  def caveats; <<-EOS.undent
    Snippets have been installed to #{opt_prefix}/contrib
  EOS
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
