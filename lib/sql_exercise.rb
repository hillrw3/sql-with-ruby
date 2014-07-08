require "database_connection"

class SqlExercise

  attr_reader :database_connection

  def initialize
    @database_connection = DatabaseConnection.new
  end

  def all_customers
    database_connection.sql("SELECT * from customers")
  end

  def limit_customers(number)
    if number.is_a?(String)
      puts "Don't fuck with my database..."
    else
      database_connection.sql("SELECT * from customers LIMIT #{number}")
    end
  end

  def order_customers(order)
    if order.is_a?(String) && order.upcase.include?("DROP TABLE")
      puts "Don't fuck with my database..."
    else
      database_connection.sql("SELECT * from customers ORDER BY name #{order}")
    end
  end

  def id_and_name_for_customers
    database_connection.sql("SELECT id, name from customers")
  end

  def all_items
    database_connection.sql("SELECT * from items")
  end

  def find_item_by_name(item_name)
    if item_name.is_a?(String) && item_name.upcase.include?("DROP TABLE")
      puts "Don't fuck with my database..."
    else
      database_connection.sql("SELECT * from items WHERE name = '#{item_name}'").pop
    end
  end

  def count_customers
    database_connection.sql("SELECT * from customers").count
  end

  def sum_order_amounts
    sum = database_connection.sql("SELECT sum(amount) from orders").pop
    sum["sum"].to_f
  end

  def minimum_order_amount_for_customers
    database_connection.sql("SELECT customer_id, MIN(amount) from orders GROUP BY customer_id")
  end

  def customer_order_totals
    database_connection.sql("SELECT customers.id, customers.name, SUM(orders.amount) from orders JOIN customers ON orders.customer_id = customers.id GROUP BY customers.id")
  end

  def items_ordered_by_user(id)
    output = database_connection.sql("SELECT items.name FROM orderitems JOIN items ON (orderitems.item_id = items.id) JOIN orders ON (orderitems.order_id = orders.id AND orders.customer_id = #{id})")
    final = []
    output.each { |hash| final << hash["name"] }
    final
  end

  def customers_that_bought_item(item)
    database_connection.sql("SELECT customers.name, customers.id FROM customers JOIN orders ON customers.id = orders.customer_id JOIN orderitems ON orders.id = orderitems.order_id JOIN items ON orderitems.item_id = items.id WHERE items.name = '#{item}' GROUP BY customers.id")
  end



  def customers_that_bought_item_in_state(item, state)
    database_connection.sql("SELECT customers.* FROM customers JOIN orders ON customers.id = orders.customer_id JOIN orderitems ON orders.id = orderitems.order_id JOIN items ON orderitems.item_id = items.id WHERE items.name = '#{item}' AND customers.state = '#{state}' LIMIT 1").pop
  end
end
