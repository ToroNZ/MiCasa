# encoding: utf-8
class RenameCategories < ActiveRecord::Migration
  def up
    execute "
    UPDATE categories SET name_pt = 'Gastronomia', name_es = 'Gastronomy' WHERE name_pt = 'Comida';
    UPDATE categories SET name_pt = 'Ciência e Tecnologia', name_es = 'Science & Technology' WHERE name_pt = 'Tecnologia';
    "
  end

  def down
  end
end
