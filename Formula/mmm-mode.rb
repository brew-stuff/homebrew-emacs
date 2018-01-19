require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MmmMode < EmacsFormula
  desc "Enable Multiple Major Modes in Emacs buffers"
  homepage "https://github.com/purcell/mmm-mode"
  url "https://github.com/purcell/mmm-mode/archive/0.5.4.tar.gz"
  sha256 "db55529ba95f841826bee952e73e55b87d9c191004e7c985a9582eea2cd57c82"
  head "https://github.com/purcell/mmm-mode.git"

  bottle :disable

  depends_on EmacsRequirement
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
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "mmm-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
