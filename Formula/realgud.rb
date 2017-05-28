require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Realgud < EmacsFormula
  desc "Emacs front-end for interacting with external debuggers"
  homepage "https://github.com/realgud/realgud"
  url "https://elpa.gnu.org/packages/realgud-1.4.4.tar"
  sha256 "ec58be91c9f1fb9ebde195f948603efdec01d4735095220304e9c634469d88d9"

  bottle :disable

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/load-relative"
  depends_on "dunn/emacs/test-simple"
  depends_on "dunn/emacs/loc-changes"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  option "without-byebug", "Don't include support for byebug (Ruby)"
  option "without-pry", "Don't include support for pry (Ruby)"

  resource "byebug" do
    url "https://github.com/realgud/realgud-byebug.git",
        :revision => "cb75d6bd9abbe04afa4c74a7ce9c66852814e0c3"
  end

  resource "pry" do
    url "https://github.com/realgud/realgud-pry.git",
        :revision => "9b3834048fcbc16827c55af38f8cfef0cf6533da"
  end

  def install
    %w[byebug pry].each do |plugin|
      next if build.without? plugin

      resource(plugin).stage do
        byte_compile "realgud-#{plugin}.el", Dir["#{plugin}/*.el"]

        elisp.install "realgud-#{plugin}.el", "realgud-#{plugin}.elc"
        (elisp/plugin).install Dir["#{plugin}/*.el"], Dir["#{plugin}/*.elc"]
      end
    end

    system "./autogen.sh", "--disable-silent-rules",
                           "--mandir=#{man}",
                           "--prefix=#{prefix}",
                           "--with-lispdir=#{elisp}"
    system "make"
    system "make", "check"
    system "make", "install"

    # keep lang and common libs from shadowing system; see
    # https://github.com/realgud/realgud/issues/143
    touch elisp/"realgud/.nosearch"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["dunn/emacs/load-relative"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/loc-changes"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/test-simple"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "realgud")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
