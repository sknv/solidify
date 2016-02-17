module Solidify
  module Actions
    def get_matching_path(relative_path_wildcard)
      match = Dir.glob(relative_path_wildcard)
      raise "#{relative_path_wildcard.inspect} not found" if match.empty?
      match.first
    end

    def replace_in_file(relative_path, find, replace)
      content = IO.read(relative_path)
      unless content.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end
      IO.write(relative_path, content)
    end

    def delete_in_file(relative_path, delete)
      replace_in_file(relative_path, delete, '')
    end

    def insert_into_file(relative_path, insert, where)
      behavior, find = if where.key?(:after)
                         [:after, where[:after]]
                       else
                         [:before, where[:before]]
                       end
      replace = behavior == :after ? '\0' + insert : insert + '\0'
      find = Regexp.escape(find) unless find.is_a?(Regexp)
      replace_in_file(relative_path, /#{find}/, replace)
    end

    def append_to_file(relative_path, insert)
      insert_into_file(relative_path, insert, before: /\z/)
    end

    def prepend_to_file(relative_path, insert)
      insert_into_file(relative_path, insert, after: /\A/)
    end
  end
end
