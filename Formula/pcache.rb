require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Pcache < EmacsFormula
  desc "Persistent caching for Emacs"
  homepage "https://github.com/sigma/pcache"
  head "https://github.com/sigma/pcache.git"

  stable do
    url "https://github.com/sigma/pcache/archive/v0.3.1.tar.gz"
    sha256 "7fb9445e943cc9771f16e5853b9f131928a2cfdfc1a5f54454eb5ab415db018b"

    patch do
      url "https://github.com/sigma/pcache/commit/a3b8e77bc2ae36a1c87ceddbdfec59efe7eda668.diff"
      sha256 "3ca4317a1addabda7d8a81dd6be999f97808747aa073e97a35fefaa6cd002359"
    end

    patch do
      url "https://github.com/sigma/pcache/commit/04ec841cb8430fa022e2c24aa835c2eb6bb5533a.diff"
      sha256 "49df3934c0cfd95f7e033428c7f4ce5c094b0b65cee248300f0ff66b00fc9a7a"
    end
  end

  depends_on :emacs

  def install
    ert_run_tests "test/pcache-test.el"
    byte_compile "pcache.el"
    elisp.install "pcache.el", "pcache.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "pcache")
      (print (let ((repo (pcache-repository "plop")))
        (pcache-put repo 'home "brew")
        (pcache-get repo 'home)))
    EOS
    assert_equal "\"brew\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
