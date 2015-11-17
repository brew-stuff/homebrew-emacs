require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class S < EmacsFormula
  desc "Emacs string manipulation library"
  homepage "https://github.com/magnars/s.el"
  url "https://github.com/magnars/s.el/archive/1.10.0.tar.gz"
  sha256 "376c4c1577ac99ce5d510cd957d8d7b4f218ca6b8012f9459a5d902de1d53c3b"
  head "https://github.com/magnars/s.el.git"

  depends_on :emacs => "23.1"

  def install
    system "./run-tests.sh"
    system "./create-docs.sh" if build.head?

    byte_compile "s.el"
    elisp.install "s.el", "s.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "s")
      (print (s-repeat 4 "omg"))
    EOS
    assert_equal "\"omgomgomgomg\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
