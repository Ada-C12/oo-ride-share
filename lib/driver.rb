class Driver 
  
  def initialize(id:,name:,vin:,status:,trips:[])
    super(id)
    @id = id 
    @name = name 
    
    
    @trips = trips 
    
    if status == :AVAILABLE || status == :UNAVAILABLE
      @status = status 
    else 
      raise ArgumentError 
    end 
    if vin.length == 17 
      @vin = vin 
    else 
      raise ArgumentError
    end 
      
  end 
      
    
    
  end 
  