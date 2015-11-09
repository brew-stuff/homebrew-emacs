require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GhEmacs < EmacsFormula
  desc "GitHub API library for Emacs"
  homepage "https://github.com/sigma/gh.el"
  url "https://github.com/sigma/gh.el/archive/v0.9.2.tar.gz"
  sha256 "02c819656293406773a2525f85bccbb4cbf57938999e33d86c0d1bfa047d34c6"
  head "https://github.com/sigma/gh.el.git"

  depends_on :emacs => "24.4"
  depends_on "homebrew/emacs/mocker" => :build
  depends_on "homebrew/emacs/logito"
  depends_on "homebrew/emacs/pcache"

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}", "PKGNAME=#{name}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/logito"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pcache"].opt_elisp}")
      (load "gh")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
