#defmodule defines modules
#using single line functions
defmodule MeterConverter do
  def convert(:feet, m), do: m * 3.28084
  def convert(:inch, m), do: m * 39.3701
  def convert(:yard, m), do: m * 1.09361
end

# #using function clauses
# defmodule LengthConverter do
#   def convert(:feet, m) do
#     m * 3.28084
#   end

#   def convert(:inch, m) do
#     m * 39.3701
#   end
# end



# #defmodule defines a module
# #using flattening
# defmodule MeterConverter.Foot do
#     def convert(m) do
#       m * 3.28084
#     end
# end


# defmodule MeterConverter.Inch do
#   def convert(m) do
#     m * 39.3701
#   end
# end



# #defmodule defines a module
# #nested modules
# defmodule LengthCoverter do

#   defmodule Foot do
#     def convert(m) do
#       m * 3.28084
#     end
#   end

#   defmodule Inch do
#     def convert(m) do
#       m * 39.3701
#     end
#   end

# end


# defmodule LengthCoverter do
#   def meters_to_foot(m) do
#     m * 3.28084
#   end
# end
