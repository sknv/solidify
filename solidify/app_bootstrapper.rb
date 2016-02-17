require 'fileutils'
require 'yaml'
require_relative 'actions'

module Solidify
  class AppBootstrapper
    include Solidify::Actions

    DEFAULT_TEMPLATES_PATH = 'templates'.freeze

    DEFAULT_SOLIDUS_TEMPLATES_PATH = 'solidus'.freeze

    DEFAULT_COPY_DIR = 'copy'.freeze
    DEFAULT_BOOT_FILE = 'boot.yml'.freeze

    def initialize(app_path)
      @app_path = app_path
    end

    def bootstrap
      puts "\n", 'Bootstrapping your new application...'
      Dir.chdir(@app_path) do
        bootstrap_solidus_templates
      end
    end

    private

    def bootstrap_solidus_templates
      solidus_templates_path = File.join(__dir__, DEFAULT_TEMPLATES_PATH,
                                         DEFAULT_SOLIDUS_TEMPLATES_PATH)

      bootstrap_templates solidus_templates_path
    end

    def bootstrap_templates(templates_path)
      bootstrap_boot_commands templates_path
      bootstrap_copy_dirs templates_path
    end

    def bootstrap_boot_commands(templates_path)
      boot_file = File.join(templates_path, DEFAULT_BOOT_FILE)
      return unless File.exist? boot_file

      yaml = YAML.load_file boot_file
      yaml['boot'].each do |boot_command|
        if boot_command.key? 'snippets'
          bootstrap_snippets boot_command['snippets']
        elsif boot_command.key? 'tasks'
          bootstrap_tasks boot_command['tasks']
        end
      end
    end

    def bootstrap_snippets(snippets)
      snippets.each do |snippet|
        process_insert_snippet snippet if snippet.key? 'insert'
        process_replace_snippet snippet if snippet.key? 'replace'
        process_delete_snippet snippet if snippet.key? 'delete'
      end
    end

    def bootstrap_tasks(tasks)
      tasks.each do |task|
        process_task task
      end
    end

    def bootstrap_copy_dirs(templates_path)
      dir_to_copy = File.join(templates_path, DEFAULT_COPY_DIR)
      return unless Dir.exist? dir_to_copy

      process_copy_dir(File.join(dir_to_copy, '.'), '.')
    end

    def process_insert_snippet(snippet)
      file_path = get_matching_path snippet['file']
      snippet['insert'].each do |insert|
        case insert['where']
        when 'begin'
          prepend_to_file(file_path, insert['code'])
        when 'end'
          append_to_file(file_path, insert['code'])
        else
          insert_into_file(file_path, insert['code'],
                           insert['where'].to_sym => insert['selector'])
        end
      end
    end

    def process_replace_snippet(snippet)
      file_path = get_matching_path snippet['file']
      snippet['replace'].each do |replace|
        replace_in_file(file_path, replace['code'], replace['with'])
      end
    end

    def process_delete_snippet(snippet)
      file_path = get_matching_path snippet['file']
      snippet['delete'].each do |delete|
        delete_in_file(file_path, delete['code'])
      end
    end

    def process_task(task)
      system(task['command'])
    end

    def process_copy_dir(dir_from, dir_to)
      FileUtils.cp_r(dir_from, dir_to)
    end
  end
end
