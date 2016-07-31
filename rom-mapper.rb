require 'ostruct'
require 'rom-mapper'

class BigDecimal
  def inspect
    format("#<BigDecimal:%x %s>", object_id, to_s('F'))
  end
end

class Gateway
  def get_authors
    [
      {
        'name' => 'John Doe',

        'books' => [
          {
            'title' => 'First book',
            'price' => '15.99',
          },
          {
            'title' => 'Second book',
            'price' => '18.99',
          },
        ]
      }
    ]
  end
end

class Author < OpenStruct
  class << self
    def all
      authors
    end

    def find_by_name name
      authors.detect { |author| author.name == name }
    end

    private

    def authors
      Repository::Authors.all
    end
  end
end

class Book < OpenStruct
end

class Preprocessor < ROM::Mapper
  symbolize_keys true

  model Author

  attribute :name

  embedded :books, type: :array do
    model Book

    attribute :title
    attribute :price, type: :decimal
  end
end

module Repository
  class Authors
    class << self
      def all
        @@authors ||= preprocessor.call raw_authors
      end

      private

      def preprocessor
        Preprocessor.build
      end

      def raw_authors
        @@raw_authors ||= gateway.get_authors
      end

      def gateway
        @@gateway ||= Gateway.new
      end
    end
  end
end

authors = Author.all

p authors
p authors.first.name

p Author.find_by_name('John Doe').name
