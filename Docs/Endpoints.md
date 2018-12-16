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

## HTTP Methods

- `HTTP GET    /users` — get list of all users
- `HTTP POST   /users` — create new user
- `HTTP GET    /users/{id}` — get info about specific user
- `HTTP PUT    /users/{id}` — update info about specific user
- `HTTP DELETE /users/{id}` — delete specific user
- `HTTP GET    /users/{id}/collections` — get list of all collections
- `HTTP POST   /users/{id}/collections` — create new collection
- `HTTP GET    /users/{id}/collections/{id}` — get info about specific collection
- `HTTP PUT    /users/{id}/collections/{id}` — update info about specific collection
- `HTTP DELETE /users/{id}/collections/{id}` — delete specific collection
- `HTTP GET    /users/{id}/decks` — get list of all decks
- `HTTP POST   /users/{id}/decks` — create new deck
- `HTTP GET    /users/{id}/decks/{id}` — get info about specific deck
- `HTTP PUT    /users/{id}/decks/{id}` — update info about specific deck
- `HTTP DELETE /users/{id}/decks/{id}` — delete specific deck
- `HTTP GET    /users/{id}/folders` — get list of all deck folders
- `HTTP POST   /users/{id}/folders` — create new deck folder
- `HTTP GET    /users/{id}/folders/{id}` — get info about specific deck folder
- `HTTP PUT    /users/{id}/folders/{id}` — update info about specific deck folder
- `HTTP DELETE /users/{id}/folders/{id}` — delete specific deck folder
