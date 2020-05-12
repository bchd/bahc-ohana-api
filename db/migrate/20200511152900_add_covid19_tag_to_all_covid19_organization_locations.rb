class AddCovid19TagToAllCovid19OrganizationLocations < ActiveRecord::Migration[5.1]
  def up
    organization = Organization.find_by(name: 'COVID-19 Resources')
    return nil if organization.nil?
    locations = organization.locations
    tag = Tag.find_or_create_by(name: 'covid-19')
    locations.each do |location|
      unless location.tags.include?(tag)
        location.tags << tag
      end
    end
  end

  def down
    organization = Organization.find_by(name: 'COVID-19 Resources')
    return nil if organization.nil?
    locations = organization.locations
    tag = Tag.find_or_create_by(name: 'covid-19')
    locations.each{|location| location.tags.delete(tag)}
  end
end
