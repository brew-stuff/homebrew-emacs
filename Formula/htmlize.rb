require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Htmlize < EmacsFormula
  desc "Emacs package for converting text to HTML"
  homepage "https://github.com/hniksic/emacs-htmlize/"
  url "https://github.com/hniksic/emacs-htmlize/archive/release/1.51.tar.gz"
  sha256 "8df2b88bf80acb03fbacdeae0e3bdbf579f46d0ad73884325288f6fc97a7c1bb"
  head "https://github.com/hniksic/emacs-htmlize.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21f38b76a75c1be07252a2d23748ee90c001bf3f6f56e7bf4d7aac3bcf8cdb13" => :sierra
    sha256 "152bd496933fd102693cc0ba1b394cd18c261714a364d572c52bdce68b6086d6" => :el_capitan
    sha256 "152bd496933fd102693cc0ba1b394cd18c261714a364d572c52bdce68b6086d6" => :yosemite
  end

  depends_on EmacsRequirement => "22.1"

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
