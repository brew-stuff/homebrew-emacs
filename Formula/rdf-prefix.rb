require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RdfPrefix < EmacsFormula
  desc "Prefix lookup for RDF in Emacs"
  homepage "https://github.com/simenheg/rdf-prefix"
  url "https://github.com/simenheg/rdf-prefix/archive/1.6.tar.gz"
  sha256 "07cc63f933d871b4323da660849cd74ca50a2beff90d567a8b8ca2c7152eb904"
  head "https://github.com/simenheg/rdf-prefix.git"

  depends_on :emacs

  def install
    byte_compile "rdf-prefix.el"
    elisp.install "rdf-prefix.el", "rdf-prefix.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "rdf-prefix")
      (print (rdf-prefix-lookup "bf"))
    EOS
    assert_equal "\"http://bibframe.org/vocab/\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
