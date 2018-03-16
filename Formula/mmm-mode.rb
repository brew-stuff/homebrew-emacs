require File.expand_path("../Homebrew/emacs_formula", __dir__)

class MmmMode < EmacsFormula
  desc "Enable Multiple Major Modes in Emacs buffers"
  homepage "https://github.com/purcell/mmm-mode"
  url "https://github.com/purcell/mmm-mode/archive/0.5.5.tar.gz"
  sha256 "0c7fec2371c0b84d461732219e1d86c88e6a76e42e430cd199e46406c7b3b130"
  head "https://github.com/purcell/mmm-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.3"
  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "mmm-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
