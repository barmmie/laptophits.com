require 'rails_helper'

RSpec.feature "Specification filtering", :type => :feature do
  scenario "User filters laptops by time" do
    create(:product, title: 'weekly laptop').comments << create(:comment, created_utc: Time.now - 2.days)
    create(:product, title: 'monthly laptop').comments << create(:comment, created_utc: Time.now - 20.days)
    create(:product, title: 'yearly laptop').comments << create(:comment, created_utc: Time.now - 200.days)

    visit "/products"

    click_link "Past week" 
    expect(page).to have_text("weekly laptop")
    expect(page).to_not have_text("monthly laptop")
    expect(page).to_not have_text("yearly laptop")

    click_link "Past month"
    expect(page).to have_text("weekly laptop")
    expect(page).to have_text("monthly laptop")
    expect(page).to_not have_text("yearly laptop")

    click_link "Past year"
    expect(page).to have_text("weekly laptop")
    expect(page).to have_text("monthly laptop")
    expect(page).to have_text("yearly laptop")
  end

  scenario 'User filters laptops by price' do
    create(:product, title: '$250 laptop', price_in_cents: 25000).comments << create(:comment)
    create(:product, title: '$500 laptop', price_in_cents: 50000).comments << create(:comment)
    create(:product, title: '$799 laptop', price_in_cents: 79900).comments << create(:comment)
    create(:product, title: '$1000 laptop', price_in_cents: 100000).comments << create(:comment)
    create(:product, title: '$100000 laptop', price_in_cents: 10000000).comments << create(:comment)

    visit "/products"

    click_link "$0 - $400"
    expect(page).to have_text("$250 laptop")
    expect(page).to_not have_text("$500 laptop")
    expect(page).to_not have_text("799 laptop")

    click_link "$400 - $600"
    expect(page).to_not have_text("$250 laptop")
    expect(page).to have_text("$500 laptop")
    expect(page).to_not have_text("799 laptop")

    click_link "$1500+"
    expect(page).to_not have_text("$250 laptop")
    expect(page).to_not have_text("799 laptop")
    expect(page).to have_text("$100000 laptop")
  end

  scenario 'User filters laptops by brand' do
    create(:product, title: 'Asus laptop', brand: 'Asus').comments << create(:comment)
    create(:product, title: 'Dell laptop', brand: 'Dell').comments << create(:comment)

    visit "/products"

    click_link "Asus ("
    expect(page).to have_text("Asus laptop")
    expect(page).to_not have_text("Dell laptop")
  end

  scenario 'User filters laptops by display size' do
    create(:product, title: '15inches laptop', display_size: 15.3).comments << create(:comment)
    create(:product, title: '10inches laptop', display_size: 10.0).comments << create(:comment)

    visit "/products"

    click_link "15\""
    expect(page).to have_text("15inches laptop")
    expect(page).to_not have_text("10inches laptop")

    click_link "10\""
    expect(page).to_not have_text("15inches laptop")
    expect(page).to have_text("10inches laptop")
  end

  scenario 'User filters laptops by display resolution' do
    create(:product, title: '1920x1080 laptop', display_resolution: '1920x1080').comments << create(:comment)
    create(:product, title: '1366x768 laptop', display_resolution: '1366x768').comments << create(:comment)

    visit "/products"

    click_link "1920x1080 ("
    expect(page).to have_text("1920x1080 laptop")
    expect(page).to_not have_text("1366x768 laptop")
  end

  scenario 'User filters laptops by ram size' do
    create(:product, title: '8GB laptop', ram_size: 8).comments << create(:comment)
    create(:product, title: '16GB laptop', ram_size: 16).comments << create(:comment)

    visit "/products"

    click_link "8 GB"
    expect(page).to have_text("8GB laptop")
    expect(page).to_not have_text("16GB laptop")
  end

  scenario 'User filters laptops by operating system' do
    create(:product, title: 'Chrome OS laptop', operating_system: 'Chrome OS').comments << create(:comment)
    create(:product, title: 'Windows 10 laptop', operating_system: 'Windows 10').comments << create(:comment)

    visit "/products"

    click_link "Chrome OS ("
    expect(page).to have_text("Chrome OS laptop")
    expect(page).to_not have_text("Windows 10 laptop")
  end

  scenario 'User filters laptops by hdd type' do
    create(:product, title: 'HDD laptop', hdd_type: 'HDD').comments << create(:comment)
    create(:product, title: 'SSD laptop', hdd_type: 'SSD').comments << create(:comment)

    visit "/products"

    click_link "HDD ("
    expect(page).to have_text("HDD laptop")
    expect(page).to_not have_text("SSD laptop")
  end

  scenario 'User filters laptops by hdd size' do
    create(:product, title: '100GB laptop', hdd_size: 100).comments << create(:comment)
    create(:product, title: '600GB laptop', hdd_size: 600).comments << create(:comment)
    create(:product, title: '2TB laptop', hdd_size: 2048).comments << create(:comment)

    visit "/products"

    click_link "127GB & Under"
    expect(page).to have_text("100GB laptop")
    expect(page).to_not have_text("600GB laptop")
    expect(page).to_not have_text("2TB laptop")

    click_link "0.5TB to 0.99TB"
    expect(page).to_not have_text("100GB laptop")
    expect(page).to have_text("600GB laptop")
    expect(page).to_not have_text("2TB laptop")

    click_link "1.5TB & Above"
    expect(page).to_not have_text("100GB laptop")
    expect(page).to_not have_text("600GB laptop")
    expect(page).to have_text("2TB laptop")
  end

  scenario 'User filters laptops by processor' do
    create(:product, title: 'Intel Atom laptop', processor: 'Intel Atom').comments << create(:comment)
    create(:product, title: 'AMD E laptop', processor: 'AMD E').comments << create(:comment)

    visit "/products"

    click_link "Intel Atom ("
    expect(page).to have_text("Intel Atom laptop")
    expect(page).to_not have_text("AMD E laptop")
  end

  scenario 'User filters laptops by multiple attributes' do
    create(:product, title: '15inch Windows Laptop', display_size: 15.5, operating_system: 'Windows').comments << create(:comment)
    create(:product, title: '14inch Chrome OS Laptop', display_size: 14.4, operating_system: 'Chrome OS').comments << create(:comment)
    create(:product, title: '14inch Windows Laptop', display_size: 14.4, operating_system: 'Windows').comments << create(:comment)

    visit "/products"

    click_link "14\""
    click_link "Windows ("
    expect(page).to have_text("14inch Windows Laptop")
    expect(page).to_not have_text("14inch Chrome OS Laptop")
    expect(page).to_not have_text("15inch Windows Laptop")
  end

  scenario 'User filters by time and specification attribute' do
    create(:product, title: 'weekly Asus laptop', brand: 'Asus').comments << create(:comment, created_utc: Time.now - 2.days)
    create(:product, title: 'weekly Dell laptop', brand: 'Dell').comments << create(:comment, created_utc: Time.now - 2.days)
    create(:product, title: 'monthly laptop', brand: 'Asus').comments << create(:comment, created_utc: Time.now - 20.days)
    create(:product, title: 'yearly laptop', brand: 'Dell').comments << create(:comment, created_utc: Time.now - 200.days)

    visit "/products" 

    click_link "Past week"
    click_link "Asus ("
    
    expect(page).to have_text("weekly Asus laptop")
    expect(page).to_not have_text("weekly Dell laptop")
    expect(page).to_not have_text("monthly laptop")
    expect(page).to_not have_text("yearly laptop")
  end
end
