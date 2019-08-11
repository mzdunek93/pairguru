FactoryBot.define do
  factory :comment do
    user { nil }
    movie { nil }
    content { "MyText" }
  end
end
