require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EditorconfigEmacs < EmacsFormula
  desc "EditorConfig plugin for emacs"
  homepage "http://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-emacs.git",
      :tag => "v0.6.1",
      :revision => "3d1e4797ea3f5a1bb6d0ec296f04ce05e6e368b4"
  head "https://github.com/editorconfig/editorconfig-emacs.git"
  revision 1

  option "without-editorconfig", "Use the Emacs Lisp implementation of EditorConfig Core"

  depends_on :emacs => "24.1"
  depends_on "cmake" => :build
  depends_on "editorconfig" => :recommended
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "make"
    system "make", "test", "PROJECT_ROOT_DIR=#{buildpath}"
    bin.install "bin/editorconfig-el"
    elisp.install "editorconfig.el", "editorconfig.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "editorconfig")
      (editorconfig-mode 1)
      (editorconfig-set-indentation "space")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
