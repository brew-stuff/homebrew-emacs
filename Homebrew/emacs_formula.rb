require File.expand_path("../emacs", __FILE__)

class EmacsFormula < Formula
  def initialize(*)
    super
  end

  def lib_load_paths
    return [] unless deps.any?

    recursive_elisp_deps = Dependency.expand(self) do |_dependent, dep|
      begin
        if !dep.installed?
          Dependency.prune
        elsif !dep.to_formula.opt_elisp.exist?
          Dependency.prune
        elsif (dep.optional? || dep.recommended?) && build.without?(dep)
          Dependency.prune
        else
          dep
        end
      rescue TapFormulaUnavailableError
        Dependency.prune
      end
    end

    dir_paths = []
    recursive_elisp_deps.each do |dep|
      lispdir = dep.to_formula.opt_elisp
      dir_paths << "--directory" << lispdir

      Dir["#{lispdir}/**/*"].each do |x|
        x = Pathname.new(x)
        dir_paths << "--directory" << x if x.directory?
      end
    end
    dir_paths
  end

  ### This is not well-tested and should be used with caution
  def ert_run_tests(*files)
    test_args = %W[--batch -Q]
    # allow running in resource blocks
    test_args << "--directory" << Pathname.pwd

    # Detect if we're calling it from the test block or the install
    # block
    if buildpath.nil?
      test_args << "--directory" << elisp
      dirs = Dir["#{elisp}/**/*"]
    else
      dirs = Dir["#{buildpath}/**/*"]
      test_args << "--directory" << buildpath
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
    emacs_args = %W[ --batch -Q ]

    # Pathname.pwd and buildpath differ when we're compiling resources
    load_dirs = [buildpath, Pathname.pwd]

    Dir["#{buildpath}/**"].each do |x|
      x = Pathname.new(x)
      load_dirs << x if x.directory?
    end

    Dir["#{Pathname.pwd}/**"].each do |x|
      x = Pathname.new(x)
      load_dirs << x if x.directory?
    end

    emacs_args += load_dirs.uniq.map { |d| %W[--directory #{d}] }.flatten
    emacs_args += lib_load_paths if deps.any?
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
        env = ENV.to_hash
        puts # line between emacs output and env dump
        onoe "Byte compilation failed"
        puts "emacs #{args.join(" ")}"
        raise BuildError.new(self, "emacs", args, env)
      end
    end
  end
end
