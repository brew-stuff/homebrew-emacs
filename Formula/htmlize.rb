require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Htmlize < EmacsFormula
  desc "Emacs package for converting text to HTML"
  homepage "http://www.us.xemacs.org/People/hrvoje.niksic/"
  url "https://github.com/hniksic/emacs-htmlize/archive/release/1.49.tar.gz"
  sha256 "b450fa229bef77741b98b121a84ad27e2e0c530bbf87a589e06f3bab94a89682"
  head "https://github.com/dunn/htmlize-mirror.git"

  depends_on :emacs => "22.1"

  def install
    byte_compile "htmlize.el"
    elisp.install "htmlize.el", "htmlize.elc"
  end

  test do
    (testpath/"test.txt").write "hello"

    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "htmlize")
      (htmlize-file "#{testpath}/test.txt" "#{testpath}/out.html")
    EOS
    system "emacs", "-Q", "--batch", "-l", testpath/"test.el"
    assert_equal "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01//EN\">",
                 File.read(testpath/"out.html").split("\n").first
  end
end
