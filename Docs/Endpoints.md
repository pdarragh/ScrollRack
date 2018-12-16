#  Endpoints

The ScrollRack API is designed to be RESTful (or at least *mostly* RESTful).

## Objects

There are multiple kinds of objects in the ScrollRack API:

- Users
- Cards — specific, individual cards owned by users
- Collections — groupings of a user's cards
- Decks — collections of cards (either owned or otherwise) that represent decks used for play
- Deck Folders — groupings of a user's decks; can be recursive (i.e., a deck folder can contain other deck folders)

## URIs

- `/users` — all the users of ScrollRack
- `/users/{id}` — a specific user
- `/users/{id}/collections` — all of a user's collections
- `/users/{id}/collections/{id}` — a specific collection of cards
- `/users/{id}/decks` — all of a user's decks (a flat list that disregards folders)
- `/users/{id}/decks/{id}` — a specific deck
- `/users/{id}/folders` — all of a user's deck folders
- `/users/{id}/folders/{id}` — a specific deck folder
