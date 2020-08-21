class ChangeQuantiteDetailFromYamlToJson < ActiveRecord::Migration[5.1]
  def up
    updated_quantites = fetch_quantites.map do |r|
      {
        id: r['id'],
        detail: escape_sql(JSON.dump(YAML.load(r['detail'])))
      }
    end

    remove_column :quantites, :detail
    add_column :quantites, :detail, :json

    ActiveRecord::Base.transaction do
      updated_quantites.each do |ur|
        ActiveRecord::Base.connection.execute(
          """
            UPDATE quantites
            SET detail = '#{ur[:detail]}'::json
            WHERE id = #{ur[:id]}
          """
        )
      end
    end
  end

  def down
    updated_quantites = fetch_quantites.map do |r|
      {
        id: r['id'],
        detail: escape_sql(YAML.dump(JSON.parse(r['detail'])))
      }
    end

    remove_column :quantites, :detail
    add_column :quantites, :detail, :text

    ActiveRecord::Base.transaction do
      updated_quantites.each do |ur|
        ActiveRecord::Base.connection.execute(
          """
            UPDATE quantites
            SET detail = '#{ur[:detail]}'::text
            WHERE id = #{ur[:id]}
          """
        )
      end
    end
  end

  private

  #
  # Returns the id & detail column of the quantites table.
  # @return [PG::Result]
  def fetch_quantites
    ActiveRecord::Base.connection.execute('SELECT id, detail FROM quantites')
  end

  #
  # Returns the SQL escaped version of the string provided
  # For example, a "'" needs to be escaped by doubling it.
  # @param [String] the string to be converted
  # @return [String] the escaped version of the string provided
  def escape_sql(string)
    return string.gsub("'","''")
  end

end
