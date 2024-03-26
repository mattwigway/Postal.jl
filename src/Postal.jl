module Postal

import libpostal_jll: libpostal, libpostal_data
import EnumX: @enumx

include("setup.jl")
include("download_data.jl")
include("expand.jl")
include("parse.jl")
include("duplicate.jl")

export setup_libpostal, expand_address, parse_address, teardown_libpostal

end
