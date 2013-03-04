module XbindR
	class DNAPrediction
		class self
			def do_predict res_arr
				p = DNAPrediction.new res_arr
				p.predict_chain!
				return p.res_status
			end
		end

		attr_accessor :res_arr, :res_status

		def initialize(res_arr)
			self.res_arr = res_arr
		end

		def predict_chain!
		end

		def pssm
			#pass
		end
	end
end
