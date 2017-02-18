require "language/node"
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Tern < EmacsFormula
  desc "JavaScript code analyzer"
  homepage "http://ternjs.net/"
  url "https://github.com/ternjs/tern/archive/0.21.0.tar.gz"
  sha256 "5a232295630b681a25a20616caa7fcece22ed816793205ea73bd99984483ecdf"
  head "https://github.com/ternjs/tern.git"

  depends_on "node"
  depends_on :emacs => "24"
  depends_on "dunn/emacs/auto-complete" => :optional
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    lisps = %w[emacs/tern.el]
    lisps << "emacs/tern-auto-complete.el" if build.with? "auto-complete"
    byte_compile lisps
    elisp.install Dir["emacs/*"]

    doc.install Dir["doc/*"]
    libexec.install Dir["*"]
    bin.install_symlink (libexec/"bin/tern")
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "tern")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip

    pid = fork do
      exec bin/"tern", "--port", "4444"
    end

    sleep 2

    system "curl", "localhost:4444"

    Process.kill "TERM", pid
    Process.wait pid
  end
end
