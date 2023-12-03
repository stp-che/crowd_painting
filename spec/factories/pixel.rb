FactoryBot.define do
  factory :pixel do
    painting
    row { 0 }
    col { 0 }
    color { "\x00\x00\x00" }
  end
end
