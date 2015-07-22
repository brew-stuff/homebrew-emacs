require File.expand_path("../emacs", __FILE__)
require File.expand_path("../emacs_requirement", __FILE__)

class EmacsFormula < Formula
  def initialize(*)
    super
  end

  def byte_compile(*files)
    emacs_args = %W[--batch -Q --directory #{buildpath}]

    if deps.any?
      recursive_dependencies do |_, dep|
        Dir["#{dep.to_formula.opt_share}/emacs/site-lisp/**/*"].each do |x|
          x = Pathname.new(x)
          emacs_args << "--directory" << "#{x}" if x.directory?
        end
      end
    end
    emacs_args << "-f" << "batch-byte-compile"

    lisps = files.flatten
    lisps.each do |file|
      ohai "Byte compiling #{file}"
      args = Array.new(emacs_args)
      args << file
      pid = fork { exec("emacs", *args) }
      Process.wait pid
      # is this necessary?
      $stdout.flush
      unless $?.success?
        require "cmd/--env"

        env = ENV.to_hash
        puts # line between emacs output and env dump
        onoe "Byte compilation failed"
        puts "emacs #{args.join(" ")}"
        puts
        Homebrew.dump_build_env(env)
        raise BuildError.new(self, "emacs", args, env)
      end
    end
  end
end
