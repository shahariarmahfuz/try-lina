#!/bin/bash
set -e

echo "Starting tailscaled..."
# কন্টেইনারের ভেতর TUN ডিভাইস না থাকলেও যেন কাজ করে সেজন্য userspace-networking দেওয়া হয়েছে, 
# আর সরাসরি ডিভাইস মাউন্ট থাকলে এটি কার্নেল মোডে কাজ করবে।
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

# ডেইমন চালু হওয়ার জন্য ২ সেকেন্ড অপেক্ষা
sleep 2

if [ -z "$TS_AUTHKEY" ]; then
    echo "Error: TS_AUTHKEY environment variable deya hoyni!"
    exit 1
fi

echo "Connecting to Tailscale with SSH enabled..."
tailscale up --authkey="${TS_AUTHKEY}" --hostname="${TS_HOSTNAME:-docker-ubuntu}" --ssh

echo "Tailscale SSH is ready! Container running..."
# কন্টেইনার যেন বন্ধ না হয়ে যায় সেজন্য অনন্তকাল ধরে চালু রাখা
exec sleep infinity
