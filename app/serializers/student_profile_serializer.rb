class StudentProfileSerializer
  include FastJsonapi::ObjectSerializer

  attributes :school_name
end
