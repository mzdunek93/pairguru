class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
    stack = []
    mapping = { ')' => '(', ']' => '[', '}' => '{' }
    empty = true
    record.title.split('').each do |letter|
      if mapping.values.include? letter
        stack << letter
        empty = true
      elsif mapping.keys.include? letter
        if stack.last != mapping[letter] || empty
          record.errors[:title] << (options[:message] || "brackets are incorrect")
          return
        end
        stack.pop
      else
        empty = false
      end
    end
    if stack.size > 0
      record.errors[:title] << (options[:message] || "brackets are incorrect")
    end
  end
end