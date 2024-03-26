mutable struct PostalStatus
    setup::Bool
    torn_down::Bool
end

function __init__()
    if Threads.nthreads() > 1
        @warn "Libpostal is not thread safe but running with multiple threads; ensure you do not call libpostal from multiple threads"
    end

    @eval const _status = PostalStatus(false, false)
end

function check_postal_setup()
    Postal.status.setup || error("libpostal_setup not run")
    Postal.status.torn_down && error("libpostal already torn down (restart julia)")
end

function setup_libpostal(data_path::String)
    Postal._status.setup && error("Libpostal already set up")
    Postal._status.torn_down && error("Libpostal already torn down (restart julia)")

    setup_stat = @ccall libpostal.libpostal_setup_datadir(data_path::Cstring)::Bool

    if !setup_stat
        error("Libpostal setup failed")
    end

    parser_stat = @ccall libpostal.libpostal_setup_parser_datadir(data_path::Cstring)::Bool

    if !parser_stat
        error("Libpostal parser setup failed")
    end

    class_stat = @ccall libpostal.libpostal_setup_language_classifier_datadir(data_path::Cstring)::Bool

    if !class_stat
        error("Libpostal language classifier setup failed")
    end

    Postal._status.setup = true
end

function teardown_libpostal()
    @ccall libpostal.libpostal_teardown()::Cvoid
    @ccall libpostal.libpostal_teardown_parser()::Cvoid
    @ccall libpostal.libpostal_teardown_classifier()::Cvoid
    Postal._status.torn_down = true
end