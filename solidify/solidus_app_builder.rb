require_relative 'app_bootstrapper'

module Solidify
  class SolidusAppBuilder
    DEFAULT_APP_NAME = 'SolidusApp'.freeze

    def initialize(app_name)
      @app_name = app_name_or_default app_name
    end

    def build
      bootstrap_app if create_app
    end

    private

    def app_name_or_default(name)
      name = DEFAULT_APP_NAME if name.empty?
      name
    end

    def create_app
      puts "Creating #{@app_name}..."
      system("rails new #{@app_name} --database=postgresql")
    end

    def bootstrap_app
      bootstrapper = Solidify::AppBootstrapper.new(@app_name)
      bootstrapper.bootstrap
    end
  end
end
