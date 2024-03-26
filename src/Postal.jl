module Postal

import libpostal_jll: libpostal, libpostal_data

include("setup.jl")
include("download_data.jl")
include("expand.jl")

include("parse.jl")

export setup_libpostal, expand_address, parse_address, teardown_libpostal

end
