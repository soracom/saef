---
title: "MTU Value Configuration Now Available in Soracom User Console"
labels: Feature, Announcement
japanOnly: false
publishOn: 2025-11-20T10:00:00+09:00
isDraft: true
---

Soracom previously did not advertise an MTU (Maximum Transmission Unit) value to devices, so they relied on their implementation defaults (typically 1500 bytes). You can now configure the MTU per SIM group from the Soracom User Console so that the network advertises the value that best fits each deployment.

## Why MTU control matters

MTU represents the largest IP packet that can traverse a link without being fragmented. When packets exceed the announced MTU, the cellular network must split them or drop them outright, which adds protocol headers, increases retransmission risk, and can prevent applications from communicating at all. Deployments that rely on VPN tunnels, private routes, or embedded devices with smaller buffers often had to work around the previous fixed MTU, leading to chronic fragmentation and lower throughput.

## Benefits of customizing the MTU

By selecting an MTU that matches the rest of your network, you can keep packet sizes consistent end to end and avoid unnecessary fragmentation. Set a smaller value for VPN tunnels or other constrained links, while keeping the default for groups where the entire network between the device and its peers can accommodate larger packets.

Setting the appropriate MTU delivers the following benefits:

- Reduces unnecessary fragmentation and retransmissions, preventing throughput loss on cellular links.
- Prevents packet drops or application outages caused by MTU mismatches, reducing troubleshooting overhead.

> Some devices do not support MTU updates advertised by the network and will continue operating with their default value (typically 1500 bytes). Confirm device specifications before rolling out changes.

For UI steps, API/CLI payload examples, and tips on verifying the right value (for example with `ping`), see [IP Link MTU Configuration](https://developers.soracom.io/en/docs/air/ip-link-mtu/).

Please contact [Soracom Support](https://support.soracom.io/hc/en-us/requests/new) if you have any questions.

