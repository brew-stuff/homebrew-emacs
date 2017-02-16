require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GhEmacs < EmacsFormula
  desc "GitHub API library for Emacs"
  homepage "https://github.com/sigma/gh.el"
  url "https://github.com/sigma/gh.el/archive/v0.10.0.tar.gz"
  sha256 "f1e4244c329197f1d659a024c8fe20e0d62d1e74578f8bebac216b8defc02635"
  head "https://github.com/sigma/gh.el.git"

  depends_on :emacs => "24.4"
  depends_on "dunn/emacs/mocker" => :build
  depends_on "dunn/emacs/logito"
  depends_on "dunn/emacs/pcache"

  def install
    system "make", "test"
    system "make", "install", "PREFIX=#{prefix}", "PKGNAME=#{name}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/logito"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/pcache"].opt_elisp}")
      (load "gh")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
