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

class Preprocessor < ROM::Mapper
  symbolize_keys true

  model name: 'Author'

  attribute :name

  embedded :books, type: :array do
    model name: 'Book'

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

      def find_by_name name
        all.detect { |author| author.name == name }
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

authors = Repository::Authors.all

p authors
p authors.first.name

p Repository::Authors.find_by_name('John Doe').name
