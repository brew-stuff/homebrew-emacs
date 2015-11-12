require File.expand_path("../emacs", __FILE__)

class EmacsFormula < Formula
  def initialize(*)
    super
  end

  def lib_load_paths
    dir_paths = []
    if deps.any?
      recursive_dependencies do |_, dep|
        Dir["#{dep.to_formula.opt_share}/emacs/site-lisp/**/*"].each do |x|
          x = Pathname.new(x)
          dir_paths << "--directory" << "#{x}" if x.directory?
        end
      end
    end
    dir_paths
  end

  ### This is not well-tested and should be used with caution
  def ert_run_tests(*files)
    test_args = %W[--batch -Q]
    # allow running in resource blocks
    test_args << "--directory" << "#{Pathname.pwd}"

    # Detect if we're calling it from the test block or the install
    # block
    if buildpath.nil?
      dirs = Dir["#{share}/emacs/site-lisp/**/*"]
    else
      dirs = Dir["#{buildpath}/**/*"]
      test_args << "--directory" << "#{buildpath}"
    end
    dirs.each do |x|
      x = Pathname.new(x)
      test_args << "--directory" << "#{x}" if x.directory?
    end

    # this means flattening later on
    test_args << lib_load_paths if deps.any?

    test_args << "-l" << "ert"
    files.flatten.each do |f|
      test_args << "-l" << f
    end
    # I don't actually know why it needs to be this and not just
    # `-f ert-run-tests-batch-and-exit`
    test_args << "--eval" << "(ert-run-tests-batch-and-exit '(not (tag interactive)))"

    ohai "Running tests"
    pid = fork { exec("emacs", *test_args.flatten) }
    Process.wait pid
    # is this necessary?
    $stdout.flush
    unless $?.success?
      odie "Tests failed"
      puts "emacs #{test_args.join(" ")}"
    end
  end

  ### Slightly better tested than ert_run_tests
  def byte_compile(*files)
    emacs_args = %W[ --batch -Q --directory #{Pathname.pwd}]

    Dir["**/*"].each do |x|
      x = Pathname.new(x)
      emacs_args << "--directory" << "#{x}" if x.directory?
    end

    # lib_load_paths is an array so we need to flatten later on
    emacs_args << lib_load_paths if deps.any?

    emacs_args << "-f" << "batch-byte-compile"

    lisps = files.flatten
    lisps.each do |file|
      ohai "Byte compiling #{file}"

      args = Array.new(emacs_args.flatten)
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
        raise BuildError.new(self, "emacs", args, env)
      end
    end
  end
end
