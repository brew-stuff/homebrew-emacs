require File.expand_path("../Homebrew/emacs_formula", __dir__)

class MastodonMode < EmacsFormula
  desc "Client and major mode for Mastodon"
  homepage "https://github.com/jdenen/mastodon.el"
  url "https://github.com/jdenen/mastodon.el/archive/0.7.2.tar.gz"
  sha256 "18194b2b274eec0902c581b7781e93db733acd93e816f8fc8fe8933aa2a19a22"
  head "https://github.com/jdenen/mastodon.el.git"

  depends_on EmacsRequirement => "24.4"
  depends_on "cask" => :build

  def install
    system "cask", "install"
    system "cask", "exec", "ert-runner",
           "-l", "test/ert-helper.el",
           *Dir["test/*-tests.el"]

    byte_compile Dir["lisp/*.el"]
    elisp.install Dir["lisp/*.el"], Dir["lisp/*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "mastodon")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
