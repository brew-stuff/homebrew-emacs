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
        :tag => "0.9.0-beta",
        :revision => "cc64ff62bff29a2dc794a7573299fbe0b2bd1547"
  end

  depends_on :emacs => "23.1"

  def install
    system "rake", "compile"
    system "rake", "tests" unless build.stable?
    system "rake", "doc" unless build.devel?
    (share/"emacs/site-lisp/yasnippet").install Dir["*.el"], Dir["*.elc"]

    doc.install "README.mdown"
    if build.stable?
      (prefix/"contrib").install "extras"
    else
      (prefix/"contrib").install "snippets", "yasmate"
    end
  end

  def caveats; <<-EOS.undent
    Snippets have been installed to #{opt_prefix}/contrib

    Add the following to your init file:

    (require 'yasnippet)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/yasnippet")
      (load "yasnippet")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
