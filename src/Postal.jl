module Postal

import libpostal_jll: libpostal, libpostal_data

include("setup.jl")
include("download_data.jl")
include("expand.jl")

include("parse.jl")

function __init__()
    if Threads.nthreads() > 1
        @warn "Libpostal is not thread safe but running with multiple threads; ensure you do not call libpostal from multiple threads"
    end

    @eval const _status = PostalStatus(false, false)
end

export setup_libpostal

end
