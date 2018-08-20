FactoryBot.define do
  factory :micropost do
    content 'Lorem ipsum'
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/file/test_image.jpg'), 'image/jpeg')}
    association :user

    trait :orange do
      content 'I just ate an orange!'
      created_at 10.minutes.ago
    end

    trait :tau_manifest do
      content 'Check out the @tauday site by @mhartl: http://tauday.com'
      created_at 3.years.ago
    end

    trait :cat_video do
      content 'Sad cats are sad: http://youtu.be/PKffm2uI4dk'
      created_at 2.hours.ago
    end

    trait :most_recent do
      content 'Writing a short test'
      created_at Time.zone.now
    end

    trait :faker do
      sequence(:content) { Faker::Lorem.sentence(5)}
      created_at 42.days.ago
    end
  end
end
