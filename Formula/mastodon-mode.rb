require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MastodonMode < EmacsFormula
  desc "Client and major mode for Mastodon"
  homepage "https://github.com/jdenen/mastodon.el"
  url "https://github.com/jdenen/mastodon.el/archive/0.7.0.tar.gz"
  sha256 "f54b789c1b900f7856e7c5b89c6d093376a32ad6ea817aa83552fc215f4e9231"
  head "https://github.com/jdenen/mastodon.el.git"

  depends_on :emacs => "24.4"
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
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "mastodon")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
