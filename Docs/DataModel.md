#  Data Model

This document explains the data model used for ScrollRack.

## Tables

There are five top-level tables in the schema:

- `cards` — individual cards owned by players
- `collections` — players' collections of cards
- `deck_folders` — players' deck folders
- `decks` — players' decks
- `users` — players

Additionally, there are some relationship tables used to manage many-to-many relationships:

- `cards_TO_collections` — connecting cards from `cards` to collections from `collections`
- `deck_folders_TO_decks` — connecting deck folders from `deck_folders` to decks from `decks`
- `deck_folders_TO_subfolders` — connecting deck folders from `deck_folders` to other deck folders from `deck_folders`
- `friends` — connectings users from `users` to other users from `users`

### Cards

| Name | Type | Purpose |
|---|---|---|
| id | int(11) | unique identifier |
