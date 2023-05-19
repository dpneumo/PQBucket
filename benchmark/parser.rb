class Parser
  def initialize(test: true)
    @benchmark_data = "#{File.dirname(__FILE__)}/benchmark_results.txt"
    @r_data = Regexp.new( '(size|user|find|pull).* (\d+\.?\d+)?\)?' )
  end

  def parse_file
    data = data_hash
    marking = false
    size = ''
    File.foreach(@benchmark_data).map do |line|
      line.chomp.
      scan(@r_data) do |md|
        case $1
        when 'size' then size = $2.to_i
        when 'user' then marking = true
        when 'find'   then data[size][$1] << $2.to_f if marking
        when 'pull'   then data[size][$1] << $2.to_f if marking; marking = false
        end
      end
    end
    data
  end

  def means
    pd = Hash.new do |h,size|
      h[size] = Hash.new do |h1,method|
        h1[method] = nil
      end
    end
    parse_file.each do |size, method_hash|
      method_hash.each do |method, times|
        mean = times.sum(0.0)/times.size
        pd[size][method] = mean.round(6)
      end
    end
    pd
  end

  def time_plotdata
    pd = { 'find' => [], 'pull' => [], 'insert' => [] }
    means.each do |size, mthd_data|
      mthd_data.each do |method, mean_time|
        pd[method] << [size.to_s, mean_time.to_s]
      end
    end
    pd
  end

  private
    def data_hash
      Hash.new do |h,size|
        h[size] = Hash.new do |h1,method|
          h1[method] = []
        end
      end
    end
end
