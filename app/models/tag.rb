class Tag < ParseResource::Base
  fields :name
  #belongs_to :venue
  #belongs_to :event

  def to_pointer
    klass_name = self.class.model_name.to_s
    {"__type" => "Pointer", "className" => klass_name.to_s, "objectId" => self.id}
  end

end
