#!/usr/bin/env bash


pip install .

spotify-ripper \
                -S ./local_config/ \
                -k ./local_config/spotify_appkey.key \
                -u morgaroth \
                -p $1 \
                spotify:user:morgaroth:playlist:4Usjw07BWhqCgRkMiFQmb7
