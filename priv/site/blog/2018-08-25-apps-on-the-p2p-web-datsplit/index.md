---
title: Apps on the P2P Web - DatSplit
date: 2018-08-25
cover: ./bg.jpg
layout: "_post_layout.slime"
tag:
  - post
---

_This blog post is the second in the series Apps on the P2P web. If you are not familiar with Dat or the Beaker Browser, I recommend reading the [introduction blog post](/2018-06-04-apps-on-the-p2p-web-beaker-browser) first._

In this blog post, we are building a decentralised clone of [Splitwise](https://www.splitwise.com/) that runs on the [Beaker Browser](https://beakerbrowser.com/). Splitwise is a service where a group of people can keep track of shared expenses. You can add expenses to a group, and Splitwise tells you who owes what to whom.

I've selected some features for us to implement that prove that a lot of what Splitwise does can be accomplished in the Beaker Browser:

- Create groups.
- Invite members to a group.
- Join an existing group.
- Add expenses to a group.
- Calculate how much each person owes to the group.

I’m calling my application **DatSplit**. The [source code is here](https://github.com/gabrielpoca/datsplit) and the [application is here](dat://datsplit-gabrielpoca.hashbase.io/) (it requires the Beaker Browser).

## Privacy

Our priority is privacy. We have to make sure that only the members of a group
can see and share the groups' data. This is were Dat comes it: each Dat archive
is given a public and a private key. You use the public key to share the
archive. When you have a public key, Dat will hash it to create a discovery key,
that it uses to ask the network for data. This means that only the people you
give the public key to will be able to access the information on it.

Dat guarantees privacy on the network, but what about privacy between groups that have members in common? This an issue that we solve we proper design. In a scenario where you belong to two groups you would have three Dat archives:

- a private archive for the first group
- a private archive for the second group
- and a public archive for DatSplit's code that anyone can see. The code in this archive will use Beaker Browser's APIs to create group archives, and it will keep a reference to them in localStorage. As long as those references stay in the localStorage, no one can see it, and the groups stay isolated.

## What is a group?

A group is a list of people and expenses. To be in a group, you need an archive
where you can keep track of expenses and members. You and the other members will exchange public keys and add each other in your archives. You will add expenses to your archive, and check the other members' archives for new expenses, that you will merge into yours. This is how expenses are propagated between members. We can put some mechanisms in place for you to approve expenses from someone else that involve you.

## What is in a group?

With the public key to a Dat archive, you can see every file and folder in it.
Each group will a file named _data.json_ where DatSplit keeps track of the
expenses and members. We are calling this file the database.

A member synchronises with the group by looking in the databases of the other
members for changes and applying them to his database. To make this process
easier our database will be an [event store](http://www.cqrs.nu/Faq/event-sourcing). On an event store, we keep
track of changes (events) to our database instead of its current state. A change
is an event that indicates that something happened. We never delete the events.
If all our database has is a list of events, it's simple to find what events are
new since the last time we checked.

Our database will have events of the following types:

- Add Peer
- Add Transaction

We could have other events such as "Approve Peer" and "Approve Transaction" to inform the members of who agree with an action.

Each event has the following structure:

- unique uuid
- public key of the person who created
- payload

Here’s an example:

```json
{
  "type": "PEER_ADDED",
  "payload": {
    "name": "Gabriel",
    "url": "dat://e3503b270839c7df"
  },
  "uuid": "3ca7665b-b6cd-46f6-8722-743c0a1b2bfa",
  "url": "dat://e3503b270839c7df"
}
```

We could include a signature of the payload to make sure no one is creating
events in someone else's name. I think the [Web Crypto API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Crypto_API) would be the perfect fit for this.

## Current state projection

Event stores are great to keep track of changes, but they are hard to query. We
need the current state of the group so we can build an interface to interact
with it. For that, we need a projection that transforms our events into
something like this:

```js
{
  peers: [...]
  transactions: [...]
}
```

The projection listens for new events on the event store and processes them to
create the current state.

```js
class Projection {
  constructor(eventStore) {
    this.state = { peers: {}, transactions: {}, name: "Me" };

    eventStore.onChange(this.processEvents);
  }

  processEvents(events) {
    events.map(this.processEvent);
  }

  processEvent(event) {
    const state = { ...this.state };

    switch (event.type) {
      case "TRANSACTION_ADDED": {
        const { description, from, to, amount, currency, id } = event.payload;

        const transaction = extend({
          description,
          from,
          to,
          amount,
          currency,
          id,
          date: event.timestamp,
        });

        state.transactions[id] = transaction;
        break;
      }
      case "PEER_ADDED": {
        const { name, url } = event.payload;

        if (!state.peers[url]) {
          state.peers[url] = { name, url };
        }

        break;
      }
      default:
        break;
    }

    this.state = state;
  }

  //more code
}
```

## Reading and writing databases

Now that we understand the how the database works, we can get our hands dirty
with the Beaker Browser's APIs.

We start by creating and initializing a group:

```js
// create dat archive
DatArchive.create({
  title: "My new DatSplit group",
}).then((archive) => {
  const { url } = archive;

  // save to localstorage
  const groups = JSON.stringify([url]);
  localStorage.setItem("DatSplitGroups", groups);

  // create an event to add the current user
  const addPeerEvent = addPeer(url, {
    name: getName(),
    url,
  });

  // write to data.json an object with an array of events on the key "events"
  archive.writeFile("data.json", JSON.stringify({ events: [addPeerEvent] }));
});
```

Now that we have a group, we can write events to it:

```js
// we don't want to overwrite existing events, so we first read the existing events
const events = JSON.parse(await archive.readFile('/data.json')).events

// push a new event
events.push({
  type: 'TRANSACTION_ADDED",
  uuid: newID(), // generates a unique id
  url: url, // current user's URL
  payload: { ... ], // details about the transaction
  timestamp: new Date(), // current date
})

// write to the database
archive.writeFile('/data.json',JSON.stringify({ events }));
```

When we exchange public keys with another member, we can read his database and
merge new events into ours:

```js
// instantiate an archive
const member2URL = `...`;
const member2Archive = new DatArchive(member2URL);

// read and filter events we already have
const member2Events = JSON.parse(await member2Archive.readFile("/data.json"))
  .events;
const newEvents = member2Events.filter(filterNewEvents);

// merge with existing events
events.push(newEvents);

// write to the database
archive.writeFile("/data.json", JSON.stringify({ events }));
```

This code could run periodically to keep the databases up to date.

## Conflict Resolution

You may be wondering about conflict resolution, but there’s no need for conflict
resolution because there are no conflicting updates! The database is an
append-only log, and the events’ order is not relevant. We need to keep track of
what happened, not when it happened.

## Closing thoughts

The purpose of this blog post is to give a quick overview on what we can do with
the Beaker Browser and which APIs to use. I promise to try and answer any
question you have. You can find the [source code here](https://github.com/gabrielpoca/datsplit) and the [application here](dat://datsplit-gabrielpoca.hashbase.io/) (open in the Beaker Browser).

We could build a lot of functionality on top of these primitives. There could be
a system in place where you had to send an event to accept new members or
transactions. You could leverage the Web Crypto API to make sure no one is
adding events in someone else's name.

Unfortunately, the Beaker Browser doesn't seem to have enough adoption yet to build these type of applications. We could make so much without centralised
systems.

See you next time!
