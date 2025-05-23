namespace :uploads do
  desc "清理 uploads 文件夹中多余的图片，只保留最新的 50 张"
  task cleanup: :environment do
    upload_dir = Rails.root.join("public", "uploads")
    max_files = 5

    # 获取所有匹配 screenshot_*.png 的文件
    files = Dir.glob("#{upload_dir}/screenshot_*.png")

    # 根据文件名中的时间戳排序（从旧到新）
    sorted_files = files.sort_by do |f|
      f.match(/screenshot_(\d+)\.png/)[1].to_i rescue 0
    end

    # 删除多余的文件
    if sorted_files.size > max_files
      to_delete = sorted_files[0, sorted_files.size - max_files]
      to_delete.each do |file|
        File.delete(file)
        puts "删除了: #{file}"
      end
      puts "共删除 #{to_delete.size} 张图片，保留最新 #{max_files} 张"
    else
      puts "图片总数为 #{sorted_files.size}，未超过限制"
    end
  end
end
