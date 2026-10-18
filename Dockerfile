FROM ubuntu:24.04

# ইন্টারঅ্যাক্টিভ প্রম্পট বন্ধ করা
ENV DEBIAN_FRONTEND=noninteractive

# প্রয়োজনীয় Linux টুলস ইনস্টল করা
RUN apt-get update && apt-get install -y \
    curl \
    sudo \
    git \
    nano \
    vim \
    htop \
    iproute2 \
    iputils-ping \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# অফিশিয়াল স্ক্রিপ্ট দিয়ে Tailscale ইনস্টল করা
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Tailscale স্টেট ডাটা রাখার ফোল্ডার তৈরি
RUN mkdir -p /var/lib/tailscale /var/run/tailscale

# স্টার্টআপ স্ক্রিপ্ট কপি এবং পারমিশন দেওয়া
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
