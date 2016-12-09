require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Htmlize < EmacsFormula
  desc "Emacs package for converting text to HTML"
  homepage "http://www.us.xemacs.org/People/hrvoje.niksic/"
  url "https://github.com/hniksic/emacs-htmlize/archive/release/1.50.tar.gz"
  sha256 "e39148a591992e06254b1d50c8ddeeff07283df076dc1a986258ed527619f306"
  head "https://github.com/hniksic/emacs-htmlize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c024aac4ec3392bb76d42dcdac82317d1fbd9f6e8900e6e0add36b0a35d78d3" => :sierra
    sha256 "9c48a034c4489d9bace86fedb3830a72b05699451c19d3f90ef5926d4785e1d6" => :el_capitan
    sha256 "9c48a034c4489d9bace86fedb3830a72b05699451c19d3f90ef5926d4785e1d6" => :yosemite
  end

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
