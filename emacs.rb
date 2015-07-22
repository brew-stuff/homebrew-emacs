require "formula"

module Emacs
  def self.version
    Utils.popen_read("emacs", "--batch", "--eval", "(princ emacs-version)").to_f
  end

  def self.compile(*args)
    emacs_args = %w[emacs --batch -Q]

    # FIXME: lol
    formula_path = caller.first.gsub(/:.*/, "")
    f = Formulary.factory(formula_path)
    if f.deps.any?
      f.recursive_dependencies do |_, dep|
        Dir["#{dep.to_formula.opt_share}/emacs/site-lisp/**/*"].each do |x|
          x = Pathname.new(x)
          emacs_args << "--directory #{x}" if x.directory?
        end
      end
    end
    emacs_args << %w[-f batch-byte-compile]

    lisps = args.flatten
    lisps.each do |file|
      ohai "Byte compiling #{file}"
      emacs_args << file
      # TODO: why doesn't `system "emacs", *emacs_args` work here
      system emacs_args.join(" ")
    end
  end
end
