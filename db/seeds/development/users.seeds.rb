require 'factory_girl_rails'
puts 'Generate users for dev env...'

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 40.7143528,
      'longitude'    => -74.0059731,
      'address'      => 'New York, NY, USA',
      'state'        => 'New York',
      'state_code'   => 'NY',
      'country'      => 'United States',
      'country_code' => 'US'
    }
  ]
)

def self.create_user(attrs)
  user = FactoryGirl.build(:user, attrs)
  user.skip_confirmation!
  user.save!
end

def self.create_default_users
  create_user(
    email: 'finalepsilon@gmail.com',
    parent_email: 'cssndrx@gmail.com',
    password: 'testtest',
    role: :student
  )

  create_user(
    email: 'cssndrx@gmail.com',
    parent_email: 'cssndrx@gmail.com',
    password: 'testtest',
    role: :student
  )

  create_user(
    email: 'cssndrx+judge@gmail.com',
    parent_email: 'cssndrx@gmail.com',
    password: 'testtest',
    role: :judge,
  )

  create_user(
    email: 'cssndrx+mentor@gmail.com',
    parent_email: 'cssndrx@gmail.com',
    password: 'testtest',
    role: :mentor
  )

  create_user(
    email: 'cssndrx+coach@gmail.com',
    password: 'testtest',
    role: :coach,
    password_confirmation: 'testtest',
    birthday: Date.new(1989, 12, 1)
  )
end

create_default_users
FactoryGirl.create_list(:user, 10, is_registered: true)
FactoryGirl.create_list(:mentor, 100, :mentor)
