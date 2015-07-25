require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LocChanges < EmacsFormula
  desc "Emacs package to track buffer positions across changes"
  homepage "https://github.com/rocky/emacs-loc-changes"
  url "http://elpa.gnu.org/packages/loc-changes-1.2.el"
  sha256 "231bae732e7417b03c54b1e6094c9f7b596393aad628b472705e698537b20ef5"

  head do
    url "https://github.com/rocky/emacs-loc-changes.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on :emacs => "24.1"

  def install
    if build.stable?
      mv "loc-changes-#{version}.el", "loc-changes.el"
      byte_compile "loc-changes.el"
    else
      system "./autogen.sh"
      cd "test" do
        system "make", "check-elget"
      end
      system "make"
      doc.install "README.md"
    end
    (share/"emacs/site-lisp/loc-changes").install "loc-changes.el",
                                                  "loc-changes.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'loc-changes)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "loc-changes")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end
