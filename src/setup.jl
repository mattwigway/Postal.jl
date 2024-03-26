mutable struct PostalStatus
    setup::Bool
    torn_down::Bool
end

function setup_libpostal(data_path::String)
    if _status.setup
        error("Libpostal already set up")
    end

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

    _status.setup = true
end