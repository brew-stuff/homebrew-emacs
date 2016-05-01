require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/capitaomorte/yasnippet"

  stable do
    url "https://github.com/capitaomorte/yasnippet.git",
        :tag => "0.9.1",
        :revision => "6aeccce2f17aca6a59a2790ec08680d52c03f6c0"

    patch do
      url "https://github.com/capitaomorte/yasnippet/commit/78fe979b7b4634ce2ef4d89363f1e1471a901230.diff"
      sha256 "6f12d833388920a3812ced24c37d1db3e9b0b9e35c65b55cef1befc29237ae50"
    end
  end

  head "https://github.com/capitaomorte/yasnippet.git"

  option "with-htmlize", "Build HTML docs with htmlize"

  depends_on :emacs => "23.1"
  depends_on "homebrew/emacs/htmlize" => :optional
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "yasnippet.el"
    ert_run_tests "yasnippet-tests.el"

    if build.with? "htmlize"
      system "rake", "doc[#{Formula["htmlize"].opt_elisp}]"
      doc.install "doc/images", "doc/stylesheets", Dir["doc/*.html"]
    end

    elisp.install Dir["*.el"], Dir["*.elc"]
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
