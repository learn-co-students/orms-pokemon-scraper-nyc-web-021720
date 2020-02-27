class Pokemon

    attr_accessor :id, :name, :type, :db

    def initialize(name:, type:, db:, id: nil)
        @name = name
        @type = type
        @id = id
    end

    def self.save(name, type, db)
        sql = <<-SQL
            insert into pokemon (name, type)
            values(?, ?)
        SQL

        db.execute(sql, name, type)
        @id = db.execute("select last_insert_rowid() from pokemon;")[0][0]
    end

    def self.find(id_param, db)
        sql = <<-SQL
            select *
            from pokemon
            where id = ?
        SQL

        db.execute(sql, id_param).map do |row|
            Pokemon.new_from_db(row)
        end.first
    end

    def self.new_from_db(row)
        pokemon = Pokemon.new({name: row[1], type: row[2], db: nil, id: row[0]})
    end
end
