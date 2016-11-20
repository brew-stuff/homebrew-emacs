require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ClojureMode < EmacsFormula
  desc "Emacs major mode for Clojure"
  homepage "https://github.com/clojure-emacs/clojure-mode"
  head "https://github.com/clojure-emacs/clojure-mode.git"

  stable do
    url "https://github.com/clojure-emacs/clojure-mode/archive/5.6.0.tar.gz"
    sha256 "f55fab65811722ab7300d898085a0427207571f17282a4c402d015d00a5f30bb"

    # Remove for > 5.6.0
    # "bump `clojure-mode-version' to 5.6.0"
    patch do
      url "https://github.com/clojure-emacs/clojure-mode/pull/417.patch"
      sha256 "2fe0fc2c27366268bf8fb3c07ac5186ed4dd7b47a85baebf0d1ce55d5df07078"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c31ea64f3d57b66dfa94174225321b16eec5897975d630e525fb5cae9acfb289" => :sierra
    sha256 "c31ea64f3d57b66dfa94174225321b16eec5897975d630e525fb5cae9acfb289" => :el_capitan
    sha256 "c31ea64f3d57b66dfa94174225321b16eec5897975d630e525fb5cae9acfb289" => :yosemite
  end

  option "with-inf", "Build with the inferior REPL"

  depends_on :emacs => "24.3"
  depends_on "cask"

  resource "inf" do
    url "https://github.com/clojure-emacs/inf-clojure/archive/v1.4.0.tar.gz"
    sha256 "1fb5be82a970c285e0dd6253ba77236397908ca2cc7e49a6074633ed442b91ec"
  end

  def install
    if build.with? "inf"
      resource("inf").stage do
        byte_compile "inf-clojure.el"
        elisp.install "inf-clojure.el", "inf-clojure.elc"
      end
    end
    system "make", "test"
    system "make", "compile"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "clojure-mode")
      (print clojure-mode-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
