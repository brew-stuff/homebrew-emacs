require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Elfeed < EmacsFormula
  desc "Feed reader for Emacs"
  homepage "https://github.com/skeeto/elfeed"
  url "https://github.com/skeeto/elfeed/archive/2.2.0.tar.gz"
  sha256 "8e7e4a26ce260cbaf9427ee5aa2c34812385f5b9b8b5d4541c938135e848f134"
  head "https://github.com/skeeto/elfeed.git"

  depends_on EmacsRequirement => "24.3"
  depends_on "dunn/emacs/simple-httpd"

  def install
    byte_compile Dir["web/*.el"]
    elisp.install "web"

    system "make", "test"
    elisp.install (Dir["*.el"] - %w[elfeed-pkg.el]), Dir["*.elc"]
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
