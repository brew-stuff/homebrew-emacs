require File.expand_path("../emacs", __FILE__)

class EmacsFormula < Formula
  def initialize(*)
    super
  end

  def byte_compile(*args)
    emacs_args = %W[emacs --batch -Q --directory #{buildpath}]

    if deps.any?
      recursive_dependencies do |_, dep|
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
      pid = fork { exec(emacs_args.join(" ") + " #{file}") }
      Process.wait pid
      # is this necessary?
      $stdout.flush
    end
  end
end
