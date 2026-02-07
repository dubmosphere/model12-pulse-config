#!/bin/bash

systemctl --user daemon-reload
systemctl --user enable --now tascam-remap.service
