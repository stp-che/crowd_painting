FactoryBot.define do
  factory :pixel_change do
    painting
    user
    row { 0 }
    col { 0 }
    color { "\x00\x00\x00" }
  end
end
