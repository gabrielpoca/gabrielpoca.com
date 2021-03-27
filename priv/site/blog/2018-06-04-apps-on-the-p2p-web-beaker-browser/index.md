---
title: Apps on the P2P Web - Beaker Browser
date: 2018-06-04
cover: "<%= Path.dirname(@input_file) <> "/_bg.jpg" %>"
layout: "_includes/post_layout.slime"
tag:
  - post
---

The [Beaker Browser](https://beakerbrowser.com/) is a peer-to-peer browser to
navigate the decentralized web. With this browser, you no loner need Dropbox to
send a file across the room. With the Beaker Browser you no longer need AWS to
host a website because you can host one from your own machine.

Behind the scenes, the Beaker Browser uses [Dat](https://datproject.org/), a
data sharing protocol. Each website you host, or read, could be a Dat archive.
You can create as many archives as you want, and each will have a public key
that you can share with others so they can access your website, or web app.

If you’re hosting a website from your computer, every change you make will
propagate automatically. In fact, if you’re reading a website you own, the
Beaker Browser has APIs that allow your webiste to change its own source code.
You can also fork someone’s website and host your version of it.

If you were building Twitter in this fashion, your tweets could be a JSON file
in the website's archive. Each tweet would be appended to the list of tweets. If
someone has access to your website, they can take your JSON file, merge it with
theirs and create a feed. You can take a group of people writing to their own
archive and merge all their tweets in your feed.

This is how [Rotonde](https://github.com/Rotonde/rotonde-client) works: everyone
has a feed and a link to the feeds they follow. When you write something on this
network it will update a file on your computer. When you follow someone, you use
their website’s address to find their feed and display it.

This is an interesting new paradigm for me, and in this this series, Apps on the
P2P web, I’m going to recreate, as far as I can, existing web application in a
peer-to-peer fashion.

In my next blog post I’m going to build something that I use a lot:
[Splitwise](https://splitwise.com).
