FactoryBot.define do
    factory :task1, class: Task do
      title { 'task1' }
      description { '' }
      status { 10 }
    end
    factory :task2, class:Task do
      title { 'task2' }
      description { 'this is 2nd task' }
      status { 20 }
      deadline { Date.today.end_of_month }
    end
  
    factory :task3, class: Task do
      title { 'task3' }
      description { 'this is 3rd task' }
      status { 30 }
      deadline { Date.today.end_of_month }
    end
  end