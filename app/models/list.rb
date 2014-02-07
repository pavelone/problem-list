class List < ActiveRecord::Base
  has_no_table
  
  column :search_string, :string
  column :xmldoc, :Document

  def search_problem()
    
    num_of_results = 20
    num_of_dym = 5
    xml_or_json = 1 # 1 - XML, 2 - JSON
    
    imo_host = ENV["IMO_HOST"]
    imo_port = ENV["IMO_PORT"]
    org_id = ENV["ORG_ID"]
    
    Rails.logger.info(imo_host)
    
    #patient data
    patient_sex = 'M' # 'M' or 'F', for GENDER_FLAG
    patient_age = 35 # in years, for AGE_FLAG
    # (1 = Newborn (<1) 2 = Pediatric (0 – 17 inclusive) 3 = Adult (15 – 124 inclusive) 4 = Maternity (12 – 55 inclusive))
    #MCC_FLAG
    #CC_FLAG
    if patient_sex == "M"
      gflag = "GENDER_FLAG='M'"
    elsif patient_sex == "F"
      gflag = "GENDER_FLAG='F'"
    end
  
    if patient_age < 1
      aflag = "AGE_FLAG=1"
    elsif patient_age <= 17
      aflag = "AGE_FLAG=2"
    elsif patient_age
      aflag = "AGE_FLAG=3"
    end
  
    flags = ""
    if gflag
      flags = gflag
      if aflag
        flags = gflag + "&" + aflag
      end
    elsif aflag
      flags = aflag
    end    

    serv = TCPSocket.open(imo_host , imo_port)

    local, peer = serv.addr, serv.peeraddr

      
      #to_send = "search^"+num_of_results.to_s+"|"+num_of_dym.to_s+"|"+xml_or_json.to_s+"|1^"+search+"^"+org_id+"^"+flags #with flags
      to_send = "search^"+num_of_results.to_s+"|"+num_of_dym.to_s+"|"+xml_or_json.to_s+"|1^"+self.search_string+"^"+ org_id # 1 is the page 

      serv.puts(to_send)
      serv.flush

      sleep(0.5) # TODO: find out how to handle without delays
      
      response_size_bytes = ""
      response_size_bytes = serv.read_nonblock(4)
      response_size_bits = response_size_bytes.unpack('B*')[0]
      response_size = response_size_bits.to_i(2)

      response_xml = ""

      sleep(0.5)
      response_xml += serv.read_nonblock(response_size)
      
      self.xmldoc = Document.new(response_xml)

  end
  
end
  
