require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class E2ansi < EmacsFormula
  desc "Syntax highlighting for less using Emacs"
  homepage "https://github.com/Lindydancer/e2ansi"
  head "https://github.com/Lindydancer/e2ansi.git"

  option "with-pipes", "Allow piping input into less"

  depends_on :emacs
  depends_on "homebrew/dupes/less" if build.with? "pipes"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/e2ansi").install Dir["*.el"], Dir["*.elc"]

    inreplace %w[bin/e2ansi-cat bin/e2ansi-info],
              "../", "#{opt_share}/emacs/site-lisp/e2ansi/"
    bin.install Dir["bin/*"]
    doc.install "README.md", Dir["doc/*"]
  end

  def caveats; <<-EOS.undent
    Add the following to your .bashrc or .zshrc:

    export "LESSOPEN=|emacs --batch -l #{HOMEBREW_PREFIX}/bin/e2ansi-cat %s"
    export "LESS=-R"
    export "MORE=-R"
  EOS
  end

  test do
    ENV["LESSOPEN"] = "|emacs --batch -l #{HOMEBREW_PREFIX}/bin/e2ansi-cat %s"
    (testpath/"test.rb").write "require \"pathname\""
    IO.popen("less test.rb") do |pipe|
      expected = <<-EOS.undent
        \e[38;5;60mrequire\e[0m \e[38;5;89m\"pathname\"\e[0m
      EOS
      assert_equal expected.chomp, pipe.gets
    end
  end
end
