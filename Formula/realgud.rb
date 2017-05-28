require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Realgud < EmacsFormula
  desc "Emacs front-end for interacting with external debuggers"
  homepage "https://github.com/realgud/realgud"
  head "https://github.com/realgud/realgud.git"

  stable do
    url "https://elpa.gnu.org/packages/realgud-1.4.3.tar"
    sha256 "01c83b3d51f31888171e3c332336f54bc382e8d10f792433ccc0e43a1154ce1f"

    # Fixes `make check`; remove with next release
    patch do
      url "https://github.com/realgud/realgud/commit/d7bac581f04756582078cd9ea45e5a28406ee05c.diff"
      sha256 "6153f6bfa7efe70944d71cc6147c67415125a898068b1dbb9206977e99ccadaf"
    end
  end

  depends_on :emacs => "24.3"
  depends_on "homebrew/emacs/load-relative"
  depends_on "homebrew/emacs/test-simple"
  depends_on "homebrew/emacs/loc-changes"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./autogen.sh", "--disable-silent-rules",
                           "--mandir=#{man}",
                           "--prefix=#{prefix}",
                           "--with-lispdir=#{elisp}"
    system "make"
    system "make", "check"
    system "make", "install"

    # keep lang and common libs from shadowing system; see
    # https://github.com/realgud/realgud/issues/143
    touch elisp/"realgud/.nosearch"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/load-relative"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/loc-changes"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/test-simple"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "realgud")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
