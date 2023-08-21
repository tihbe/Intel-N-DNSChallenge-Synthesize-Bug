#!/bin/bash

# This script reproduces the bug in the following issue: https://github.com/IntelLabs/IntelNeuromorphicDNSChallenge/issues/17

# Make sure IntelNeuromorphicDNSChallenge is cloned recursively
git submodule update --init --recursive

# Create venv and install dependencies
python3 -m venv venv
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    source venv/bin/activate
elif [[ "$OSTYPE" == "msys" ]]; then # Best effort to support windows
    source venv/Scripts/activate
fi

pip install -r IntelNeuromorphicDNSChallenge/requirements.txt
pip install numpy==1.24 # Latest version of numba doesn't support latest version of numpy as of 21-08-2023

# Update resample command line to support latest librosa
sed -i 's/librosa.resample(input_audio, fs_input, fs_output)/librosa.resample(input_audio, orig_sr=fs_input, target_sr=fs_output)/g' IntelNeuromorphicDNSChallenge/microsoft_dns/noisyspeech_synthesizer_singleprocess.py

# Run the script, only generate 0.05 hours of data
python IntelNeuromorphicDNSChallenge/noisyspeech_synthesizer.py -root ./ -total_hours 0.05
python IntelNeuromorphicDNSChallenge/noisyspeech_synthesizer.py -root ./ -is_validation_set true -total_hours 0.05