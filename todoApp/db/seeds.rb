user1 = User.create!(name: 'John', email: 'test@example.com', roles: 'admin', password: 'mypassword')
task1 = Task.find_or_create_by!(title: 'first task', description: 'first', user_id: user1.id)
label1 = Label.create!(name: 'first label')
label2 = Label.create!(name: 'second label')
label3 = Label.create!(name: 'third label')
TaskLabel.create!(task_id: task1.id, label_id: label1.id)
TaskLabel.create!(task_id: task1.id, label_id: label2.id)
