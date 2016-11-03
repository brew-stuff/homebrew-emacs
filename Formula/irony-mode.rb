require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class IronyMode < EmacsFormula
  desc "C/C++ minor mode for Emacs powered by libclang"
  homepage "https://github.com/Sarcasm/irony-mode"
  url "https://github.com/Sarcasm/irony-mode/archive/v0.2.1.tar.gz"
  sha256 "6e7fc33751a5529194e3a6e50b60174fa2a47803ae383a6027e38ec589777b2a"
  head "https://github.com/Sarcasm/irony-mode.git"

  bottle do
    cellar :any
    sha256 "9cf4b4fde2e75c465cd8a6a11b1ab5bf7db71b57eb3fdc478d500a011ec1ae0c" => :el_capitan
    sha256 "d497dd2b7adb5715370126b37c3746fd18803fc7da56f2efe7ccd7c078ca0102" => :yosemite
    sha256 "52b27bb9959e800108fb787e00fce8fafea36f5d9c142a03f75d8b988f264258" => :mavericks
  end

  depends_on :emacs => "23.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")
  depends_on "homebrew/emacs/yasnippet" => :optional

  depends_on "llvm"
  depends_on "cmake" => :build

  def install
    ENV.append "LDFLAGS", "-lclang"
    mkdir "build" do
      args = std_cmake_args
      args << "-DLIBCLANG_LIBRARY=#{Formula["llvm"].opt_lib}"
      args << "-DLIBCLANG_INCLUDE_DIR=#{Formula["llvm"].opt_include}"
      system "cmake", "../server", *args
      system "make", "install"
    end
    elisp.install "server"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  def caveats
    "Set the value of `irony-server-install-prefix' to #{opt_bin}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/cl-lib"].opt_elisp}")
      (load "irony")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
