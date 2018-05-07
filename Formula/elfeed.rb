require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Elfeed < EmacsFormula
  desc "Feed reader for Emacs"
  homepage "https://github.com/skeeto/elfeed"
  url "https://github.com/skeeto/elfeed/archive/3.1.0.tar.gz"
  sha256 "faf7e7ade781c57e4fb5bd0a3a605b8ceca500c6225c9ae75d2b19b889197b44"
  head "https://github.com/skeeto/elfeed.git"

  depends_on EmacsRequirement => "26"
  depends_on "dunn/emacs/simple-httpd"

  def install
    byte_compile Dir["web/*.el"]
    elisp.install "web"

    system "make", "test"
    elisp.install (Dir["*.el"] - %w[elfeed-pkg.el]), Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "elfeed")
      (print elfeed-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
