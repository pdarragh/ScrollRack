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
| scryfall_id | binary(16) | UUID of the associated card on Scryfall |
| play_condition | tinyint(4) | numeric description of the play condition |
| foil | bit(1) | whether the card is a foil |
| added | timestamp | timestamp when the card was first added |
| modified | timestamp | timestamp when the card was last modified |
| user_id | int(11) | ID of the user who owns the card |
| user_index | int(11) | sequential numbering of cards relative to each user |

### Collections

| Name | Type | Purpose |
|---|---|---|
| id | int(11) | unique identifier |
| name | varchar(32) | name of collection |
| user_id | int(11) | ID of the user who owns the collection |
| user_index | int(11) | sequential numbering of collections relative to each user |

### Deck Folders

| Name | Type | Purpose |
|---|---|---|
| id | int(11) | unique identifier |
| name | varchar(32) | name of deck folder |
| user_id | int(11) | ID of the user who owns the deck folder |
| user_index | int(11) | sequential numbering of deck folders relative to each user |

### Decks

| Name | Type | Purpose |
|---|---|---|
| id | int(11) | unique identifier |
| name | varchar(32) | name of deck |
| user_id | int(11) | ID of the user who owns the deck |
| user_index | int(11) | sequential numbering of decks relative to each user |

### Users

| Name | Type | Purpose |
|---|---|---|
| id | int(11) | unique identifier |
| username | varchar(32) | name of user |
| pw_hash | binary(32) | hash of user's password |
| pw_salt | binary(32) | salt for hashing user's password |
| email | varchar(320) | user's email address |
