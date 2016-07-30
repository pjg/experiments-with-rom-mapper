require 'rom-mapper'

class BigDecimal
  def inspect
    format("#<BigDecimal:%x %s>", object_id, to_s('F'))
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

input = [
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


preprocessor = Preprocessor.build
output = preprocessor.call(input)

p output

p output.first.name
