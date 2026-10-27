#!/bin/bash

echo "Starting Windows..."
VBoxManage startvm "WS_MNA_win"

echo "Starting Ubuntu..."
VBoxManage startvm "WS_MNA_ubuntu"
