require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DartMode < EmacsFormula
  desc "Major mode for editing Dart code"
  homepage "https://github.com/nex3/dart-mode"
  url "https://github.com/nex3/dart-mode.git",
      :tag => "0.15", :revision => "e6635b390235cf16a8081763768cf925ca2d9133"
  head "https://github.com/nex3/dart-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0f1b0d58ea3b76814817c8b0148ed65b433afa7a6dec464ba76b369c0f897bc" => :sierra
    sha256 "7d983840156f91a07300a2cef8667ad42211efd41017118c14e03bd5a5248345" => :el_capitan
    sha256 "010bab624b6501bca59135a9c06048a445866d5694bb1d3439f0a1fa9bb4ded7" => :yosemite
  end

  depends_on EmacsRequirement => "25.1"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/flycheck"

  def install
    byte_compile "dart-mode.el"
    elisp.install "dart-mode.el", "dart-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/flycheck"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (load "dart-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
