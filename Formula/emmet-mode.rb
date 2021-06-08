require File.expand_path("../Homebrew/emacs_formula", __dir__)

class EmmetMode < EmacsFormula
  desc "Emacs mode for writing HTML with the Emmet syntax"
  homepage "https://github.com/smihica/emmet-mode"
  url "https://github.com/smihica/emmet-mode/archive/1.0.8.tar.gz"
  sha256 "f21f1786f5f8e8b1760858601d476957544163a2afa5ed184a97b9a5bc10773c"
  head "https://github.com/smihica/emmet-mode.git"

  depends_on EmacsRequirement => "23.1"

  def install
    system "make", "test"
    system "make", "all"
    elisp.install "emmet-mode.el", "emmet-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "emmet-mode")
      (print emmet-mode:version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
