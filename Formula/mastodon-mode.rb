require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MastodonMode < EmacsFormula
  desc "Client and major mode for Mastodon"
  homepage "https://github.com/jdenen/mastodon.el"
  url "https://github.com/jdenen/mastodon.el/archive/0.6.2.tar.gz"
  sha256 "85b0f8539e8a1eca6d1d1f8b009b9e8a9974e8594d525a04cb489c12c03725f7"
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
      (print mastodon-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
