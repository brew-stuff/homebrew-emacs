require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MBuffer < EmacsFormula
  desc "List oriented buffer operations for Emacs"
  homepage "https://github.com/phillord/m-buffer-el"
  url "https://github.com/phillord/m-buffer-el/archive/v0.15.tar.gz"
  sha256 "2408358cca5431e518fb0450c299e3d5c61d010b9c7b89d26a099f8111636d9f"
  head "https://github.com/phillord/m-buffer-el.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "cask" => :build

  depends_on "dunn/emacs/seq"

  def install
    system "make", "test"

    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
    doc.install "m-buffer-doc.org"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "m-buffer")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
