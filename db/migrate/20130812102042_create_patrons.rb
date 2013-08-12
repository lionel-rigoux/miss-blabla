class CreatePatrons < ActiveRecord::Migration
  def change
    create_table :patrons do |t|
      t.string  :societe
      t.string  :siren
      t.text    :adresse
      t.references :agent       
      t.timestamps
    end
    
    main_agent=Agent.create()
    Patron.create(agent_id: main_agent.id)
    
    
  end
end
