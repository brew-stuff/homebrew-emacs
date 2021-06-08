require File.expand_path("../Homebrew/emacs_formula", __dir__)

class SEmacs < EmacsFormula
  desc "Emacs string manipulation library"
  homepage "https://github.com/magnars/s.el"
  url "https://github.com/magnars/s.el/archive/1.11.0.tar.gz"
  sha256 "826d186458f7568f1304bca0c094034a9e7370bd2858dcf806dd513abe2d384f"
  head "https://github.com/magnars/s.el.git"

  depends_on EmacsRequirement => "23.1"

  def install
    system "./run-tests.sh"
    system "./create-docs.sh" if build.head?

    byte_compile "s.el"
    elisp.install "s.el", "s.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "s")
      (print (s-repeat 4 "omg"))
    EOS
    assert_equal "\"omgomgomgomg\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
