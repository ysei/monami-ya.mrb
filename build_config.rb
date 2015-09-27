MRuby::Build.new do |conf|
  # load specific toolchain settings

  # Gets set by the VS command prompts.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  enable_debug

  # Use mrbgems
  # conf.gem 'examples/mrbgems/ruby_extension_example'
  # conf.gem 'examples/mrbgems/c_extension_example' do |g|
  #   g.cc.flags << '-g' # append cflags in this gem
  # end
  # conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
  # conf.gem :github => 'masuidrive/mrbgems-example', :checksum_hash => '76518e8aecd131d047378448ac8055fa29d974a9'
  # conf.gem :git => 'git@github.com:masuidrive/mrbgems-example.git', :branch => 'master', :options => '-v'

conf.bins = %w(mrbc mruby )

  # conf.gem :github => 'ysei/mruby-thread', :branch => 'crimsonwoods_-_experimental_thread_support_-_normal'
    conf.gem :github => 'ysei/mruby-thread', :branch => 'master_-_merge_-_postmodern_-_master_-_pthread_kill_-_8a67d500'
  # conf.gem :github => 'crimsonwoods/mruby-thread', :branch => 'experimental_thread_support'
  # conf.gem :github => 'mattn/mruby-thread', :branch => 'master'
  # conf.gem :github => 'postmodern/mruby-thread', :branch => 'master'
  # conf.gem :github => 'matsumoto-r/mruby-thread', :branch => 'master'
  # conf.gem :github => 'hatoishi/mruby-thread', :branch => 'master'
  # conf.gem :github => 'miura1729/mruby-meta-circular', :branch => 'master'
    conf.gem :github => 'ysei/mruby-meta-circular-heiretu', :branch => 'heiretu'
  # conf.gem :github => 'charlescui/mruby-cache', :branch => 'master'
  # conf.gem :github => 'matsumoto-r/mruby-userdata', :branch => 'master'
    conf.gem :github => 'iij/mruby-env', :branch => 'master'
    conf.gem :github => 'mattn/mruby-json', :branch => 'master'
  # conf.gem :github => 'suzukaze/mruby-msgpack', :branch => 'master'
  # conf.gem :github => 'take-cheeze/mruby-msgpack', :branch => 'master'
  # conf.gem :github => 'schmurfy/mruby-msgpack', :branch => 'master'
  # conf.gem :github => 'matsumoto-r/mruby-redis', :branch => 'master'
  # conf.gem :github => 'matsumoto-r/mruby-vedis', :branch => 'master'
  # conf.gem :github => 'iij/mruby-io'
    conf.gem :github => 'ysei/mruby-io', :branch => 'master_-_mattn_-_global_variables'
  # conf.gem :github => 'iij/mruby-dir'
  # conf.gem :github => 'iij/mruby-tempfile'
  # conf.gem :github => 'iij/mruby-require'
    conf.gem :github => 'iij/mruby-process'
  # conf.gem :github => 'matsumoto-r/mruby-sleep', :branch => 'master'
  # conf.gem :github => 'bamchoh/mruby-sleep', :branch => 'support-float-value'
  # conf.gem :github => 'wasabiz/mruby-partcont'
  # mruby-eval
  #memcached / Couchbase / MongoDB


  # include the default GEMs
  conf.gembox 'default'

  # C compiler settings
  # conf.cc do |cc|
  #   cc.command = ENV['CC'] || 'gcc'
  #   cc.flags = [ENV['CFLAGS'] || %w()]
  #   cc.include_paths = ["#{root}/include"]
  #   cc.defines = %w(DISABLE_GEMS)
  #   cc.option_include_path = '-I%s'
  #   cc.option_define = '-D%s'
  #   cc.compile_options = "%{flags} -MMD -o %{outfile} -c %{infile}"
  # end

  # mrbc settings
  # conf.mrbc do |mrbc|
  #   mrbc.compile_options = "-g -B%{funcname} -o-" # The -g option is required for line numbers
  # end

  # Linker settings
  # conf.linker do |linker|
  #   linker.command = ENV['LD'] || 'gcc'
  #   linker.flags = [ENV['LDFLAGS'] || []]
  #   linker.flags_before_libraries = []
  #   linker.libraries = %w()
  #   linker.flags_after_libraries = []
  #   linker.library_paths = []
  #   linker.option_library = '-l%s'
  #   linker.option_library_path = '-L%s'
  #   linker.link_options = "%{flags} -o %{outfile} %{objs} %{libs}"
  # end

  # Archiver settings
  # conf.archiver do |archiver|
  #   archiver.command = ENV['AR'] || 'ar'
  #   archiver.archive_options = 'rs %{outfile} %{objs}'
  # end

  # Parser generator settings
  # conf.yacc do |yacc|
  #   yacc.command = ENV['YACC'] || 'bison'
  #   yacc.compile_options = '-o %{outfile} %{infile}'
  # end

  # gperf settings
  # conf.gperf do |gperf|
  #   gperf.command = 'gperf'
  #   gperf.compile_options = '-L ANSI-C -C -p -j1 -i 1 -g -o -t -N mrb_reserved_word -k"1,3,$" %{infile} > %{outfile}'
  # end

  # file extensions
  # conf.exts do |exts|
  #   exts.object = '.o'
  #   exts.executable = '' # '.exe' if Windows
  #   exts.library = '.a'
  # end

  # file separetor
  # conf.file_separator = '/'

  # bintest
  # conf.enable_bintest
end

MRuby::Build.new('host-debug') do |conf|
  # load specific toolchain settings

  # Gets set by the VS command prompts.
  if ENV['VisualStudioVersion'] || ENV['VSINSTALLDIR']
    toolchain :visualcpp
  else
    toolchain :gcc
  end

  enable_debug

  # include the default GEMs
  conf.gembox 'default'

  # C compiler settings
  conf.cc.defines = %w(ENABLE_DEBUG)

  # Generate mruby debugger command (require mruby-eval)
  conf.gem :core => "mruby-bin-debugger"

  # bintest
  # conf.enable_bintest
end

# Define cross build settings
# MRuby::CrossBuild.new('32bit') do |conf|
#   toolchain :gcc
#
#   conf.cc.flags << "-m32"
#   conf.linker.flags << "-m32"
#
#   conf.build_mrbtest_lib_only
#
#   conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
#
#   conf.test_runner.command = 'env'
#
# end
