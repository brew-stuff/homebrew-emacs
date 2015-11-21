require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Elfeed < EmacsFormula
  desc "Feed reader for Emacs"
  homepage "https://github.com/skeeto/elfeed"
  url "https://github.com/skeeto/elfeed/archive/1.3.0.tar.gz"
  sha256 "96f59f4a05e3339994dee453b89957147f5729d1012cdcb914f5cf41655a5e12"
  head "https://github.com/skeeto/elfeed.git"

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/simple-httpd"

  def install
    byte_compile Dir["web/*.el"]
    elisp.install "web"

    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "elfeed")
      (print elfeed-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
