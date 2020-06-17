# frozen_string_literal: true

require Rails.root.join('lib', 'logger', 'task_logger.rb')

namespace :maintenance do
  MAINTENANCE_DIR = Rails.root.join('tmp', 'maintenance')
  logger = Logger::TaskLogger.new('maintenance')

  desc 'set maintenance start time, end date and start maintenance'
  task :start, ['start_at', 'end_at'] do |_, args|
    if args.start_at.blank? || args.end_at.blank?
      logger.info 'メンテナンスの開始時間と終了時間を入力してください'
      p 'メンテナンスの開始時間と終了時間を入力してください'
      exit
    end

    if Dir.exist?(MAINTENANCE_DIR)
      logger.info '前回のメンテナンスが終了しておりません。前回のメンテナンスを終了させる場合はrake maintetance:endを実行してください'
      p '前回のメンテナンスが終了しておりません。前回のメンテナンスを終了させる場合はrake maintetance:endを実行してください'
      exit
    end

    Dir.mkdir(MAINTENANCE_DIR)
    File.open("#{MAINTENANCE_DIR}/timing.txt", 'w') do |file|
      file.write("start_at => #{args.start_at}\n")
      file.write("end_at => #{args.end_at}")
    end

    logger.info "メンテナンス開始時間を#{args.start_at} ~ #{args.end_at}で設定しました"
    p "メンテナンス開始時間を#{args.start_at} ~ #{args.end_at}で設定しました"
  end

  desc 'end maintenance'
  task :end do
    FileUtils.rm_rf(MAINTENANCE_DIR)
    logger.info 'メンテナンスを終了しました'
    p 'メンテナンスを終了しました'
  end
end
