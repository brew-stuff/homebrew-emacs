#:  * `emacs` name...:
#:    Generate a formula for the homebrew-emacs tap for each given <name>.
#:    Open the last formula specified in your preferred editor.

raise FormulaUnspecifiedError if ARGV.empty?

def template(name)
  classname = name.split("-").collect(&:capitalize).join
  # An added '-emacs' suffix probably isn't part of the actual package name
  name = name.gsub(/-emacs/, "")
  <<~EOS
  require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

  class #{classname} < EmacsFormula
    desc ""
    homepage ""
    url ""
    sha256 ""
    head ""

    bottle :disable

    depends_on :emacs => "22.1"

    def install
      byte_compile "#{name}.el"
      elisp.install "#{name}.el", "#{name}.elc"
    end

    test do
      (testpath/"test.el").write <<~EOS
        (add-to-list 'load-path "\#{elisp}")
        (load "#{name}")
        (print (minibuffer-prompt-width))
      \EOS
      assert_equal "0", shell_output("emacs -Q --batch -l \#{testpath}/test.el").strip
    end
  end
  EOS
end

ARGV.each do |new|
  @formula_file = (HOMEBREW_LIBRARY/"Taps/dunn/homebrew-emacs/Formula/#{new}.rb")
  @formula_file.write template(new)
end

# open the last one created
exec_editor(@formula_file)
