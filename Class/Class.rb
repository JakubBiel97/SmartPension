class GettingAndSortingLogs	#class declaration
	attr_reader :log

	def initialize(logfile_path)
    file_exists?(logfile_path)

    @logfile_path = logfile_path
		#creating a Hash
    @log = Hash.new {
			 |i, j| i[j] = []
		 }
  end

  def parsing
    return @log if @log.any? #return in case our file is empty

    File.open(@logfile_path).each do |lineIndex|
      webName, ipAdress = *lineIndex.split(/\s+/)
      @log[webName] << ipAdress
    end
  end

	def views
		@views ||=
			view_counter(unique: false).sort_by{ #sorting
			|i, j| -j#from highest to lowest -- if from lowest to highest just delete the "-" sign
		}.to_h

		printingOutput(@views, "Viewers")
		@views
	end

	def uniqViews
		@uniqViews ||=
			view_counter(unique: true).sort_by{ #sorting
			|i, j| -j#from highest to lowest
		}.to_h

			printingOutput(@uniqViews, "Unique Viewers")
			@uniqViews
	end

	private
	def file_exists?(path)#error with no file or wrong path
		raise "Lack of input file" unless File.exists? path
	end

#counter for our views
	def view_counter(unique:)
		@log.each_with_object({}) do |(key, value), obj|
		obj[key] = unique ? value.uniq.size : value.size
		end
	end

#some nice output printing to console
		def printingOutput(obj, x)
			#some additional space in console output
			puts ""
			puts "Name\t\t" + x
			obj.each do |(name, counter)|
				puts name.ljust(16) + counter.to_s
				end
		end
end
