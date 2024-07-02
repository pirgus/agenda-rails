namespace :utils do

  desc "Populate database"
  task seed: :environment do
    puts "Gerando os contatos seed de contato (Contacts)..."
    100.times do |i|
      Contact.create!(name: Faker::Name.name,
                      email: Faker::Internet.email,
                      kind: Kind.all.sample,
                      rmk: Lerolero.produzirfraselerolero(1)
      )
                      # rmk: Faker::Lorem.sentence(word_count: 6))
    end
    # t.string :name
    # t.string :email
    # t.references :kind, null: false, foreign_key: true
    # t.text :rmk

    puts "Gerando os contatos seed de contato (Contacts)... - OK"

    # t.string :street
    # t.string :city
    # t.string :state
    # t.references :contact, null: false, foreign_key: true
    puts "Gerando os endereços seed de contato (Addresses)..."
    Contact.all.each do |contact|
      # criando endereco para cada contato
      Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state_abbr,
        contact: contact
      )
    end

    puts "Gerando os endereços seed de contato (Addresses)... - OK"

    puts "Gerando os telefones seed de contato (Phones)..."
    Contact.all.each do |contact|
      # criando telefone para cada contato
      Random.rand(5).times do |i|
        Phone.create!(
          contact: contact,
          phone: Faker::PhoneNumber.cell_phone
        )
      end
    end

    puts "Gerando os telefones seed de contato (Phones)... - OK"

  end

end
