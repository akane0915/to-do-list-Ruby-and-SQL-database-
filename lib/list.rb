class List
  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all
    lists = []
    returned_lists = DB.exec('SELECT * FROM lists;')
    returned_lists.each do |list|
      name = list.fetch('name')
      id = list.fetch('id').to_i
      lists.push(List.new({:name => name, :id => id}))
    end
    lists
  end

  def save
    result = DB.exec("INSERT INTO lists (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(another_list)
    (self.name == another_list.name) && (self.id == another_list.id)
  end

  def self.find(identification)
    matched_list = nil
    List.all.each do |list|
      if list.id == identification
        matched_list = list
      end
    end
    matched_list
  end

  def tasks
    list_tasks = []
    tasks = DB.exec("SELECT * FROM tasks WHERE list_id = #{self.id};")
    tasks.each do |task|
      description = task.fetch("description")
      list_id = task.fetch('list_id').to_i
      due_date = task.fetch('due_date')
      list_tasks.push(Task.new({:description => description, :list_id => list_id, :due_date => due_date}))
    end
    list_tasks
  end


end
