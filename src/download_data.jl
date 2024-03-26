"""
Download the libpostal training data. This is about a gigabyte, pass in a directory where it can be stored without issues.
"""
function download_data(data_dir)
    run(`$(libpostal_data()) download all $data_dir`);
end