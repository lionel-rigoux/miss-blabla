class ChangeRetourToInvoice < ActiveRecord::Migration[5.1]
  def up
    add_reference :retours, :commande, foreign_key: true

    retours = ActiveRecord::Base.connection.execute('SELECT id, client_id FROM retours')
    ActiveRecord::Base.transaction do
      retours.each do |r|
        first_commande = ActiveRecord::Base.connection.execute(
            """
              SELECT id
              FROM commandes
              WHERE client_id = '#{r["client_id"]}'
              LIMIT 1
            """
          )
        ActiveRecord::Base.connection.execute(
          """
            UPDATE retours
            SET commande_id = '#{first_commande[0]["id"]}'
            WHERE id = #{r["id"]}
          """
        )
      end
    end

    remove_reference :retours, :client
  end

  def down

    add_reference :retours, :client, foreign_key: true

    retours = ActiveRecord::Base.connection.execute('SELECT id, commande_id FROM retours')
    ActiveRecord::Base.transaction do
      retours.each do |r|
        client = ActiveRecord::Base.connection.execute(
            """
              SELECT client_id
              FROM commandes
              WHERE id = '#{r["commande_id"]}'
            """
          )
        ActiveRecord::Base.connection.execute(
          """
            UPDATE retours
            SET client_id = '#{client[0]["id"]}'
            WHERE id = #{r["id"]}
          """
        )
      end
    end

    remove_reference :retours, :commande
  end


end
