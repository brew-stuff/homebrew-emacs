require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CommonLispRequirement < Requirement
  fatal true
  default_formula "sbcl"

  # Based on ordering of available implementations from
  # https://common-lisp.net/project/slime/; except for SBCL which is
  # the default in the Makefile
  lisps = %w[sbcl lisp ccl clisp ecl abcl]

  satisfy :build_env => false do
    lisps.each do |bin|
      @lisp = which(bin) if @lisp.nil? && which(bin)
    end
    !@lisp.nil?
  end

  env do
    ENV.prepend_path "PATH", @lisp
    ENV["LISP"] = @lisp
  end

  def message
    s = <<-EOS.undent
      A Common Lisp implementation is required:
      - Steel Bank Common Lisp (SBCL)
      - CMU Common Lisp (cmucl)
      - Clozure Common Lisp (clozure-cl)
      - CLISP
      - Embedded Common Lisp (ECL)
      - Armed Bear Common Lisp (ABCL)
    EOS
    s + super
  end
end

class Slime < EmacsFormula
  desc "Emacs package for interactive programming in Lisp"
  homepage "https://common-lisp.net/project/slime/"
  url "https://github.com/slime/slime/archive/v2.20.tar.gz"
  sha256 "f385fcb9f4b4ffe4370b1f8ec72afaff7ebf7b17206ae061e449ee4b7cc1d420"
  head "https://github.com/slime/slime.git"

  depends_on :emacs => "23.4"
  depends_on CommonLispRequirement
  depends_on "texinfo" => :build

  def install
    # These are provided by Emacs 23.4+
    rm %w[lib/cl-lib.el lib/ert.el lib/ert-x.el]

    system "make", "LISP=#{ENV["LISP"]}"
    system "make", "compile-swank", "LISP=#{ENV["LISP"]}"
    system "make", "contrib-compile", "LISP=#{ENV["LISP"]}"

    cd "doc" do
      system "make", "slime.info", "html/index.html"
      info.install "slime.info"
      doc.install "html"
    end
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
