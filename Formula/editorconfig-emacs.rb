require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EditorconfigEmacs < EmacsFormula
  desc "EditorConfig plugin for emacs"
  homepage "http://editorconfig.org/"
  url "https://github.com/editorconfig/editorconfig-emacs.git",
      :tag => "v0.7.0",
      :revision => "765797d42784f15d207b5a4bfddce780eae2fbb3"
  head "https://github.com/editorconfig/editorconfig-emacs.git"

  option "without-editorconfig", "Use the Emacs Lisp implementation of EditorConfig Core"

  depends_on :emacs => "24.1"
  depends_on "cmake" => :build
  depends_on "editorconfig" => :recommended
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    ENV["LC_ALL"] = "en_US.UTF-8"
    system "make"
    system "make", "test", "PROJECT_ROOT_DIR=#{buildpath}"
    elisp.install Dir["*.el"], Dir["*.elc"]

    libexec.install "bin/editorconfig-el"
    (bin/"editorconfig-el").write_env_script(libexec/"editorconfig-el",
                                             :EDITORCONFIG_CORE_LIBRARY_PATH => opt_elisp)
  end

  def caveats
    if build.without? "editorconfig"
      <<-EOS.undent
      Set the variable `editorconfig-exec-path' to
        #{HOMEBREW_PREFIX}/bin/editorconfig-el
      EOS
    end
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
