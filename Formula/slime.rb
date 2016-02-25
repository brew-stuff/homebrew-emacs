require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CommonLispRequirement < Requirement
  fatal true
  default_formula "sbcl"

  # Based on ordering of available implementations from
  # https://common-lisp.net/project/slime/; except for SBCL which is
  # the default in the Makefile
  lisps = {
    :sbcl => "sbcl",
    :ccl => "clozure-cl",
    :clisp => "clisp",
    :ecl => "ecl",
    :abcl => "abcl",
  }

  satisfy :build_env => false do
    lisps.each do |bin, f|
      @lisp = bin if @lisp.nil? && Formula[f].installed?
    end
    !@lisp.nil?
  end

  env do
    ENV.prepend_path "PATH", Formula[lisps[@lisp]].opt_bin
    ENV["LISP"] = @lisp.to_s
  end

  def message
    s = <<-EOS.undent
      A Common Lisp implementation is required:
      - sbcl
      - homebrew/binary/cmucl
      - clozure-cl
      - clisp
      - ecl
      - abcl
    EOS
    s + super
  end
end

class Slime < EmacsFormula
  desc "Emacs package for interactive programming in Lisp"
  homepage "http://common-lisp.net/project/slime/"
  url "https://github.com/slime/slime/archive/v2.17.tar.gz"
  sha256 "e4492b0bafed6d0a255c3c4b919448ee8d67ee114b945ceced78fe242853686c"
  head "https://github.com/slime/slime.git"

  depends_on :emacs => "23.4"
  depends_on CommonLispRequirement

  def install
    system "make", "LISP=#{ENV["LISP"]}"
    system "make", "compile-swank", "LISP=#{ENV["LISP"]}"
    system "make", "contrib-compile", "LISP=#{ENV["LISP"]}"
    elisp.install Dir["*.lisp"], Dir["*.el"], Dir["*.elc"],
                  "lib", "swank", "contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "slime-autoloads")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
